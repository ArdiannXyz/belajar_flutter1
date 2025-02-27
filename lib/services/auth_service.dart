import 'dart:async';
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';
import 'database_service.dart';
import '../utils/password_hash.dart';

class AuthService {
  final DatabaseService _dbService = DatabaseService.instance;

  // Track login attempts
  final Map<String, int> _loginAttempts = {};
  final Map<String, DateTime> _lockoutTime = {};
  static const int maxAttempts = 3;
  static const Duration lockoutDuration = Duration(minutes: 15);

  Future<AuthResult> login(String email, String password) async {
    // Check if user is locked out
    if (_isLockedOut(email)) {
      return AuthResult(
        success: false,
        message: 'Akun terkunci. Coba lagi dalam beberapa menit.',
      );
    }

    try {
      final user = await _dbService.getUserByEmail(email);

      if (user == null) {
        _incrementLoginAttempt(email);
        return AuthResult(
          success: false,
          message: 'Email atau password salah',
        );
      }

      if (!verifyPassword(password, user.password)) {
        _incrementLoginAttempt(email);
        return AuthResult(
          success: false,
          message: 'Email atau password salah',
        );
      }

      // Reset attempts on successful login
      _loginAttempts.remove(email);

      return AuthResult(
        success: true,
        user: user,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  bool _isLockedOut(String email) {
    final lockoutEndTime = _lockoutTime[email];
    if (lockoutEndTime != null) {
      if (DateTime.now().isBefore(lockoutEndTime)) {
        return true;
      } else {
        // Lockout period expired
        _loginAttempts.remove(email);
        _lockoutTime.remove(email);
      }
    }
    return false;
  }

  void _incrementLoginAttempt(String email) {
    _loginAttempts[email] = (_loginAttempts[email] ?? 0) + 1;

    if (_loginAttempts[email]! >= maxAttempts) {
      _lockoutTime[email] = DateTime.now().add(lockoutDuration);
    }
  }

  // Other auth features can be added here:
  // - requestPasswordReset()
  // - verifyEmail()
  // - refreshToken()
  // - logout()
}

class AuthResult {
  final bool success;
  final String? message;
  final User? user;

  AuthResult({
    required this.success,
    this.message,
    this.user,
  });
}
