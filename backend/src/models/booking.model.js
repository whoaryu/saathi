const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'User reference is required']
  },
  serviceName: {
    type: String,
    required: [true, 'Service name is required'],
    trim: true
  },
  animalType: {
    type: String,
    required: [true, 'Animal type is required'],
    trim: true
  },
  date: {
    type: String, // YYYY-MM-DD
    required: [true, 'Booking date is required']
  },
  timeSlot: {
    type: String, // e.g., '10:00 AM'
    required: [true, 'Booking time slot is required']
  },
  price: {
    type: Number,
    required: [true, 'Booking price is required']
  }
}, {
  timestamps: true
});

// Ensure a single slot cannot be double-booked at the DB level
bookingSchema.index({ date: 1, timeSlot: 1 }, { unique: true });

const Booking = mongoose.model('Booking', bookingSchema);

module.exports = Booking;
