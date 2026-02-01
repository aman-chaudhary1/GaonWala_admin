import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/routes/app_pages.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  static const String _loginKey = 'is_logged_in';

  // Dummy credentials
  static const String _dummyEmail = 'admin@admin.com';
  static const String _dummyPassword = 'admin123';

  LoginProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(_loginKey) ?? false;
      notifyListeners();
    } catch (e) {
      _isLoggedIn = false;
      notifyListeners();
    }
  }

  Future<void> _saveLoginState(bool isLoggedIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loginKey, isLoggedIn);
      _isLoggedIn = isLoggedIn;
      notifyListeners();
    } catch (e) {
      print('Error saving login state: $e');
    }
  }

  Future<bool> checkIfLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_loginKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  void login(String email, String password) {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate API call delay
    Future.delayed(Duration(seconds: 1), () async {
      // Validate credentials
      if (email == _dummyEmail && password == _dummyPassword) {
        // Save login state
        await _saveLoginState(true);
        
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();

        // Navigate to main screen
        Get.offAllNamed(AppPages.HOME);
      } else {
        _isLoading = false;
        _errorMessage = 'Invalid email or password';
        notifyListeners();
      }
    });
  }

  Future<void> logout() async {
    await _saveLoginState(false);
    Get.offAllNamed(AppPages.LOGIN);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
