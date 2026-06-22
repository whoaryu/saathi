require('dotenv').config();

const config = {
  port: process.env.PORT || 5000,
  mongoUri: process.env.MONGO_URI || process.env.MONGODB_URI || 'mongodb://localhost:27017/saathi',
  jwtSecret: process.env.JWT_SECRET || 'your-secret-key-change-in-production',
  jwtRefreshSecret: process.env.JWT_REFRESH_SECRET || 'your-refresh-secret-key-change-in-production',
  cors: {
    origin: ['http://localhost:3000', 'http://localhost:8080', 'http://192.168.29.188:8080'],
    credentials: true
  }
};

module.exports = config; 