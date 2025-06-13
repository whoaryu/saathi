# Saathi Backend

Backend API for the Saathi Pet Adoption Platform.

## Features

- User authentication (register, login, profile management)
- Pet management (create, read, update, delete)
- Adoption request system
- Image upload using Cloudinary
- MongoDB database integration
- JWT-based authentication
- Error handling and validation

## Prerequisites

- Node.js (v14 or higher)
- MongoDB
- Cloudinary account

## Setup

1. Install dependencies:
```bash
npm install
```

2. Create a `.env` file in the root directory with the following variables:
```
PORT=5000
MONGODB_URI=mongodb://localhost:27017/saathi
JWT_SECRET=your_jwt_secret_key_here
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

3. Start the development server:
```bash
npm run dev
```

## API Endpoints

### Authentication

- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/profile` - Get current user profile
- `PATCH /api/auth/profile` - Update user profile

### Pets

- `GET /api/pets` - Get all pets (with filters)
- `GET /api/pets/:id` - Get single pet
- `POST /api/pets` - Create new pet
- `PATCH /api/pets/:id` - Update pet
- `DELETE /api/pets/:id` - Delete pet

### Adoption Requests

- `POST /api/pets/:id/adopt` - Submit adoption request
- `PATCH /api/pets/:id/adopt/:requestId` - Update adoption request status

## Request/Response Examples

### Register User
```json
POST /api/auth/register
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "phone": "1234567890"
}
```

### Create Pet
```json
POST /api/pets
{
  "name": "Buddy",
  "type": "Dog",
  "breed": "Golden Retriever",
  "age": 2,
  "description": "Friendly and playful",
  "location": "New York"
}
```

### Submit Adoption Request
```json
POST /api/pets/:id/adopt
{
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "1234567890",
  "reason": "I have a large backyard and experience with dogs"
}
```

## Error Handling

The API uses a consistent error response format:

```json
{
  "success": false,
  "message": "Error message",
  "error": "Detailed error (development only)"
}
```

## Security

- Passwords are hashed using bcrypt
- JWT tokens for authentication
- Input validation and sanitization
- CORS configuration
- Rate limiting (to be implemented)

## Development

- Use `npm run dev` for development with hot reload
- Use `npm start` for production
- Follow the error handling patterns in `utils/errorHandler.js`
- Add new routes in the `routes` directory
- Add new models in the `models` directory 