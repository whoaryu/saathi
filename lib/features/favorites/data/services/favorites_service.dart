import 'dart:convert';
import 'package:saathi/core/services/api_service.dart';
import 'package:saathi/features/favorites/domain/models/favorite.dart';

class FavoritesService {
  final ApiService _apiService;

  FavoritesService(this._apiService);

  /// Add a pet to favorites
  Future<Map<String, dynamic>> addToFavorites(String petId) async {
    try {
      final response = await _apiService.post(
        '/favorites',
        body: {'petId': petId},
      );

      final data = json.decode(response.body);
      if (data['success']) {
        return {
          'success': true,
          'favorite': Favorite.fromJson(data['data']['favorite']),
          'pet': data['data']['pet'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to add to favorites',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Remove a pet from favorites
  Future<Map<String, dynamic>> removeFromFavorites(String petId) async {
    try {
      final response = await _apiService.delete('/favorites/$petId');
      final data = json.decode(response.body);

      if (data['success']) {
        return {
          'success': true,
          'removedFavorite': Favorite.fromJson(data['data']['removedFavorite']),
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to remove from favorites',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Get user's favorites with pagination
  Future<Map<String, dynamic>> getFavorites({
    int page = 1,
    int limit = 20,
    String sortBy = 'addedAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      };

      final response = await _apiService.get('/favorites', queryParams: queryParams);
      final data = json.decode(response.body);

      if (data['success']) {
        final favorites = (data['data']['favorites'] as List)
            .map((fav) => Favorite.fromJson(fav))
            .toList();

        return {
          'success': true,
          'favorites': favorites,
          'pagination': data['data']['pagination'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get favorites',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Check if a pet is favorited
  Future<bool> isFavorited(String petId) async {
    try {
      final response = await _apiService.get('/favorites/check/$petId');
      final data = json.decode(response.body);

      if (data['success']) {
        return data['data']['isFavorited'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Get user's favorite count
  Future<int> getFavoriteCount() async {
    try {
      final response = await _apiService.get('/favorites/count');
      final data = json.decode(response.body);

      if (data['success']) {
        return data['data']['count'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  /// Get pet's favorite count
  Future<int> getPetFavoriteCount(String petId) async {
    try {
      final response = await _apiService.get('/favorites/pet/$petId/count');
      final data = json.decode(response.body);

      if (data['success']) {
        return data['data']['count'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  /// Toggle favorite status
  Future<Map<String, dynamic>> toggleFavorite(String petId) async {
    try {
      final response = await _apiService.post('/favorites/toggle/$petId');
      final data = json.decode(response.body);

      if (data['success']) {
        return {
          'success': true,
          'isFavorited': data['data']['isFavorited'],
          'action': data['data']['action'],
          'favorite': data['data']['favorite'] != null 
              ? Favorite.fromJson(data['data']['favorite'])
              : null,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to toggle favorite',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Batch check favorite status for multiple pets
  Future<Map<String, bool>> batchCheckFavorites(List<String> petIds) async {
    final Map<String, bool> results = {};
    
    for (final petId in petIds) {
      results[petId] = await isFavorited(petId);
    }
    
    return results;
  }
} 