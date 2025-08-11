import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Update this IP address to match your computer's IP on the same network as your mobile
  // You can find this by running 'ipconfig' on Windows or 'ifconfig' on Mac/Linux
  static const String baseUrl = 'http://192.168.29.188:5000/api'; // Your computer's IP address
  final SharedPreferences _prefs;
  bool _isRefreshing = false;

  ApiService(this._prefs);

  Map<String, String> get headers {
    final accessToken = _prefs.getString('accessToken');
    return {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool retryOnAuthFailure = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: queryParams,
    );
    
    print('🌐 Making GET request to: $uri');
    print('📋 Headers: $headers');
    
    try {
      final response = await http.get(uri, headers: headers);
      print('✅ Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');
      
      // Handle token expiration
      if (response.statusCode == 401 && retryOnAuthFailure) {
        final refreshed = await _handleTokenRefresh();
        if (refreshed) {
          return await get(endpoint, queryParams: queryParams, retryOnAuthFailure: false);
        }
      }
      
      _handleError(response);
      return response;
    } catch (e) {
      print('❌ Error in GET request: $e');
      rethrow;
    }
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool retryOnAuthFailure = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    print('🌐 Making POST request to: $uri');
    print('📋 Headers: $headers');
    print('📦 Body: $body');
    
    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );
      
      print('✅ Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');
      
      // Handle token expiration
      if (response.statusCode == 401 && retryOnAuthFailure) {
        final refreshed = await _handleTokenRefresh();
        if (refreshed) {
          return await post(endpoint, body: body, retryOnAuthFailure: false);
        }
      }
      
      _handleError(response);
      return response;
    } catch (e) {
      print('❌ Error in POST request: $e');
      rethrow;
    }
  }

  Future<http.Response> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool retryOnAuthFailure = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    try {
      final response = await http.patch(
        uri,
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );
      
      // Handle token expiration
      if (response.statusCode == 401 && retryOnAuthFailure) {
        final refreshed = await _handleTokenRefresh();
        if (refreshed) {
          return await patch(endpoint, body: body, retryOnAuthFailure: false);
        }
      }
      
      _handleError(response);
      return response;
    } catch (e) {
      print('❌ Error in PATCH request: $e');
      rethrow;
    }
  }

  Future<http.Response> delete(
    String endpoint, {
    bool retryOnAuthFailure = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    try {
      final response = await http.delete(uri, headers: headers);
      
      // Handle token expiration
      if (response.statusCode == 401 && retryOnAuthFailure) {
        final refreshed = await _handleTokenRefresh();
        if (refreshed) {
          return await delete(endpoint, retryOnAuthFailure: false);
        }
      }
      
      _handleError(response);
      return response;
    } catch (e) {
      print('❌ Error in DELETE request: $e');
      rethrow;
    }
  }

  Future<bool> _handleTokenRefresh() async {
    if (_isRefreshing) {
      // Wait for the ongoing refresh to complete
      while (_isRefreshing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _prefs.getString('accessToken') != null;
    }

    _isRefreshing = true;
    
    try {
      final refreshToken = _prefs.getString('refreshToken');
      if (refreshToken == null) {
        _isRefreshing = false;
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          await _prefs.setString('accessToken', data['data']['accessToken']);
          await _prefs.setString('refreshToken', data['data']['refreshToken']);
          _isRefreshing = false;
          return true;
        }
      }
      
      // Clear tokens if refresh failed
      await _prefs.remove('accessToken');
      await _prefs.remove('refreshToken');
      _isRefreshing = false;
      return false;
    } catch (e) {
      print('❌ Token refresh failed: $e');
      await _prefs.remove('accessToken');
      await _prefs.remove('refreshToken');
      _isRefreshing = false;
      return false;
    }
  }

  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      try {
        final data = json.decode(response.body);
        if (data['message']) {
          throw ApiException(
            message: data['message'],
            statusCode: response.statusCode,
          );
        }
      } catch (e) {
        // If parsing fails, throw the raw response
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    }
  }

  // Test connection method for debugging
  Future<bool> testConnection() async {
    try {
      print('🔍 Testing connection to: $baseUrl');
      final response = await http.get(Uri.parse('$baseUrl/pets'), headers: headers);
      print('✅ Connection test successful: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Connection test failed: $e');
      return false;
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() => 'ApiException: $message (Status Code: $statusCode)';
} 