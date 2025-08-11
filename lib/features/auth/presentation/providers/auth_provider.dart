import 'package:flutter/material.dart';
import 'package:saathi/core/services/service_provider.dart';
import 'package:saathi/features/auth/data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = ServiceProvider().authService;
  
  bool _isLoading = true;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _user;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get user => _user;
  String? get error => _error;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_authService.isLoggedIn) {
        // Try to get user profile to verify token is still valid
        try {
          _user = await _authService.getProfile();
          _isAuthenticated = true;
          _error = null;
        } catch (e) {
          // Token might be expired, try to refresh
          try {
            await _authService.refreshAccessToken();
            _user = await _authService.getProfile();
            _isAuthenticated = true;
            _error = null;
          } catch (refreshError) {
            // Refresh failed, user needs to login again
            await _authService.logout();
            _isAuthenticated = false;
            _user = null;
            _error = null;
          }
        }
      } else {
        _isAuthenticated = false;
        _user = null;
        _error = null;
      }
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _user = await _authService.login(email: email, password: password);
      _isAuthenticated = true;
      
      return true;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _user = null;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _user = await _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      _isAuthenticated = true;
      
      return true;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _user = null;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.logout();
      _isAuthenticated = false;
      _user = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUser() async {
    if (_isAuthenticated) {
      try {
        _user = await _authService.getProfile();
        notifyListeners();
      } catch (e) {
        // If getting profile fails, user might be logged out
        await logout();
      }
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 