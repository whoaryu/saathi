# 🐾 Phase 3: Favorites System API Documentation

## Overview
The Favorites System allows users to save pets they're interested in for later viewing. Users can add pets to favorites, remove them, check their favorite status, and view their complete favorites list.

---

## 🔐 Authentication
All favorites endpoints require authentication. Include the JWT token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

---

## 📋 API Endpoints

### 1. Add Pet to Favorites
**POST** `/api/favorites`

Add a pet to the user's favorites list.

#### Request Body:
```json
{
  "petId": "507f1f77bcf86cd799439011"
}
```

#### Response (Success - 201):
```json
{
  "success": true,
  "message": "Pet added to favorites successfully",
  "data": {
    "favorite": {
      "id": "507f1f77bcf86cd799439012",
      "userId": "507f1f77bcf86cd799439013",
      "petId": "507f1f77bcf86cd799439011",
      "addedAt": "2024-01-15T10:30:00.000Z",
      "createdAt": "2024-01-15T10:30:00.000Z",
      "updatedAt": "2024-01-15T10:30:00.000Z"
    },
    "pet": {
      "_id": "507f1f77bcf86cd799439011",
      "name": "Max",
      "type": "Dog",
      "breed": "German Shepherd",
      "age": 3,
      "description": "A loyal and intelligent German Shepherd...",
      "location": "Los Angeles",
      "imageUrl": "https://images.unsplash.com/...",
      "isAdopted": false
    }
  }
}
```

#### Response (Error - 409):
```json
{
  "success": false,
  "message": "Pet is already in your favorites"
}
```

---

### 2. Remove Pet from Favorites
**DELETE** `/api/favorites/:petId`

Remove a pet from the user's favorites list.

#### URL Parameters:
- `petId` (string, required): The ID of the pet to remove from favorites

#### Response (Success - 200):
```json
{
  "success": true,
  "message": "Pet removed from favorites successfully",
  "data": {
    "removedFavorite": {
      "id": "507f1f77bcf86cd799439012",
      "userId": "507f1f77bcf86cd799439013",
      "petId": "507f1f77bcf86cd799439011",
      "addedAt": "2024-01-15T10:30:00.000Z",
      "createdAt": "2024-01-15T10:30:00.000Z",
      "updatedAt": "2024-01-15T10:30:00.000Z"
    }
  }
}
```

#### Response (Error - 404):
```json
{
  "success": false,
  "message": "Pet not found in your favorites"
}
```

---

### 3. Get User's Favorites
**GET** `/api/favorites`

Retrieve the user's favorites list with pagination and sorting options.

#### Query Parameters:
- `page` (number, optional): Page number (default: 1)
- `limit` (number, optional): Items per page (default: 20, max: 100)
- `sortBy` (string, optional): Sort field (default: 'addedAt')
- `sortOrder` (string, optional): Sort order - 'asc' or 'desc' (default: 'desc')

#### Example Request:
```
GET /api/favorites?page=1&limit=10&sortBy=addedAt&sortOrder=desc
```

