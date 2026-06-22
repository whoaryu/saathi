const express = require('express');
const router = express.Router();
const Pet = require('../models/pet.model');
const { auth } = require('../middleware/auth.middleware');
const multer = require('multer');
const cloudinary = require('cloudinary').v2;

// Configure Cloudinary
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

// Configure Multer for image upload
const upload = multer({
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB limit
  }
});

// Get all pets with filters
router.get('/', async (req, res) => {
  try {
    const { type, search, minAge, maxAge } = req.query;
    const query = {};

    if (type) query.type = type;
    if (minAge || maxAge) {
      query.age = {};
      if (minAge) query.age.$gte = parseInt(minAge);
      if (maxAge) query.age.$lte = parseInt(maxAge);
    }
    if (search) {
      query.$text = { $search: search };
    }

    const pets = await Pet.find(query)
      .populate('owner', 'name email phone')
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      data: pets
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch pets',
      error: error.message
    });
  }
});

// Get single pet
router.get('/:id', async (req, res) => {
  try {
    const pet = await Pet.findById(req.params.id)
      .populate('owner', 'name email phone')
      .populate('adoptionRequests.user', 'name email');

    if (!pet) {
      return res.status(404).json({
        success: false,
        message: 'Pet not found'
      });
    }

    res.json({
      success: true,
      data: pet
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch pet',
      error: error.message
    });
  }
});

// Create new pet
router.post('/', auth, async (req, res) => {
  try {
    const pet = new Pet({
      ...req.body,
      owner: req.user._id
    });

    await pet.save();

    res.status(201).json({
      success: true,
      message: 'Pet created successfully',
      data: pet
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: 'Failed to create pet',
      error: error.message
    });
  }
});

// Update pet
router.patch('/:id', auth, upload.single('image'), async (req, res) => {
  try {
    const pet = await Pet.findOne({ _id: req.params.id, owner: req.user._id });
    
    if (!pet) {
      return res.status(404).json({
        success: false,
        message: 'Pet not found or unauthorized'
      });
    }

    const updates = Object.keys(req.body);
    const allowedUpdates = ['name', 'type', 'breed', 'age', 'description', 'location'];
    const isValidOperation = updates.every(update => allowedUpdates.includes(update));

    if (!isValidOperation) {
      return res.status(400).json({
        success: false,
        message: 'Invalid updates'
      });
    }

    if (req.file) {
      // Upload new image to Cloudinary
      const result = await cloudinary.uploader.upload(req.file.path, {
        folder: 'saathi/pets'
      });
      pet.imageUrl = result.secure_url;
    }

    updates.forEach(update => pet[update] = req.body[update]);
    await pet.save();

    res.json({
      success: true,
      message: 'Pet updated successfully',
      data: pet
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: 'Failed to update pet',
      error: error.message
    });
  }
});

// Delete pet
router.delete('/:id', auth, async (req, res) => {
  try {
    const pet = await Pet.findOneAndDelete({ _id: req.params.id, owner: req.user._id });
    
    if (!pet) {
      return res.status(404).json({
        success: false,
        message: 'Pet not found or unauthorized'
      });
    }

    res.json({
      success: true,
      message: 'Pet deleted successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to delete pet',
      error: error.message
    });
  }
});

// Submit adoption request
router.post('/:id/adopt', auth, async (req, res) => {
  try {
    const pet = await Pet.findById(req.params.id);
    
    if (!pet) {
      return res.status(404).json({
        success: false,
        message: 'Pet not found'
      });
    }

    if (pet.isAdopted) {
      return res.status(400).json({
        success: false,
        message: 'Pet is already adopted'
      });
    }

    // Check if user already has a pending request
    const existingRequest = pet.adoptionRequests.find(
      request => request.user.toString() === req.user._id.toString() && request.status === 'pending'
    );

    if (existingRequest) {
      return res.status(400).json({
        success: false,
        message: 'You already have a pending adoption request for this pet'
      });
    }

    const { name, email, phone, reason } = req.body;

    pet.adoptionRequests.push({
      user: req.user._id,
      name,
      email,
      phone,
      reason
    });

    await pet.save();

    res.status(201).json({
      success: true,
      message: 'Adoption request submitted successfully'
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: 'Failed to submit adoption request',
      error: error.message
    });
  }
});

// Update adoption request status
router.patch('/:id/adopt/:requestId', auth, async (req, res) => {
  try {
    const { status } = req.body;
    const pet = await Pet.findOne({ _id: req.params.id, owner: req.user._id });
    
    if (!pet) {
      return res.status(404).json({
        success: false,
        message: 'Pet not found or unauthorized'
      });
    }

    const request = pet.adoptionRequests.id(req.params.requestId);
    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Adoption request not found'
      });
    }

    request.status = status;
    if (status === 'approved') {
      pet.isAdopted = true;
      // Reject all other pending requests
      pet.adoptionRequests.forEach(req => {
        if (req.status === 'pending') {
          req.status = 'rejected';
        }
      });
    }

    await pet.save();

    res.json({
      success: true,
      message: 'Adoption request status updated successfully'
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: 'Failed to update adoption request status',
      error: error.message
    });
  }
});

module.exports = router; 