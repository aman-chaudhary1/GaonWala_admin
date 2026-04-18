import '../../brands/brand_screen.dart';
import '../../category/category_screen.dart';
import '../../coupon_code/coupon_code_screen.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../notification/notification_screen.dart';
import '../../order/order_screen.dart';
import '../../posters/poster_screen.dart';
import '../../variants/variants_screen.dart';
import '../../variants_type/variants_type_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../users/users_screen.dart';
import '../../status/status_screen.dart';
import '../../sub_category/sub_category_screen.dart';
import '../../rural_area/rural_area_screen.dart';
import '../../shopkeepers/shopkeepers_screen.dart';
import '../../vendor_products/vendor_product_screen.dart';
import '../../app_version/version_screen.dart';
import '../../app_control/app_control_screen.dart';
import '../../reviews/review_screen.dart';

class MainScreenProvider extends ChangeNotifier{
  Widget selectedScreen = DashboardScreen();



  navigateToScreen(String screenName) {
    switch (screenName) {
      case 'Dashboard':
        selectedScreen = DashboardScreen();
        break; // Break statement needed here
      case 'Category':
        selectedScreen = CategoryScreen();
        break;
      case 'SubCategory':
        selectedScreen = SubCategoryScreen();
        break;
      case 'Brands':
        selectedScreen = BrandScreen();
        break;
      case 'VariantType':
        selectedScreen = VariantsTypeScreen();
        break;
      case 'Variants':
        selectedScreen = VariantsScreen();
        break;
      case 'Coupon':
        selectedScreen = CouponCodeScreen();
        break;
      case 'Poster':
        selectedScreen = PosterScreen();
        break;
      case 'Order':
        selectedScreen = OrderScreen();
        break;
      case 'Notifications':
        selectedScreen = NotificationScreen();
        break;
      case 'Users':
        selectedScreen = UsersScreen();
        break;
      case 'Status':
        selectedScreen = StatusScreen();
        break;
      case 'RuralArea':
        selectedScreen = RuralAreaScreen();
        break;
      case 'Shopkeepers':
        selectedScreen = ShopkeepersScreen();
        break;
      case 'VendorProducts':
        selectedScreen = VendorProductScreen();
        break;
      case 'AppVersion':
        selectedScreen = VersionUpdateScreen();
        break;
      case 'AppControl':
        selectedScreen = AppControlScreen();
        break;
      case 'Reviews':
        selectedScreen = AdminReviewScreen();
        break;
      default:
        selectedScreen = DashboardScreen();
    }
    notifyListeners();
  }
  
  
}