#### Response (Success - 200):
```json
{
  "success": true,
  "message": "Favorites retrieved successfully",
  "data": {
    "favorites": [
      {
        "id": "507f1f77bcf86cd799439012",
        "addedAt": "2024-01-15T10:30:00.000Z",
        "pet": {
          "_id": "507f1f77bcf86cd799439011",
          "name": "Max",
          "type": "Dog",
          "breed": "German Shepherd",
          "age": 3,
          "description": "A loyal and intelligent German Shepherd...",
          "location": "Los Angeles",
          "imageUrl": "https://images.unsplash.com/...",
          "isAdopted": false
        }
      },
      {
        "id": "507f1f77bcf86cd799439013",
        "addedAt": "2024-01-14T15:20:00.000Z",
        "pet": {
          "_id": "507f1f77bcf86cd799439014",
          "name": "Luna",
          "type": "Cat",
          "breed": "Persian",
          "age": 1,
          "description": "A beautiful Persian cat...",
          "location": "Chicago",
          "imageUrl": "https://images.unsplash.com/...",
          "isAdopted": false
        }
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

### 4. Check if Pet is Favorited
**GET** `/api/favorites/check/:petId`

Check if a specific pet is in the user's favorites list.

#### URL Parameters:
- `petId` (string, required): The ID of the pet to check

#### Response (Success - 200):
```json
{
  "success": true,
  "data": {
    "isFavorited": true,
    "petId": "507f1f77bcf86cd799439011"
  }
}
```

---

### 5. Get User's Favorite Count
**GET** `/api/favorites/count`

Get the total number of pets in the user's favorites list.

#### Response (Success - 200):
```json
{
  "success": true,
  "data": {
    "count": 15
  }
}
```

---

### 6. Get Pet's Favorite Count
**GET** `/api/favorites/pet/:petId/count`

Get the total number of users who have favorited a specific pet.

#### URL Parameters:
- `petId` (string, required): The ID of the pet

#### Response (Success - 200):
```json
{
  "success": true,
  "data": {
    "petId": "507f1f77bcf86cd799439011",
    "count": 8
  }
}
```

---

### 7. Toggle Favorite Status
**POST** `/api/favorites/toggle/:petId`

Toggle the favorite status of a pet (add if not favorited, remove if already favorited).

#### URL Parameters:
- `petId` (string, required): The ID of the pet to toggle

#### Response (Success - 200) - When Adding:
```json
{
  "success": true,
  "message": "Pet added to favorites",
  "data": {
    "isFavorited": true,
    "action": "added",
    "favorite": {
      "id": "507f1f77bcf86cd799439012",
      "userId": "507f1f77bcf86cd799439013",
      "petId": "507f1f77bcf86cd799439011",
      "addedAt": "2024-01-15T10:30:00.000Z",
      "createdAt": "2024-01-15T10:30:00.000Z",
      "updatedAt": "2024-01-15T10:30:00.000Z"
    }
  }
}
```

#### Response (Success - 200) - When Removing:
```json
{
  "success": true,
  "message": "Pet removed from favorites",
  "data": {
    "isFavorited": false,
    "action": "removed"
  }
}
```

---

## 🔧 Error Responses

### Common Error Codes:

#### 400 - Bad Request
```json
{
  "success": false,
  "message": "Valid pet ID is required"
}
```

#### 401 - Unauthorized
```json
{
  "success": false,
  "message": "Access token is required"
}
```

#### 404 - Not Found
```json
{
  "success": false,
  "message": "Pet not found"
}
```

#### 500 - Internal Server Error
```json
{
  "success": false,
  "message": "Failed to add pet to favorites",
  "error": "Database connection error"
}
```

---

## 📊 Database Schema

### Favorite Model
```javascript
{
  user: ObjectId (ref: 'User', required, indexed),
  pet: ObjectId (ref: 'Pet', required, indexed),
  addedAt: Date (default: Date.now, indexed),
  createdAt: Date (auto-generated),
  updatedAt: Date (auto-generated)
}
```

### Indexes
- `{ user: 1, pet: 1 }` - Unique compound index
- `{ user: 1 }` - For user queries
- `{ pet: 1 }` - For pet queries
- `{ addedAt: 1 }` - For sorting

---

## 🚀 Usage Examples

### Frontend Integration Examples:

#### 1. Add to Favorites
```javascript
const addToFavorites = async (petId) => {
  try {
    const response = await fetch('/api/favorites', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify({ petId })
    });
    
    const data = await response.json();
    if (data.success) {
      console.log('Pet added to favorites!');
    }
  } catch (error) {
    console.error('Error adding to favorites:', error);
  }
};
```

#### 2. Check Favorite Status
```javascript
const checkFavoriteStatus = async (petId) => {
  try {
    const response = await fetch(`/api/favorites/check/${petId}`, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    
    const data = await response.json();
    return data.data.isFavorited;
  } catch (error) {
    console.error('Error checking favorite status:', error);
    return false;
  }
};
```

#### 3. Toggle Favorite
```javascript
const toggleFavorite = async (petId) => {
  try {
    const response = await fetch(`/api/favorites/toggle/${petId}`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    
    const data = await response.json();
    if (data.success) {
      console.log(`Pet ${data.data.action} from favorites`);
    }
  } catch (error) {
    console.error('Error toggling favorite:', error);
  }
};
```

---

## 🔒 Security Features

1. **Authentication Required**: All endpoints require valid JWT token
2. **Input Validation**: All pet IDs are validated for proper ObjectId format
3. **Duplicate Prevention**: Users cannot favorite the same pet twice
4. **Pagination Limits**: Maximum 100 items per page to prevent abuse
5. **Error Handling**: Comprehensive error messages without exposing internals

---

## 📈 Performance Optimizations

1. **Database Indexes**: Optimized queries with proper indexing
2. **Pagination**: Efficient data retrieval with skip/limit
3. **Population**: Pet details are populated in a single query
4. **Caching Ready**: Structure supports future caching implementation

---

## 🧪 Testing Endpoints

### Test with cURL:

#### Add to Favorites:
```bash
curl -X POST http://localhost:3000/api/favorites \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"petId": "507f1f77bcf86cd799439011"}'
```

#### Get Favorites:
```bash
curl -X GET "http://localhost:3000/api/favorites?page=1&limit=10" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

#### Check Favorite Status:
```bash
curl -X GET http://localhost:3000/api/favorites/check/507f1f77bcf86cd799439011 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## ✅ Implementation Status

- ✅ **Favorite Model** - Complete with indexes and methods
- ✅ **Favorites Routes** - All endpoints implemented
- ✅ **Validation** - Input validation and error handling
- ✅ **Documentation** - Comprehensive API documentation
- ✅ **Integration** - Routes registered in main app

**Ready for frontend implementation!** 🚀 