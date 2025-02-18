import 'package:flutter_application_1/models/user.dart';


class AuthService {
  static User? _registerUser;

  static void registerUser(String email, String password) {
    if (_registerUser != null && _registerUser!.email == email) {
      throw Exception('Email is already registered.');
    }
    _registerUser = User(email: email, password: password);
  }

  static bool validateLogin(String email, String password) {
    if (_registerUser == null) return false;
    return _registerUser!.email == email && _registerUser!.password == password;
  }
}