import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saathi/core/services/service_provider.dart';
import 'package:saathi/features/auth/data/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = ServiceProvider().authService;

  AuthBloc() : super(const AuthInitial()) {
    on<AuthCheckStatusRequested>(_onCheckStatus);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthClearErrorRequested>(_onClearError);
  }

  Future<void> _onCheckStatus(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      if (_authService.isLoggedIn) {
        try {
          final user = await _authService.getProfile();
          emit(AuthAuthenticated(user: user));
        } catch (e) {
          // Token might be expired, try to refresh
          try {
            await _authService.refreshAccessToken();
            final user = await _authService.getProfile();
            emit(AuthAuthenticated(user: user));
          } catch (refreshError) {
            // Refresh failed, log out
            await _authService.logout();
            emit(const AuthUnauthenticated());
          }
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthFailure(
        errorMessage: e.toString(),
        wasAuthenticated: false,
      ));
    }
  }

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authService.login(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthFailure(
        errorMessage: e.toString(),
        wasAuthenticated: false,
      ));
    }
  }

  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authService.register(
        name: event.name,
        email: event.email,
        password: event.password,
        phone: event.phone,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthFailure(
        errorMessage: e.toString(),
        wasAuthenticated: false,
      ));
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authService.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(
        errorMessage: e.toString(),
        wasAuthenticated: true,
      ));
    }
  }

  void _onClearError(
    AuthClearErrorRequested event,
    Emitter<AuthState> emit,
  ) {
    if (state is AuthFailure) {
      final wasAuth = (state as AuthFailure).wasAuthenticated;
      if (wasAuth) {
        // Fall back to Unauthenticated or if they were authenticated but logout/refresh failed, Unauthenticated is safer
        emit(const AuthUnauthenticated());
      } else {
        emit(const AuthUnauthenticated());
      }
    } else if (state is AuthUnauthenticated) {
      emit(const AuthUnauthenticated());
    }
  }
}
