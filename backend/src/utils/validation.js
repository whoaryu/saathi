const mongoose = require('mongoose');

/**
 * Validate if a string is a valid MongoDB ObjectId
 * @param {string} id - The ID to validate
 * @returns {boolean} - True if valid ObjectId, false otherwise
 */
const validateObjectId = (id) => {
  if (!id || typeof id !== 'string') {
    return false;
  }
  return mongoose.Types.ObjectId.isValid(id);
};

/**
 * Validate email format
 * @param {string} email - The email to validate
 * @returns {boolean} - True if valid email, false otherwise
 */
const validateEmail = (email) => {
  if (!email || typeof email !== 'string') {
    return false;
  }
  
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

/**
 * Validate password strength
 * @param {string} password - The password to validate
 * @returns {object} - Object with isValid boolean and message
 */
const validatePassword = (password) => {
  if (!password || typeof password !== 'string') {
    return {
      isValid: false,
      message: 'Password is required'
    };
  }

  if (password.length < 8) {
    return {
      isValid: false,
      message: 'Password must be at least 8 characters long'
    };
  }

  if (!/[A-Z]/.test(password)) {
    return {
      isValid: false,
      message: 'Password must contain at least one uppercase letter'
    };
  }

  if (!/[a-z]/.test(password)) {
    return {
      isValid: false,
      message: 'Password must contain at least one lowercase letter'
    };
  }

  if (!/\d/.test(password)) {
    return {
      isValid: false,
      message: 'Password must contain at least one number'
    };
  }

  return {
    isValid: true,
    message: 'Password is valid'
  };
};

/**
 * Validate pagination parameters
 * @param {number} page - Page number
 * @param {number} limit - Items per page
 * @returns {object} - Object with isValid boolean and message
 */
const validatePagination = (page, limit) => {
  const pageNum = parseInt(page);
  const limitNum = parseInt(limit);

  if (isNaN(pageNum) || pageNum < 1) {
    return {
      isValid: false,
      message: 'Page number must be a positive integer'
    };
  }

  if (isNaN(limitNum) || limitNum < 1 || limitNum > 100) {
    return {
      isValid: false,
      message: 'Limit must be between 1 and 100'
    };
  }

  return {
    isValid: true,
    message: 'Pagination parameters are valid'
  };
};

/**
 * Sanitize string input
 * @param {string} input - The input to sanitize
 * @returns {string} - Sanitized string
 */
const sanitizeString = (input) => {
  if (!input || typeof input !== 'string') {
    return '';
  }
  
  return input.trim().replace(/[<>]/g, '');
};

module.exports = {
  validateObjectId,
  validateEmail,
  validatePassword,
  validatePagination,
  sanitizeString
}; 