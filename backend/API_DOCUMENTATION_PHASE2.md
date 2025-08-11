# Phase 2: User Profile System - API Documentation

## Base URL
```
http://localhost:5000/api/user
```

## Authentication
All endpoints require authentication. Include the JWT token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

---

## 1. Get User Profile
**GET** `/profile`

Get the current user's profile information.

### Response
```json
{
  "success": true,
  "data": {
    "user": {
      "_id": "user_id",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "+1234567890",
      "profileImage": "avatar-1234567890.jpg",
      "bio": "Pet lover and animal enthusiast",
      "location": "New York, NY",
      "preferences": {
        "petTypes": ["Dog", "Cat"],
        "maxAge": 5,
        "notifications": {
          "email": true,
          "push": true,
          "adoptionUpdates": true,
          "newPets": true
        }
      },
      "role": "user",
      "isEmailVerified": true,
      "createdAt": "2024-01-01T00:00:00.000Z",
      "updatedAt": "2024-01-01T00:00:00.000Z"
    }
  }
}
```

---

## 2. Update User Profile
**PUT** `/profile`

Update the current user's profile information.

### Request Body
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "bio": "Pet lover and animal enthusiast",
  "location": "New York, NY",
  "preferences": {
    "petTypes": ["Dog", "Cat"],
    "maxAge": 5,
    "notifications": {
      "email": true,
      "push": true,
      "adoptionUpdates": true,
      "newPets": true
    }
  }
}
```

### Response
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "user": {
      // Updated user object
    }
  }
}
```

### Validation Rules
- `name`: 2-50 characters
- `email`: Valid email format, must be unique
- `phone`: Valid phone number format
- `bio`: Maximum 500 characters
- `location`: Maximum 100 characters

---

## 3. Upload Profile Picture
**POST** `/avatar`

Upload a profile picture for the current user.

### Request
- **Content-Type**: `multipart/form-data`
- **Body**: `avatar` file (image: jpg, jpeg, png, gif, max 5MB)

### Response
```json
{
  "success": true,
  "message": "Avatar uploaded successfully",
  "data": {
    "profileImage": "avatar-1234567890.jpg"
  }
}
```

### Notes
- Old avatar is automatically deleted
- File size limit: 5MB
- Supported formats: jpg, jpeg, png, gif
- Image URL: `http://localhost:5000/uploads/avatars/avatar-1234567890.jpg`

---

## 4. Delete Account
**DELETE** `/account`

Delete the current user's account.

### Request Body
```json
{
  "password": "current_password"
}
```

### Response
```json
{
  "success": true,
  "message": "Account deleted successfully"
}
```

### Notes
- Requires current password verification
- Deletes user's avatar file
- Removes all user data from database

---

## 5. Get User's Pets
**GET** `/pets`

Get pets owned by the current user.

### Query Parameters
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 10)
- `status` (optional): Filter by pet status

### Response
```json
{
  "success": true,
  "data": {
    "pets": [
      {
        "_id": "pet_id",
        "name": "Buddy",
        "type": "Dog",
        "breed": "Golden Retriever",
        "age": 3,
        "description": "Friendly and energetic",
        "location": "New York, NY",
        "image": "pet_image.jpg",
        "isAdopted": false,
        "owner": {
          "_id": "user_id",
          "name": "John Doe",
          "email": "john@example.com"
        },
        "createdAt": "2024-01-01T00:00:00.000Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 25,
      "pages": 3
    }
  }
}
```

---

## 6. Get Adoption History
**GET** `/adoptions`

Get adoption requests made by the current user.

### Query Parameters
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 10)
- `status` (optional): Filter by request status (pending, approved, rejected)

### Response
```json
{
  "success": true,
  "data": {
    "adoptions": [
      {
        "pet": {
          "_id": "pet_id",
          "name": "Buddy",
          "type": "Dog",
          "breed": "Golden Retriever",
          "age": 3,
          "image": "pet_image.jpg",
          "owner": {
            "_id": "owner_id",
            "name": "Jane Smith",
            "email": "jane@example.com"
          }
        },
        "request": {
          "_id": "request_id",
          "name": "John Doe",
          "email": "john@example.com",
          "phone": "+1234567890",
          "reason": "Looking for a companion",
          "status": "pending",
          "createdAt": "2024-01-01T00:00:00.000Z"
        }
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 15,
      "pages": 2
    }
  }
}
```

---

## 7. Get User Statistics
**GET** `/stats`

Get statistics for the current user.

### Response
```json
{
  "success": true,
  "data": {
    "totalPets": 5,
    "totalAdoptions": 12,
    "pendingAdoptions": 3,
    "approvedAdoptions": 8
  }
}
```

---

## Error Responses

### 400 Bad Request
```json
{
  "success": false,
  "message": "Validation error message"
}
```

### 401 Unauthorized
```json
{
  "success": false,
  "message": "Authentication required"
}
```

### 500 Internal Server Error
```json
{
  "success": false,
  "message": "Error message",
  "error": "Detailed error information"
}
```

---

## File Upload Notes

### Avatar Upload
- **Endpoint**: `POST /api/user/avatar`
- **Content-Type**: `multipart/form-data`
- **Field Name**: `avatar`
- **File Size**: Maximum 5MB
- **Supported Formats**: jpg, jpeg, png, gif
- **Storage**: `uploads/avatars/` directory
- **URL Access**: `http://localhost:5000/uploads/avatars/filename.jpg`

### File Naming
- Format: `avatar-{timestamp}-{random}.{extension}`
- Example: `avatar-1640995200000-123456789.jpg`

---

## User Preferences Schema

```json
{
  "preferences": {
    "petTypes": ["Dog", "Cat", "Bird", "Other"],
    "maxAge": 5,
    "notifications": {
      "email": true,
      "push": true,
      "adoptionUpdates": true,
      "newPets": true
    }
  }
}
```

---

## Testing Examples

### cURL Commands

1. **Get Profile**
```bash
curl -X GET http://localhost:5000/api/user/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

2. **Update Profile**
```bash
curl -X PUT http://localhost:5000/api/user/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "bio": "Pet lover",
    "location": "New York"
  }'
```

3. **Upload Avatar**
```bash
curl -X POST http://localhost:5000/api/user/avatar \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "avatar=@/path/to/image.jpg"
```

4. **Get User's Pets**
```bash
curl -X GET "http://localhost:5000/api/user/pets?page=1&limit=10" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

5. **Get Adoption History**
```bash
curl -X GET "http://localhost:5000/api/user/adoptions?status=pending" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
``` 