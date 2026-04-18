// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'core/data/data_provider.dart';
// import 'core/routes/app_pages.dart';
// import 'screens/brands/provider/brand_provider.dart';
// import 'screens/category/provider/category_provider.dart';
// import 'screens/coupon_code/provider/coupon_code_provider.dart';
// import 'screens/dashboard/provider/dash_board_provider.dart';
// import 'screens/main/main_screen.dart';
// import 'screens/main/provider/main_screen_provider.dart';
// import 'screens/notification/provider/notification_provider.dart';
// import 'screens/order/provider/order_provider.dart';
// import 'screens/posters/provider/poster_provider.dart';
// import 'screens/sub_category/provider/sub_category_provider.dart';
// import 'screens/variants/provider/variant_provider.dart';
// import 'screens/variants_type/provider/variant_type_provider.dart';
// import 'utility/constants.dart';
// import 'utility/extensions.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MultiProvider(providers: [
//     ChangeNotifierProvider(create: (context) => DataProvider()),
//     ChangeNotifierProvider(create: (context) => MainScreenProvider()),
//     ChangeNotifierProvider(create: (context) => CategoryProvider(context.dataProvider)),
//     ChangeNotifierProvider(create: (context) => SubCategoryProvider(context.dataProvider)),
//     ChangeNotifierProvider(create: (context) => BrandProvider(context.dataProvider)),
//     ChangeNotifierProvider(create: (context) => VariantsTypeProvider(context.dataProvider)),
//     ChangeNotifierProvider(create: (context) => VariantsProvider(context.dataProvider)),
//     ChangeNotifierProvider(create: (context) => DashBoardProvider(context.dataProvider)),
//     ChangeNotifierProvider(create: (context) => CouponCodeProvider(context.dataProvider)),
//     ChangeNotifierProvider(create: (context) => PosterProvider(context.dataProvider)),
//     ChangeNotifierProvider(create: (context) => OrderProvider(context.dataProvider)),
//     ChangeNotifierProvider(create: (context) => NotificationProvider(context.dataProvider)),
//   ], child: MyApp()));
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Admin Panel',
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: bgColor,
//         textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.white),
//         canvasColor: secondaryColor,
//       ),
//       initialRoute: AppPages.HOME,
//       unknownRoute: GetPage(name: '/notFount', page: () => MainScreen()),
//       defaultTransition: Transition.cupertino,
//       getPages: AppPages.routes,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/data/data_provider.dart';
import 'core/routes/app_pages.dart';
import 'screens/main/main_screen.dart';
import 'screens/main/provider/main_screen_provider.dart';
import 'screens/category/provider/category_provider.dart';
import 'screens/sub_category/provider/sub_category_provider.dart';
import 'screens/brands/provider/brand_provider.dart';
import 'screens/variants/provider/variant_provider.dart';
import 'screens/variants_type/provider/variant_type_provider.dart';
import 'screens/dashboard/provider/dash_board_provider.dart';
import 'screens/coupon_code/provider/coupon_code_provider.dart';
import 'screens/posters/provider/poster_provider.dart';
import 'screens/order/provider/order_provider.dart';
import 'screens/notification/provider/notification_provider.dart';
import 'screens/users/provider/user_provider.dart';
import 'screens/rural_area/provider/rural_area_provider.dart';
import 'screens/status/provider/analytics_provider.dart';
import 'screens/login/provider/login_provider.dart';
import 'screens/shopkeepers/provider/shopkeeper_provider.dart';
import 'screens/vendor_products/provider/vendor_product_provider.dart';
import 'screens/app_version/provider/version_provider.dart';
import 'screens/app_control/provider/app_control_provider.dart';
import 'screens/reviews/provider/review_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'utility/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  runApp(
    MultiProvider(
      providers: [
        /// Main data provider (must come first)
        ChangeNotifierProvider(create: (context) {
          final provider = DataProvider();
          Get.put(provider); // Register with Get for global access (e.g. in LoginProvider)
          return provider;
        }),

        /// ✅ Dependent providers (use ProxyProvider)
        ChangeNotifierProxyProvider<DataProvider, CategoryProvider>(
          create: (context) => CategoryProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? CategoryProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, SubCategoryProvider>(
          create: (context) => SubCategoryProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? SubCategoryProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, BrandProvider>(
          create: (context) => BrandProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? BrandProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, VariantsTypeProvider>(
          create: (context) => VariantsTypeProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? VariantsTypeProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, VariantsProvider>(
          create: (context) => VariantsProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? VariantsProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, DashBoardProvider>(
          create: (context) => DashBoardProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? DashBoardProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, CouponCodeProvider>(
          create: (context) => CouponCodeProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? CouponCodeProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, PosterProvider>(
          create: (context) => PosterProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? PosterProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, OrderProvider>(
          create: (context) => OrderProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? OrderProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, NotificationProvider>(
          create: (context) => NotificationProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? NotificationProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, RuralAreaProvider>(
          create: (context) => RuralAreaProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? RuralAreaProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, UserProvider>(
          create: (context) => UserProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? UserProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, AnalyticsProvider>(
          create: (context) => AnalyticsProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? AnalyticsProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, ShopkeeperProvider>(
          create: (context) => ShopkeeperProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? ShopkeeperProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, VendorProductProvider>(
          create: (context) => VendorProductProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? VendorProductProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, VersionProvider>(
          create: (context) => VersionProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? VersionProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, AppControlProvider>(
          create: (context) => AppControlProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? AppControlProvider(dataProvider),
        ),
        ChangeNotifierProxyProvider<DataProvider, AdminReviewProvider>(
          create: (context) => AdminReviewProvider(context.read<DataProvider>()),
          update: (context, dataProvider, previous) =>
              previous ?? AdminReviewProvider(dataProvider),
        ),

        /// Independent providers
        ChangeNotifierProvider(create: (_) => MainScreenProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      initialRoute: AppPages.SPLASH,
      unknownRoute: GetPage(name: '/notFound', page: () => MainScreen()),
      defaultTransition: Transition.cupertino,
      getPages: AppPages.routes,
    );
  }
}
