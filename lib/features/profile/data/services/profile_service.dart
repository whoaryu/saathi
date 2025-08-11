import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:saathi/core/services/api_service.dart';
import 'package:saathi/features/profile/domain/models/user_profile.dart';

class ProfileService {
  final ApiService _apiService;

  ProfileService(this._apiService);

  Future<UserProfile> getProfile() async {
    final response = await _apiService.get('/user/profile');
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
    
    return UserProfile.fromJson(data['data']['user']);
  }

  Future<UserProfile> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? location,
    UserPreferences? preferences,
  }) async {
    final updateData = <String, dynamic>{};
    if (name != null) updateData['name'] = name;
    if (email != null) updateData['email'] = email;
    if (phone != null) updateData['phone'] = phone;
    if (bio != null) updateData['bio'] = bio;
    if (location != null) updateData['location'] = location;
    if (preferences != null) updateData['preferences'] = preferences.toJson();

    final response = await _apiService.patch(
      '/user/profile',
      body: updateData,
    );
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
    
    return UserProfile.fromJson(data['data']['user']);
  }

  Future<String> uploadAvatar(File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiService.baseUrl}/user/avatar'),
    );

    // Add authorization header
    final token = await _getAuthToken();
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    // Add file
    request.files.add(
      await http.MultipartFile.fromPath(
        'avatar',
        imageFile.path,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to upload avatar');
    }

    final data = json.decode(response.body);
    if (data['success'] == false) {
      throw Exception(data['message']);
    }

    return data['data']['profileImage'];
  }

  Future<void> deleteAccount(String password) async {
    // For DELETE requests, we need to send the password in the request body
    // Since our ApiService doesn't support body for DELETE, we'll use http directly
    final request = http.Request(
      'DELETE',
      Uri.parse('${ApiService.baseUrl}/user/account'),
    );
    
    request.headers['Authorization'] = 'Bearer ${await _getAuthToken()}';
    request.headers['Content-Type'] = 'application/json';
    request.body = json.encode({'password': password});
    
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    final data = json.decode(responseData);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
  }

  Future<Map<String, dynamic>> getUserPets({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (status != null) queryParams['status'] = status;

    final response = await _apiService.get('/user/pets', queryParams: queryParams);
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
    
    return data['data'];
  }

  Future<Map<String, dynamic>> getAdoptionHistory({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (status != null) queryParams['status'] = status;

    final response = await _apiService.get('/user/adoptions', queryParams: queryParams);
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
    
    return data['data'];
  }

  Future<Map<String, int>> getUserStats() async {
    final response = await _apiService.get('/user/stats');
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
    
    return Map<String, int>.from(data['data']);
  }

  Future<String?> _getAuthToken() async {
    // This would typically come from your auth service
    // For now, we'll use the ApiService's token
    return null; // ApiService handles this internally
  }
} 