import '../../../models/order.dart';
import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';
import 'package:intl/intl.dart';


class OrderProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final orderFormKey = GlobalKey<FormState>();
  TextEditingController trackingUrlCtrl = TextEditingController();
  String selectedOrderStatus = 'pending';
  Order? orderForUpdate;
  
  // Date filtering logic
  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;

  // Selection logic for bulk update
  Set<String> selectedOrderIds = {};

  OrderProvider(this._dataProvider);
  // Calls DataProvider fetch method
  Future<void> loadOrders() async {
    String? formattedDate;
    if (_selectedDate != null) {
      formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
    await _dataProvider.getAllOrders(date: formattedDate);
    clearSelection(); // Clear selection when refreshing orders
    notifyListeners();
  }

  void updateSelectedDate(DateTime? date) {
    _selectedDate = date;
    loadOrders();
  }

  // Selection methods
  bool isSelected(String id) => selectedOrderIds.contains(id);

  void toggleSelection(String id) {
    if (selectedOrderIds.contains(id)) {
      selectedOrderIds.remove(id);
    } else {
      selectedOrderIds.add(id);
    }
    notifyListeners();
  }

  void selectAll(List<Order> orders) {
    if (selectedOrderIds.length == orders.length) {
      selectedOrderIds.clear();
    } else {
      selectedOrderIds = orders.map((o) => o.sId!).toSet();
    }
    notifyListeners();
  }

  void clearSelection() {
    selectedOrderIds.clear();
    notifyListeners();
  }

  void updateOrderDetails(Order? order) {
    orderForUpdate = order;
    trackingUrlCtrl.text = order?.trackingUrl ?? '';
    selectedOrderStatus = order?.orderStatus ?? 'pending';
    notifyListeners();
  }

  // Calls DataProvider filter method
  Future<void> filterOrders(String status) async {
    _dataProvider.filterOrders(status);
    clearSelection(); // Clear selection when filter changes
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

  // Bulk update status
  Future<bool> updateBulkOrderStatus(String newStatus) async {
    if (selectedOrderIds.isEmpty) return false;

    final body = {
      "orderIds": selectedOrderIds.toList(),
      "newStatus": newStatus
    };

    final response = await service.updateItem(
        endpointUrl: "orders", itemId: "bulk-update", itemData: body);

    if (response.statusCode == 200) {
      await loadOrders();
      clearSelection();
      return true;
    } else {
      print("Bulk update failed: ${response.body}");
      return false;
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
