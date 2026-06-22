const express = require('express');
const router = express.Router();
const Booking = require('../models/booking.model');
const { authenticateToken } = require('../middleware/auth.middleware');

// GET /api/bookings - Fetch user's bookings
router.get('/', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const bookings = await Booking.find({ user: userId }).sort({ createdAt: -1 });

    res.json({
      success: true,
      data: bookings
    });
  } catch (error) {
    console.error('Error fetching bookings:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve bookings',
      error: error.message
    });
  }
});

// POST /api/bookings - Create new booking
router.post('/', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const { serviceName, animalType, date, timeSlot, price } = req.body;

    // Basic Validation
    if (!serviceName || !animalType || !date || !timeSlot || !price) {
      return res.status(400).json({
        success: false,
        message: 'Missing required booking fields (serviceName, animalType, date, timeSlot, price)'
      });
    }

    // Try to create the booking
    const booking = new Booking({
      user: userId,
      serviceName,
      animalType,
      date,
      timeSlot,
      price
    });

    await booking.save();

    res.status(201).json({
      success: true,
      message: 'Booking confirmed successfully!',
      data: booking
    });
  } catch (error) {
    // Catch unique index constraint violation (MongoDB error code 11000)
    if (error.code === 11000) {
      return res.status(409).json({
        success: false,
        message: 'This time slot is already booked. Please choose another date or time.'
      });
    }

    console.error('Error creating booking:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to reserve booking',
      error: error.message
    });
  }
});

// DELETE /api/bookings/:id - Cancel booking
router.delete('/:id', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const bookingId = req.params.id;

    const booking = await Booking.findOneAndDelete({ _id: bookingId, user: userId });

    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Booking not found or unauthorized'
      });
    }

    res.json({
      success: true,
      message: 'Booking cancelled successfully'
    });
  } catch (error) {
    console.error('Error deleting booking:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to cancel booking',
      error: error.message
    });
  }
});

module.exports = router;
