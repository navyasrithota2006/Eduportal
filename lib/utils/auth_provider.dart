import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'mock_data.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  // ─── Login ────────────────────────────────────────────────────
  Future<bool> login(String id, String password, String role) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    final user = MockData.users.where(
      (u) => u.id == id && u.password == password && u.role == role,
    ).firstOrNull;

    if (user != null) {
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid credentials. Please check your ID and password.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ─── Sign Up ──────────────────────────────────────────────────
  Future<bool> signUp({
    required String id,
    required String name,
    required String email,
    required String password,
    required String role,
    Map<String, dynamic> extra = const {},
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    // Check duplicate
    final exists = MockData.users.any((u) => u.id == id);
    if (exists) {
      _error = 'ID already registered. Please use a different ID.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final newUser = UserModel(
      id: id,
      name: name,
      email: email,
      role: role,
      password: password,
      extraData: extra,
    );
    MockData.users.add(newUser);
    _currentUser = newUser;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  // ─── Logout ───────────────────────────────────────────────────
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
