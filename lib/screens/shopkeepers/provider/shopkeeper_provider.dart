import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/data/data_provider.dart';
import '../../../../models/api_response.dart';
import '../../../../models/user.dart';
import '../../../../services/http_services.dart';
import '../../../../utility/snack_bar_helper.dart';

class ShopkeeperProvider extends ChangeNotifier {
  HttpService service = HttpService();
  bool isLoading = false;
  List<User> shopkeepers = [];
  final DataProvider _dataProvider;

  ShopkeeperProvider(this._dataProvider) {
    // We can inject DataProvider if needed for initial data
  }

  Future<void> getAllShopkeepers() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await service.getItems(endpointUrl: 'users');
      if (response.isOk && response.body != null) {
        // Robust JSON parsing for web environments
        final dynamic responseBody = response.body is String 
            ? json.decode(response.body) 
            : response.body;

        final List<dynamic> data = responseBody['data'] ?? [];
        shopkeepers = data
            .map((u) => User.fromJson(u))
            .where((u) => u.role == 'shopkeeper')
            .toList();
      } else {
        print("❌ Shopkeeper Error: ${response.statusCode} - ${response.statusText}");
      }
    } catch (e) {
      print('Error fetching shopkeepers: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateShopStatus(User shopkeeper) async {
    try {
      final newStatus = shopkeeper.shopStatus == 'active' ? 'inactive' : 'active';
      final response = await service.updateItem(
        endpointUrl: 'users',
        itemId: shopkeeper.sId!,
        itemData: {'shopStatus': newStatus},
      );

      if (response.statusCode == 200) {
        SnackBarHelper.showSuccessSnackBar('Shop status updated to $newStatus');
        // Refresh the main DataProvider so the UI updates
        await _dataProvider.getAllUsers();
        await getAllShopkeepers();
      } else {
        SnackBarHelper.showErrorSnackBar('Failed to update shop status');
      }
    } catch (e) {
      print('Error updating shop status: $e');
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
    }
  }

  Future<void> assignCategories(User shopkeeper, List<String> categoryIds, List<String> subCategoryIds) async {
    try {
      final response = await service.updateItem(
        endpointUrl: 'users',
        itemId: shopkeeper.sId!,
        itemData: {
          'assignedCategories': categoryIds,
          'assignedSubCategories': subCategoryIds,
        },
      );

      if (response.statusCode == 200) {
        SnackBarHelper.showSuccessSnackBar('Categories assigned successfully');
        // Refresh the main DataProvider so the UI updates
        await _dataProvider.getAllUsers();
        await getAllShopkeepers();
      } else {
        SnackBarHelper.showErrorSnackBar('Failed to assign categories');
      }
    } catch (e) {
      print('Error assigning categories: $e');
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
    }
  }
}

