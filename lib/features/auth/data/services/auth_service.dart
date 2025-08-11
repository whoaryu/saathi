import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saathi/core/services/api_service.dart';

class AuthService {
  final ApiService _apiService;
  final SharedPreferences _prefs;

  AuthService(this._apiService, this._prefs);

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await _apiService.post(
      '/auth/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      },
    );
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
    
    final accessToken = data['data']['accessToken'];
    final refreshToken = data['data']['refreshToken'];
    
    await _prefs.setString('accessToken', accessToken);
    await _prefs.setString('refreshToken', refreshToken);
    
    return data['data']['user'];
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
    );
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
    
    final accessToken = data['data']['accessToken'];
    final refreshToken = data['data']['refreshToken'];
    
    await _prefs.setString('accessToken', accessToken);
    await _prefs.setString('refreshToken', refreshToken);
    
    return data['data']['user'];
  }

  Future<Map<String, dynamic>> refreshAccessToken() async {
    final refreshToken = _prefs.getString('refreshToken');
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final response = await _apiService.post(
      '/auth/refresh',
      body: {
        'refreshToken': refreshToken,
      },
    );
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      // Clear tokens if refresh failed
      await _prefs.remove('accessToken');
      await _prefs.remove('refreshToken');
      throw Exception(data['message']);
    }
    
    final newAccessToken = data['data']['accessToken'];
    final newRefreshToken = data['data']['refreshToken'];
    
    await _prefs.setString('accessToken', newAccessToken);
    await _prefs.setString('refreshToken', newRefreshToken);
    
    return data['data'];
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _apiService.get('/auth/profile');
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
    
    return data['data']['user'];
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
  }) async {
    final updateData = <String, dynamic>{};
    if (name != null) updateData['name'] = name;
    if (email != null) updateData['email'] = email;
    if (phone != null) updateData['phone'] = phone;
    if (profileImage != null) updateData['profileImage'] = profileImage;

    final response = await _apiService.patch(
      '/auth/profile',
      body: updateData,
    );
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
    
    return data['data']['user'];
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _apiService.patch(
      '/auth/change-password',
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
  }

  Future<void> forgotPassword(String email) async {
    final response = await _apiService.post(
      '/auth/forgot-password',
      body: {
        'email': email,
      },
    );
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final response = await _apiService.post(
      '/auth/reset-password',
      body: {
        'token': token,
        'newPassword': newPassword,
      },
    );
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
  }

  Future<void> verifyEmail(String token) async {
    final response = await _apiService.post(
      '/auth/verify-email',
      body: {
        'token': token,
      },
    );
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
  }

  Future<void> resendVerification() async {
    final response = await _apiService.post('/auth/resend-verification');
    final data = json.decode(response.body);
    
    if (data['success'] == false) {
      throw Exception(data['message']);
    }
  }

  Future<void> logout() async {
    try {
      // Call logout endpoint to invalidate refresh token
      await _apiService.post('/auth/logout');
    } catch (e) {
      // Continue with local logout even if server call fails
      print('Logout server call failed: $e');
    } finally {
      // Clear local tokens
      await _prefs.remove('accessToken');
      await _prefs.remove('refreshToken');
    }
  }

  String? get accessToken => _prefs.getString('accessToken');
  String? get refreshToken => _prefs.getString('refreshToken');
  bool get isLoggedIn => accessToken != null;
} 