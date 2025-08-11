const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const User = require('../models/user.model');
const Pet = require('../models/pet.model');
const { auth } = require('../middleware/auth.middleware');

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadDir = 'uploads/avatars';
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, 'avatar-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB limit
  },
  fileFilter: (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|gif/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);

    if (mimetype && extname) {
      return cb(null, true);
    } else {
      cb(new Error('Only image files are allowed!'));
    }
  }
});

// GET /api/user/profile - Get user profile
router.get('/profile', auth, async (req, res) => {
  try {
    res.json({
      success: true,
      data: {
        user: req.user.getPublicProfile()
      }
    });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to get profile',
      error: error.message
    });
  }
});

// PUT /api/user/profile - Update user profile
router.put('/profile', auth, async (req, res) => {
  try {
    const { name, email, phone, bio, location, preferences } = req.body;
    const updates = {};

    // Validate and add updates
    if (name !== undefined) {
      if (name.length < 2 || name.length > 50) {
        return res.status(400).json({
          success: false,
          message: 'Name must be between 2 and 50 characters'
        });
      }
      updates.name = name;
    }

    if (email !== undefined) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email)) {
        return res.status(400).json({
          success: false,
          message: 'Please enter a valid email address'
        });
      }
      
      // Check if email is already taken by another user
      const existingUser = await User.findOne({ email, _id: { $ne: req.user._id } });
      if (existingUser) {
        return res.status(400).json({
          success: false,
          message: 'This email is already in use'
        });
      }
      updates.email = email;
    }

    if (phone !== undefined) {
      const phoneRegex = /^[\+]?[1-9][\d]{0,15}$/;
      if (!phoneRegex.test(phone)) {
        return res.status(400).json({
          success: false,
          message: 'Please enter a valid phone number'
        });
      }
      updates.phone = phone;
    }

    if (bio !== undefined) {
      if (bio.length > 500) {
        return res.status(400).json({
          success: false,
          message: 'Bio must be less than 500 characters'
        });
      }
      updates.bio = bio;
    }

    if (location !== undefined) {
      if (location.length > 100) {
        return res.status(400).json({
          success: false,
          message: 'Location must be less than 100 characters'
        });
      }
      updates.location = location;
    }

    if (preferences !== undefined) {
      updates.preferences = preferences;
    }

    // Update user
    Object.assign(req.user, updates);
    await req.user.save();

    res.json({
      success: true,
      message: 'Profile updated successfully',
      data: {
        user: req.user.getPublicProfile()
      }
    });
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to update profile',
      error: error.message
    });
  }
});

// POST /api/user/avatar - Upload profile picture
router.post('/avatar', auth, upload.single('avatar'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'No file uploaded'
      });
    }

    // Delete old avatar if exists
    if (req.user.profileImage && req.user.profileImage !== 'default-avatar.jpg') {
      const oldAvatarPath = path.join('uploads/avatars', path.basename(req.user.profileImage));
      if (fs.existsSync(oldAvatarPath)) {
        fs.unlinkSync(oldAvatarPath);
      }
    }

    // Update user's profile image
    req.user.profileImage = req.file.filename;
    await req.user.save();

    res.json({
      success: true,
      message: 'Avatar uploaded successfully',
      data: {
        profileImage: req.file.filename
      }
    });
  } catch (error) {
    console.error('Avatar upload error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to upload avatar',
      error: error.message
    });
  }
});

// DELETE /api/user/account - Delete account
router.delete('/account', auth, async (req, res) => {
  try {
    const { password } = req.body;

    if (!password) {
      return res.status(400).json({
        success: false,
        message: 'Password is required to delete account'
      });
    }

    // Verify password
    const isMatch = await req.user.comparePassword(password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Incorrect password'
      });
    }

    // Delete user's avatar if exists
    if (req.user.profileImage && req.user.profileImage !== 'default-avatar.jpg') {
      const avatarPath = path.join('uploads/avatars', req.user.profileImage);
      if (fs.existsSync(avatarPath)) {
        fs.unlinkSync(avatarPath);
      }
    }

    // Delete user
    await User.findByIdAndDelete(req.user._id);

    res.json({
      success: true,
      message: 'Account deleted successfully'
    });
  } catch (error) {
    console.error('Delete account error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to delete account',
      error: error.message
    });
  }
});

// GET /api/user/pets - Get user's pets
router.get('/pets', auth, async (req, res) => {
  try {
    const { page = 1, limit = 10, status } = req.query;
    const skip = (page - 1) * limit;

    const query = { owner: req.user._id };
    if (status) {
      query.status = status;
    }

    const pets = await Pet.find(query)
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parseInt(limit))
      .populate('owner', 'name email');

    const total = await Pet.countDocuments(query);

    res.json({
      success: true,
      data: {
        pets,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / limit)
        }
      }
    });
  } catch (error) {
    console.error('Get user pets error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to get user pets',
      error: error.message
    });
  }
});

// GET /api/user/adoptions - Get adoption history
router.get('/adoptions', auth, async (req, res) => {
  try {
    const { page = 1, limit = 10, status } = req.query;
    const skip = (page - 1) * limit;

    const query = { 'adoptionRequests.user': req.user._id };
    if (status) {
      query['adoptionRequests.status'] = status;
    }

    const pets = await Pet.find(query)
      .sort({ 'adoptionRequests.createdAt': -1 })
      .skip(skip)
      .limit(parseInt(limit))
      .populate('owner', 'name email');

    const total = await Pet.countDocuments(query);

    // Format adoption requests
    const adoptions = pets.map(pet => {
      const userRequest = pet.adoptionRequests.find(
        request => request.user.toString() === req.user._id.toString()
      );
      return {
        pet: {
          _id: pet._id,
          name: pet.name,
          type: pet.type,
          breed: pet.breed,
          age: pet.age,
          image: pet.image,
          owner: pet.owner
        },
        request: userRequest
      };
    });

    res.json({
      success: true,
      data: {
        adoptions,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / limit)
        }
      }
    });
  } catch (error) {
    console.error('Get adoption history error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to get adoption history',
      error: error.message
    });
  }
});

// GET /api/user/stats - Get user statistics
router.get('/stats', auth, async (req, res) => {
  try {
    const [totalPets, totalAdoptions, pendingAdoptions, approvedAdoptions] = await Promise.all([
      Pet.countDocuments({ owner: req.user._id }),
      Pet.countDocuments({ 'adoptionRequests.user': req.user._id }),
      Pet.countDocuments({ 
        'adoptionRequests.user': req.user._id,
        'adoptionRequests.status': 'pending'
      }),
      Pet.countDocuments({ 
        'adoptionRequests.user': req.user._id,
        'adoptionRequests.status': 'approved'
      })
    ]);

    res.json({
      success: true,
      data: {
        totalPets,
        totalAdoptions,
        pendingAdoptions,
        approvedAdoptions
      }
    });
  } catch (error) {
    console.error('Get user stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to get user statistics',
      error: error.message
    });
  }
});

module.exports = router; 