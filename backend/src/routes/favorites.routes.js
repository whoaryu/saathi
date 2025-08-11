const express = require('express');
const router = express.Router();
const Favorite = require('../models/favorite.model');
const Pet = require('../models/pet.model');
const { authenticateToken } = require('../middleware/auth.middleware');
const { validateObjectId } = require('../utils/validation');

// Middleware to validate pet ID
const validatePetId = (req, res, next) => {
  const { petId } = req.params;
  if (!validateObjectId(petId)) {
    return res.status(400).json({
      success: false,
      message: 'Invalid pet ID format'
    });
  }
  next();
};

// POST /api/favorites - Add pet to favorites
router.post('/', authenticateToken, async (req, res) => {
  try {
    const { petId } = req.body;
    const userId = req.user.id;

    // Validate petId
    if (!petId || !validateObjectId(petId)) {
      return res.status(400).json({
        success: false,
        message: 'Valid pet ID is required'
      });
    }

    // Check if pet exists
    const pet = await Pet.findById(petId);
    if (!pet) {
      return res.status(404).json({
        success: false,
        message: 'Pet not found'
      });
    }

    // Check if already favorited
    const existingFavorite = await Favorite.findOne({ user: userId, pet: petId });
    if (existingFavorite) {
      return res.status(409).json({
        success: false,
        message: 'Pet is already in your favorites'
      });
    }

    // Create new favorite
    const favorite = new Favorite({
      user: userId,
      pet: petId
    });

    await favorite.save();

    // Populate pet details
    await favorite.populate({
      path: 'pet',
      select: 'name type breed age description location imageUrl isAdopted'
    });

    res.status(201).json({
      success: true,
      message: 'Pet added to favorites successfully',
      data: {
        favorite: favorite.getFavoriteDetails(),
        pet: favorite.pet
      }
    });

  } catch (error) {
    console.error('Error adding to favorites:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to add pet to favorites',
      error: error.message
    });
  }
});

// DELETE /api/favorites/:petId - Remove pet from favorites
router.delete('/:petId', authenticateToken, validatePetId, async (req, res) => {
  try {
    const { petId } = req.params;
    const userId = req.user.id;

    // Find and delete the favorite
    const favorite = await Favorite.findOneAndDelete({ user: userId, pet: petId });

    if (!favorite) {
      return res.status(404).json({
        success: false,
        message: 'Pet not found in your favorites'
      });
    }

    res.json({
      success: true,
      message: 'Pet removed from favorites successfully',
      data: {
        removedFavorite: favorite.getFavoriteDetails()
      }
    });

  } catch (error) {
    console.error('Error removing from favorites:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to remove pet from favorites',
      error: error.message
    });
  }
});

// GET /api/favorites - Get user's favorites
router.get('/', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const { page = 1, limit = 20, sortBy = 'addedAt', sortOrder = 'desc' } = req.query;

    // Validate pagination parameters
    const pageNum = parseInt(page);
    const limitNum = parseInt(limit);
    
    if (pageNum < 1 || limitNum < 1 || limitNum > 100) {
      return res.status(400).json({
        success: false,
        message: 'Invalid pagination parameters'
      });
    }

    const options = {
      page: pageNum,
      limit: limitNum,
      sortBy,
      sortOrder
    };

    const result = await Favorite.getUserFavorites(userId, options);

    res.json({
      success: true,
      message: 'Favorites retrieved successfully',
      data: {
        favorites: result.favorites.map(fav => ({
          id: fav._id,
          addedAt: fav.addedAt,
          pet: fav.pet
        })),
        pagination: result.pagination
      }
    });

  } catch (error) {
    console.error('Error getting favorites:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve favorites',
      error: error.message
    });
  }
});

// GET /api/favorites/check/:petId - Check if pet is favorited
router.get('/check/:petId', authenticateToken, validatePetId, async (req, res) => {
  try {
    const { petId } = req.params;
    const userId = req.user.id;

    const isFavorited = await Favorite.isFavorited(userId, petId);

    res.json({
      success: true,
      data: {
        isFavorited,
        petId
      }
    });

  } catch (error) {
    console.error('Error checking favorite status:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to check favorite status',
      error: error.message
    });
  }
});

// GET /api/favorites/count - Get user's favorite count
router.get('/count', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const count = await Favorite.getUserFavoriteCount(userId);

    res.json({
      success: true,
      data: {
        count
      }
    });

  } catch (error) {
    console.error('Error getting favorite count:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to get favorite count',
      error: error.message
    });
  }
});

// GET /api/favorites/pet/:petId/count - Get pet's favorite count
router.get('/pet/:petId/count', validatePetId, async (req, res) => {
  try {
    const { petId } = req.params;

    // Check if pet exists
    const pet = await Pet.findById(petId);
    if (!pet) {
      return res.status(404).json({
        success: false,
        message: 'Pet not found'
      });
    }

    const count = await Favorite.getPetFavoriteCount(petId);

    res.json({
      success: true,
      data: {
        petId,
        count
      }
    });

  } catch (error) {
    console.error('Error getting pet favorite count:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to get pet favorite count',
      error: error.message
    });
  }
});

// POST /api/favorites/toggle/:petId - Toggle favorite status
router.post('/toggle/:petId', authenticateToken, validatePetId, async (req, res) => {
  try {
    const { petId } = req.params;
    const userId = req.user.id;

    // Check if pet exists
    const pet = await Pet.findById(petId);
    if (!pet) {
      return res.status(404).json({
        success: false,
        message: 'Pet not found'
      });
    }

    // Check if already favorited
    const existingFavorite = await Favorite.findOne({ user: userId, pet: petId });

    if (existingFavorite) {
      // Remove from favorites
      await Favorite.findOneAndDelete({ user: userId, pet: petId });
      
      res.json({
        success: true,
        message: 'Pet removed from favorites',
        data: {
          isFavorited: false,
          action: 'removed'
        }
      });
    } else {
      // Add to favorites
      const favorite = new Favorite({
        user: userId,
        pet: petId
      });

      await favorite.save();

      res.json({
        success: true,
        message: 'Pet added to favorites',
        data: {
          isFavorited: true,
          action: 'added',
          favorite: favorite.getFavoriteDetails()
        }
      });
    }

  } catch (error) {
    console.error('Error toggling favorite:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to toggle favorite status',
      error: error.message
    });
  }
});

module.exports = router; 