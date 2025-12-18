import 'package:get/get_navigation/src/routes/get_route.dart';
import '../../screens/main/main_screen.dart';
import '../../screens/login/login_screen.dart';
import '../../screens/login/auth_wrapper.dart';



class AppPages {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const HOME = '/home';

  static final routes = [
    GetPage(
      name: SPLASH,
      page: () => AuthWrapper()
    ),
    GetPage(
      name: LOGIN,
      page: () => LoginScreen()
    ),
    GetPage(
      name: HOME,
      fullscreenDialog: true,
      page: () => MainScreen()
    ),

  ];
}
