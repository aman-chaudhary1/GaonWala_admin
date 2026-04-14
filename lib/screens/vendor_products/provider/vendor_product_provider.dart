import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../models/product.dart';
import '../../../../services/http_services.dart';

class VendorProductProvider extends ChangeNotifier {
  HttpService service = HttpService();
  bool isLoading = false;
  List<Product> pendingProducts = [];

  VendorProductProvider(dynamic dataProvider);

  Future<void> getPendingProducts() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await service.getItems(endpointUrl: 'products/admin/pending');
      if (response.isOk && response.body != null) {
        final List<dynamic> data = response.body['data'] ?? [];
        pendingProducts = data.map((p) => Product.fromJson(p)).toList();
      }
    } catch (e) {
      print('Error fetching pending products: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> approveProduct(Product product, double price, double? offerPrice) async {
    try {
      final response = await service.updateItem(
        endpointUrl: 'products/admin/approve',
        itemId: product.sId!,
        itemData: {
          'price': price,
          'offerPrice': offerPrice,
        },
      );

      if (response.statusCode == 200) {
        await getPendingProducts();
      }
    } catch (e) {
      print('Error approving product: $e');
    }
  }

  Future<void> rejectProduct(Product product, String reason) async {
    try {
      final response = await service.updateItem(
        endpointUrl: 'products/admin/reject',
        itemId: product.sId!,
        itemData: {'reason': reason},
      );

      if (response.statusCode == 200) {
        await getPendingProducts();
      }
    } catch (e) {
      print('Error rejecting product: $e');
    }
  }

}
