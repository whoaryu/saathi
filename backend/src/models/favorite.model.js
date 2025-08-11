const mongoose = require('mongoose');

const favoriteSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  pet: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Pet',
    required: true,
    index: true
  },
  addedAt: {
    type: Date,
    default: Date.now,
    index: true
  }
}, {
  timestamps: true
});

// Compound index to ensure a user can only favorite a pet once
favoriteSchema.index({ user: 1, pet: 1 }, { unique: true });

// Instance method to get favorite details
favoriteSchema.methods.getFavoriteDetails = function() {
  return {
    id: this._id,
    userId: this.user,
    petId: this.pet,
    addedAt: this.addedAt,
    createdAt: this.createdAt,
    updatedAt: this.updatedAt
  };
};

// Static method to check if a pet is favorited by a user
favoriteSchema.statics.isFavorited = async function(userId, petId) {
  const favorite = await this.findOne({ user: userId, pet: petId });
  return !!favorite;
};

// Static method to get user's favorites with pet details
favoriteSchema.statics.getUserFavorites = async function(userId, options = {}) {
  const {
    page = 1,
    limit = 20,
    sortBy = 'addedAt',
    sortOrder = 'desc'
  } = options;

  const skip = (page - 1) * limit;
  const sort = { [sortBy]: sortOrder === 'desc' ? -1 : 1 };

  const favorites = await this.find({ user: userId })
    .populate({
      path: 'pet',
      select: 'name type breed age description location imageUrl isAdopted'
    })
    .sort(sort)
    .skip(skip)
    .limit(limit);

  const total = await this.countDocuments({ user: userId });

  return {
    favorites,
    pagination: {
      page,
      limit,
      total,
      pages: Math.ceil(total / limit)
    }
  };
};

// Static method to get favorite count for a pet
favoriteSchema.statics.getPetFavoriteCount = async function(petId) {
  return await this.countDocuments({ pet: petId });
};

// Static method to get user's favorite count
favoriteSchema.statics.getUserFavoriteCount = async function(userId) {
  return await this.countDocuments({ user: userId });
};

const Favorite = mongoose.model('Favorite', favoriteSchema);

module.exports = Favorite; 