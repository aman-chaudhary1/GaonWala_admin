import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/routes/app_pages.dart';
import '../../../services/http_services.dart';
import '../../../core/data/data_provider.dart';
import 'dart:convert';

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

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final HttpService service = HttpService();
      final response = await service.addItem(
        endpointUrl: 'users/login',
        itemData: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.body is String ? json.decode(response.body) : response.body;
        
        if (body['success'] == true) {
          final String token = body['data']['token'];
          final String role = body['data']['user']['role'];

          if (role != 'admin') {
            _isLoading = false;
            _errorMessage = 'Access denied. Only admins can login here.';
            notifyListeners();
            return;
          }

          // Save login state and token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(_loginKey, true);
          await prefs.setString('token', token);
          
          _isLoggedIn = true;
          _isLoading = false;
          _errorMessage = null;
          notifyListeners();

          // Refresh all data now that we have a token
          try {
             final dataProvider = Get.find<DataProvider>();
             await dataProvider.refreshAllData();
          } catch (e) {
             print("Error refreshing data after login: $e");
          }

          // Navigate to main screen
          Get.offAllNamed(AppPages.HOME);
        } else {
          _isLoading = false;
          _errorMessage = body['message'] ?? 'Login failed';
          notifyListeners();
        }
      } else {
        _isLoading = false;
        final Map<String, dynamic> body = response.body is String ? json.decode(response.body) : (response.body ?? {});
        _errorMessage = body['message'] ?? 'Invalid email or password';
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Connection error: $e';
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await _saveLoginState(false);
    Get.offAllNamed(AppPages.LOGIN);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
