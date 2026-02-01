import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'provider/login_provider.dart';
import '../../core/routes/app_pages.dart';
import '../../utility/constants.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final isLoggedIn = await loginProvider.checkIfLoggedIn();
    
    if (mounted) {
      setState(() {
        _isChecking = false;
      });

      if (isLoggedIn) {
        // User is logged in, navigate to home
        Get.offAllNamed(AppPages.HOME);
      } else {
        // User is not logged in, navigate to login
        Get.offAllNamed(AppPages.LOGIN);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      // Show loading screen while checking auth status
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
      );
    }

    // This should not be reached, but return empty container as fallback
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(),
    );
  }
}
