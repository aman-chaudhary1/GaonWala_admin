import '../../../models/order.dart';
import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';


class OrderProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final orderFormKey = GlobalKey<FormState>();
  TextEditingController trackingUrlCtrl = TextEditingController();
  String selectedOrderStatus = 'pending';
  Order? orderForUpdate;

  OrderProvider(this._dataProvider);
  // Calls DataProvider fetch method
  Future<void> loadOrders() async {
    await _dataProvider.getAllOrders();
    notifyListeners();
  }

  // Calls DataProvider filter method
  Future<void> filterOrders(String status) async {
    _dataProvider.filterOrders(status);
    notifyListeners();
  }
  //TODO: should complete updateOrder

  Future<void> updateOrder(String orderId) async {
    final body = {
      "orderStatus": selectedOrderStatus,
      "trackingUrl": trackingUrlCtrl.text
    };

    final response = await service.updateItem(
        endpointUrl: "orders", itemId: orderId, itemData: body);

    if (response.statusCode == 200) {
      await loadOrders();
    } else {
      print("Update failed: ${response.body}");
    }
  }

  //TODO: should complete deleteOrder
  Future<void> deleteOrder(String id) async {
    final response = await service.deleteItem(endpointUrl: "orders", itemId: id);

    if (response.statusCode == 200) {
      await loadOrders();
    }
    notifyListeners();
  }


  updateUI() {
    notifyListeners();
  }
}
