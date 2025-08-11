const mongoose = require('mongoose');

const petSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Pet name is required'],
    trim: true
  },
  type: {
    type: String,
    required: [true, 'Pet type is required'],
    enum: ['Dog', 'Cat', 'Bird', 'Other']
  },
  breed: {
    type: String,
    required: [true, 'Pet breed is required'],
    trim: true
  },
  age: {
    type: Number,
    required: [true, 'Pet age is required'],
    min: [0, 'Age cannot be negative']
  },
  description: {
    type: String,
    required: [true, 'Pet description is required'],
    trim: true
  },
  location: {
    type: String,
    required: [true, 'Pet location is required'],
    trim: true
  },
  image: {
    type: String,
    required: false
  },
  isAdopted: {
    type: Boolean,
    default: false
  },
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  adoptionRequests: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    name: String,
    email: String,
    phone: String,
    reason: String,
    status: {
      type: String,
      enum: ['pending', 'approved', 'rejected'],
      default: 'pending'
    },
    createdAt: {
      type: Date,
      default: Date.now
    }
  }]
}, {
  timestamps: true
});

// Index for better search performance
petSchema.index({ name: 'text', breed: 'text', description: 'text' });

const Pet = mongoose.model('Pet', petSchema);

module.exports = Pet; 