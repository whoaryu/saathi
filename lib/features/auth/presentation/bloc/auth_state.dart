import 'package:flutter/foundation.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final Map<String, dynamic> user;

  const AuthAuthenticated({required this.user});
}

class AuthUnauthenticated extends AuthState {
  final String? error;

  const AuthUnauthenticated({this.error});
}

class AuthFailure extends AuthState {
  final String errorMessage;
  final bool wasAuthenticated;

  const AuthFailure({
    required this.errorMessage,
    this.wasAuthenticated = false,
  });
}
