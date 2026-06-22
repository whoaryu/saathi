const dns = require('dns');
// Set DNS servers to Google DNS to prevent c-ares querySrv failures on some network configurations
try {
  dns.setServers(['8.8.8.8', '8.8.4.4']);
  console.log('📡 System DNS resolver set to Google DNS (8.8.8.8, 8.8.4.4)');
} catch (e) {
  console.warn('⚠️ Failed to set custom DNS servers:', e);
}

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const config = require('./config/config');
const { errorHandler } = require('./utils/errorHandler');

// Create Express app
const app = express();

// Middleware
app.use(cors(config.cors));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files
app.use('/uploads', express.static('uploads'));

// Database connection
mongoose.connect(config.mongoUri)
  .then(() => console.log('Connected to MongoDB'))
  .catch((err) => console.error('MongoDB connection error:', err));

// Routes
app.use('/api/pets', require('./routes/pet.routes'));
app.use('/api/auth', require('./routes/auth.routes'));
app.use('/api/user', require('./routes/user.routes'));
app.use('/api/favorites', require('./routes/favorites.routes'));
app.use('/api/bookings', require('./routes/booking.routes'));
app.use('/api/training', require('./routes/training.routes'));

// Error handling middleware
app.use(errorHandler);

// Start server
app.listen(config.port, '0.0.0.0', () => {
  console.log(`Server is running on http://0.0.0.0:${config.port}`);
  console.log(`Local access: http://localhost:${config.port}`);
  console.log(`Network access: http://192.168.29.188:${config.port}`);
  console.log(`Mobile access: http://192.168.29.188:${config.port}/api/pets`);
}); 