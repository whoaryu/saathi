const mongoose = require('mongoose');

const trainingProgressSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'User reference is required']
  },
  petType: {
    type: String,
    enum: ['Dog', 'Cat', 'Bird'],
    required: [true, 'Pet type is required']
  },
  completedModules: [{
    type: String
  }],
  unlockedModules: [{
    type: String
  }],
  streak: {
    type: Number,
    default: 0
  },
  lastActiveDate: {
    type: Date,
    default: null
  },
  badges: [{
    id: { type: String, required: true },
    title: { type: String, required: true },
    description: { type: String, required: true },
    unlockedAt: { type: Date, default: Date.now }
  }]
}, {
  timestamps: true
});

// Ensure only one training progress document exists per user and petType
trainingProgressSchema.index({ userId: 1, petType: 1 }, { unique: true });

const TrainingProgress = mongoose.model('TrainingProgress', trainingProgressSchema);

module.exports = TrainingProgress;
