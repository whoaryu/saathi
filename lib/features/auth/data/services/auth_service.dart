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
    final token = data['data']['token'];
    await _prefs.setString('token', token);
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
    final token = data['data']['token'];
    await _prefs.setString('token', token);
    return data['data']['user'];
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _apiService.get('/auth/profile');
    final data = json.decode(response.body);
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
    return data['data']['user'];
  }

  Future<void> logout() async {
    await _prefs.remove('token');
  }

  bool get isLoggedIn => _prefs.getString('token') != null;
} 