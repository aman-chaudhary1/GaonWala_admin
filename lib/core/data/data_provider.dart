import '../../models/api_response.dart';
import '../../models/coupon.dart';
import '../../models/my_notification.dart';
import '../../models/order.dart';
import '../../models/poster.dart';
import '../../models/product.dart';
import '../../models/variant_type.dart';
import '../../services/http_services.dart';
import '../../utility/snack_bar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import '../../../models/category.dart';
import '../../models/brand.dart';
import '../../models/sub_category.dart';
import '../../models/variant.dart';
import '../../models/user.dart';
import 'dart:async';
import '../../utility/notification_helper.dart';
import '../../utility/sound_helper.dart';

class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];

  List<Category> get categories => _filteredCategories;

  List<SubCategory> _allSubCategories = [];
  List<SubCategory> _filteredSubCategories = [];

  List<SubCategory> get subCategories => _filteredSubCategories;

  List<Brand> _allBrands = [];
  List<Brand> _filteredBrands = [];

  List<Brand> get brands => _filteredBrands;

  List<VariantType> _allVariantTypes = [];
  List<VariantType> _filteredVariantTypes = [];

  List<VariantType> get variantTypes => _filteredVariantTypes;

  List<Variant> _allVariants = [];
  List<Variant> _filteredVariants = [];

  List<Variant> get variants => _filteredVariants;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  List<Product> get products => _filteredProducts;

  List<Coupon> _allCoupons = [];
  List<Coupon> _filteredCoupons = [];

  List<Coupon> get coupons => _filteredCoupons;

  List<Poster> _allPosters = [];
  List<Poster> _filteredPosters = [];

  List<Poster> get posters => _filteredPosters;

  List<Order> _allOrders = [];
  List<Order> _filteredOrders = [];

  List<Order> get orders => _filteredOrders;

  List<MyNotification> _allNotifications = [];
  List<MyNotification> _filteredNotifications = [];

  List<MyNotification> get notifications => _filteredNotifications;

  List<User> _allUsers = [];
  List<User> _filteredUsers = [];
  List<User> get users => _filteredUsers;

  Timer? _orderPollingTimer;
  Set<String> _knownOrderIds = {};
  bool _isFirstLoad = true;
  String notificationStatus = "Initializing...";

  DataProvider() {
    startOrderPolling();
    refreshAllData();
  }

  Future<void> refreshAllData() async {
    print("🔄 DataProvider: Refreshing all data...");
    await Future.wait([
      getAllProduct(),
      getAllCategory(),
      getAllSubCategory(),
      getAllBrands(),
      getAllVariantTypes(),
      getAllVariant(),
      getAllPosters(),
      getAllCoupons(),
      getAllOrders(),
      getAllNotifications(),
      getAllUsers(),
    ]);
    print("✅ DataProvider: All data refreshed.");
  }

  void startOrderPolling() {
    print("Notification System: Starting order polling (every 30s)");
    _orderPollingTimer?.cancel();
    _orderPollingTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      checkNewOrders();
    });
  }

  Future<void> checkNewOrders() async {
    try {
      print("Notification System: Checking for new orders...");
      notificationStatus = "Checking...";
      notifyListeners();
      final response = await service.getItems(endpointUrl: "orders");
      if (response.isOk) {
        notificationStatus = "Active";
        ApiResponse<List<Order>> apiResponse =
            ApiResponse<List<Order>>.fromJson(
          response.body,
          (json) => (json as List).map((item) => Order.fromJson(item)).toList(),
        );

        final orders = apiResponse.data ?? [];
        print("Notification System: Fetched ${orders.length} orders. Known IDs: ${_knownOrderIds.length}");
        if (orders.isNotEmpty) {
          // Detect any new IDs that were not in our known set
          bool foundNewOrder = false;
          for (var order in orders) {
            String? id = order.sId;
            if (id != null && _knownOrderIds.isNotEmpty && !_knownOrderIds.contains(id)) {
              print("Notification System: >>> NEW ORDER DETECTED! ID: $id <<<");
              foundNewOrder = true;
              NotificationHelper.showNotification(
                  "New Order Received!", "Order ID: $id");
              SoundHelper.playNotificationSound();
            }
          }
          
          // Update known IDs
          _knownOrderIds.addAll(orders.map((o) => o.sId ?? "").where((id) => id.isNotEmpty));
          
          if (foundNewOrder) {
            _allOrders = orders;
            _filteredOrders = List.from(_allOrders);
            notifyListeners();
          }
        }
      } else {
        notificationStatus = "Error: ${response.statusCode}";
        print("Notification System: API Error - ${response.statusText}");
      }
      notifyListeners();
    } catch (e) {
      notificationStatus = "Error: Exception";
      print("Notification System: Error checking new orders: $e");
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _orderPollingTimer?.cancel();
    super.dispose();
  }

  //TODO: should complete getAllCategory(complete)
  Future<List<Category>> getAllCategory({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'categories');
      if (response.isOk) {
        ApiResponse<List<Category>> apiResponse =
            ApiResponse<List<Category>>.fromJson(
                response.body,
                (json) => (json as List)
                    .map((item) => Category.fromJson(item))
                    .toList());
        _allCategories = apiResponse.data ?? [];
        _filteredCategories =
            List.from(_allCategories); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
    }
    return _filteredCategories;
  }

  //TODO: should complete filterCategories(complete)
  void filterCategories(String Keyword) {
    if (Keyword.isEmpty) {
      _filteredCategories = List.from(_allCategories);
    } else {
      final lowerKeyword = Keyword.toLowerCase();
      _filteredCategories = _allCategories.where((category) {
        return (category.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

  //TODO: should complete getAllSubCategory(complete)
  Future<List<SubCategory>> getAllSubCategory({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'SubCategories');
      if (response.isOk) {
        ApiResponse<List<SubCategory>> apiResponse =
            ApiResponse<List<SubCategory>>.fromJson(
                response.body,
                (json) => (json as List)
                    .map((item) => SubCategory.fromJson(item))
                    .toList());
        _allSubCategories = apiResponse.data ?? [];
        _filteredSubCategories = List.from(
            _allSubCategories); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
    }
    return _filteredSubCategories;
  }

  //TODO: should complete filterSubCategories(complete)
  void filterSubCategories(String Keyword) {
    if (Keyword.isEmpty) {
      _filteredSubCategories = List.from(_allSubCategories);
    } else {
      final lowerKeyword = Keyword.toLowerCase();
      _filteredSubCategories = _allSubCategories.where((subcategory) {
        return (subcategory.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

  //TODO: should complete getAllBrands(complete)
  Future<List<Brand>> getAllBrands({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'brands');
      if (response.isOk) {
        ApiResponse<List<Brand>> apiResponse =
            ApiResponse<List<Brand>>.fromJson(
                response.body,
                (json) => (json as List)
                    .map((item) => Brand.fromJson(item))
                    .toList());
        _allBrands = apiResponse.data ?? [];
        _filteredBrands =
            List.from(_allBrands); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
    }
    return _filteredBrands;
  }

  //TODO: should complete filterBrands(complete)
  void filterBrands(String Keyword) {
    if (Keyword.isEmpty) {
      _filteredBrands = List.from(_allBrands);
    } else {
      final lowerKeyword = Keyword.toLowerCase();
      _filteredBrands = _allBrands.where((brand) {
        return (brand.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

  //TODO: should complete getAllVariantType(complete)
  Future<List<VariantType>> getAllVariantTypes({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'variantTypes');
      if (response.isOk) {
        ApiResponse<List<VariantType>> apiResponse =
            ApiResponse<List<VariantType>>.fromJson(
                response.body,
                (json) => (json as List)
                    .map((item) => VariantType.fromJson(item))
                    .toList());
        _allVariantTypes = apiResponse.data ?? [];
        _filteredVariantTypes = List.from(
            _allVariantTypes); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
    }
    return _filteredVariantTypes;
  }

  //TODO: should complete filterVariantTypes(cpmlete)
  void filterVariantTypes(String Keyword) {
    if (Keyword.isEmpty) {
      _filteredVariantTypes = List.from(_allVariantTypes);
    } else {
      final lowerKeyword = Keyword.toLowerCase();
      _filteredVariantTypes = _allVariantTypes.where((variantType) {
        return (variantType.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

  //TODO: should complete getAllVariant(complete)
  Future<List<Variant>> getAllVariant({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'variants');
      if (response.isOk) {
        ApiResponse<List<Variant>> apiResponse =
            ApiResponse<List<Variant>>.fromJson(
                response.body,
                (json) => (json as List)
                    .map((item) => Variant.fromJson(item))
                    .toList());
        _allVariants = apiResponse.data ?? [];
        _filteredVariants =
            List.from(_allVariants); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
    }
    return _filteredVariants;
  }

  //TODO: should complete filterVariants(Complete)
  void filterVariants(String Keyword) {
    if (Keyword.isEmpty) {
      _filteredVariants = List.from(_allVariants);
    } else {
      final lowerKeyword = Keyword.toLowerCase();
      _filteredVariants = _allVariants.where((variant) {
        return (variant.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

  //TODO: should complete getAllProduct
  Future<void> getAllProduct({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'products', query: {'status': 'all'});
      if (response.isOk) {
        ApiResponse<List<Product>> apiResponse =
            ApiResponse<List<Product>>.fromJson(
                response.body,
                (json) => (json as List)
                    .map((item) => Product.fromJson(item))
                    .toList());
        _allProducts = apiResponse.data ?? [];
        _filteredProducts =
            List.from(_allProducts); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        print("❌ Error fetching products: ${response.statusText} (${response.statusCode})");
      }
    } catch (e) {
      print("❌ Parsing error in getAllProduct: $e");
      SnackBarHelper.showErrorSnackBar(e.toString());
    }
  }

  //TODO: should complete filterProducts
  void filterProducts(String Keyword) {
    if (Keyword.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      final lowerKeyword = Keyword.toLowerCase();
      _filteredProducts = _allProducts.where((product) {
        final productNameContainsKeyword =
            (product.name ?? '').toLowerCase().contains(lowerKeyword);
        final categoryNameContainsKeyword = product.proSubCategoryId?.name
                ?.toLowerCase()
                .contains(lowerKeyword) ??
            false;
        final subCategoryNameContainsKeyword = product.proSubCategoryId?.name
                ?.toLowerCase()
                .contains(lowerKeyword) ??
            false;

        return productNameContainsKeyword ||
            categoryNameContainsKeyword ||
            subCategoryNameContainsKeyword;
      }).toList();
    }
    notifyListeners();
  }

  //TODO: should complete getAllCoupons
  Future<List<Coupon>> getAllCoupons({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'couponCodes');
      if (response.isOk) {
        ApiResponse<List<Coupon>> apiResponse =
            ApiResponse<List<Coupon>>.fromJson(
                response.body,
                (json) => (json as List)
                    .map((item) => Coupon.fromJson(item))
                    .toList());
        _allCoupons = apiResponse.data ?? [];
        _filteredCoupons =
            List.from(_allCoupons); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
    }
    return _filteredCoupons;
  }

  //TODO: should complete filterCoupons
  void filterCoupons(String Keyword) {
    if (Keyword.isEmpty) {
      _filteredCoupons = List.from(_allCoupons);
    } else {
      final lowerKeyword = Keyword.toLowerCase();
      _filteredCoupons = _allCoupons.where((coupon) {
        return (coupon.couponCode ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }
  //TODO: should complete getAllPosters

  Future<List<Poster>> getAllPosters({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'posters');
      if (response.isOk) {
        ApiResponse<List<Poster>> apiResponse =
            ApiResponse<List<Poster>>.fromJson(
                response.body,
                (json) => (json as List)
                    .map((item) => Poster.fromJson(item))
                    .toList());
        _allPosters = apiResponse.data ?? [];
        _filteredPosters =
            List.from(_allPosters); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
    }
    return _filteredPosters;
  }

  //TODO: should complete filterPosters

  void filterPosters(String Keyword) {
    if (Keyword.isEmpty) {
      _filteredPosters = List.from(_allPosters);
    } else {
      final lowerKeyword = Keyword.toLowerCase();
      _filteredPosters = _allPosters.where((poster) {
        return (poster.posterName ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

  //TODO: should complete getAllNotifications
  Future<List<MyNotification>> getAllNotifications(
      {bool showSnack = false}) async {
    try {
      // Corrected endpoint from 'notification' to 'notification/all-notification'
      Response response = await service.getItems(endpointUrl: 'notification/all-notification');
      if (response.isOk) {
        ApiResponse<List<MyNotification>> apiResponse =
            ApiResponse<List<MyNotification>>.fromJson(
                response.body,
                (json) => (json as List)
                    .map((item) => MyNotification.fromJson(item))
                    .toList());
        _allNotifications = apiResponse.data ?? [];
        _filteredNotifications = List.from(
            _allNotifications); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
    }
    return _filteredNotifications;
  }

  //TODO: should complete filterNotifications
  void filterNotifications(String Keyword) {
    if (Keyword.isEmpty) {
      _filteredNotifications = List.from(_allNotifications);
    } else {
      final lowerKeyword = Keyword.toLowerCase();
      _filteredNotifications = _allNotifications.where((notification) {
        return (notification.title ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

  //TODO: should complete getAllOrders
  Future<List<Order>> getAllOrders({bool showSnack = false, String? date}) async {
    try {
      Map<String, dynamic>? query;
      if (date != null) {
        query = {"date": date};
      }
      final response = await service.getItems(endpointUrl: "orders", query: query);

      if (response.isOk) {
        ApiResponse<List<Order>> apiResponse =
            ApiResponse<List<Order>>.fromJson(
          response.body,
          (json) => (json as List).map((item) => Order.fromJson(item)).toList(),
        );

        _allOrders = apiResponse.data ?? [];
        _filteredOrders = List.from(_allOrders);
        
        // Only populate known IDs on first load or if it was empty
        if (_isFirstLoad || _knownOrderIds.isEmpty) {
          _knownOrderIds = _allOrders.map((o) => o.sId ?? "").toSet();
          _isFirstLoad = false;
          print("Notification System: Initialized known IDs with ${_knownOrderIds.length} orders");
        }

        notifyListeners();

        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
    }

    return _filteredOrders;
  }

  //TODO: should complete filterOrders
  void filterOrders(String status) {
    if (status.toLowerCase() == "all order") {
      _filteredOrders = List.from(_allOrders);
    } else {
      _filteredOrders = _allOrders
          .where(
            (o) => (o.orderStatus ?? '').toLowerCase() == status.toLowerCase(),
          )
          .toList();
    }

    notifyListeners();
  }

  //TODO: should complete calculateOrdersWithStatus
  Map<String, int> calculateOrdersWithStatus() {
    final Map<String, int> result = {
      'all': 0,
      'pending': 0,
      'processing': 0,
      'cancelled': 0,
      'shipped': 0,
      'delivered': 0,
    };

    for (var order in _allOrders) {
      final status = (order.orderStatus ?? "").toLowerCase();

      result['all'] = result['all']! + 1;

      if (result.containsKey(status)) {
        result[status] = result[status]! + 1;
      }
    }

    return result;
  }

  //TODO: should complete filterProductsByQuantity(complete)
  void filterProductsByQuantity(String productQntType) {
    if (productQntType == 'All Product') {
      _filteredProducts = List.from(_allProducts);
    } else if (productQntType == 'Out of Stock') {
      _filteredProducts = _allProducts.where((product) {
        return product.quantity != null && product.quantity == 0;
      }).toList();
    } else if (productQntType == 'Limited Stock') {
      _filteredProducts = _allProducts.where((product) {
        return product.quantity != null && product.quantity == 1;
      }).toList();
    } else if (productQntType == 'Other Stock') {
      _filteredProducts = _allProducts.where((product) {
        return product.quantity != null &&
            product.quantity != 0 &&
            product.quantity != 1;
      }).toList();
    } else {
      _filteredProducts = List.from(_allProducts);
    }
    notifyListeners();
  }

  //TODO: should complete calculateProductWithQuantity(complete)

  int calculateProductWithQuantity({int? quantity}) {
    int totalProduct = 0;
    // if targetQuantity is null it return total products
    if (quantity == null) {
      totalProduct = _allProducts.length;
    } else {
      for (Product product in _allProducts) {
        if (product.quantity != null && product.quantity == quantity) {
          totalProduct++;
        }
      }
    }
    return totalProduct;
  }

  // Get All Users
  Future<List<User>> getAllUsers({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'users');
      if (response.isOk) {
        // Robust JSON parsing for web environments
        final dynamic responseBody = response.body is String 
            ? json.decode(response.body) 
            : response.body;

        ApiResponse<List<User>> apiResponse = ApiResponse<List<User>>.fromJson(
            responseBody,
            (json) =>
                (json as List).map((item) => User.fromJson(item)).toList());
        _allUsers = apiResponse.data ?? [];
        _filteredUsers = List.from(_allUsers);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        print("❌ Error fetching users: ${response.statusText} (${response.statusCode})");
        print("❌ Response Body: ${response.bodyString}");
        if (response.statusCode == 401) {
          print("⚠️ Authorization failed. Please log out and log back in as an Admin.");
        }
      }
    } catch (e) {
      print("❌ Parsing error in getAllUsers: $e");
      SnackBarHelper.showErrorSnackBar("Data parsing error. Check console for details.");
    }
    return _filteredUsers;
  }

  // Filter Users
  void filterUsers(String keyword) {
    if (keyword.isEmpty) {
      _filteredUsers = List.from(_allUsers);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredUsers = _allUsers.where((user) {
        return (user.name ?? '').toLowerCase().contains(lowerKeyword) || 
               (user.email ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

}
