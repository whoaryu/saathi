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

// Database connection
mongoose.connect(config.mongoUri)
  .then(() => console.log('Connected to MongoDB'))
  .catch((err) => console.error('MongoDB connection error:', err));

// Routes
app.use('/api/pets', require('./routes/pet.routes'));
app.use('/api/auth', require('./routes/auth.routes'));

// Error handling middleware
app.use(errorHandler);

// Start server
app.listen(config.port, '0.0.0.0', () => {
  console.log(`Server is running on http://0.0.0.0:${config.port}`);
  console.log(`Local access: http://localhost:${config.port}`);
  console.log(`Network access: http://192.168.0.101:${config.port}`);
}); 