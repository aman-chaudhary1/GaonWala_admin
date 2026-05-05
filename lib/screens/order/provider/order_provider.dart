import '../../../models/order.dart';
import '../../../services/http_services.dart';
import 'package:flutter/material.dart';
import '../../../core/data/data_provider.dart';
import 'package:intl/intl.dart';


class OrderProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final orderFormKey = GlobalKey<FormState>();
  TextEditingController trackingUrlCtrl = TextEditingController();
  String selectedOrderStatus = 'pending';
  Order? orderForUpdate;
  
  // Advanced filtering state
  String? filterShopkeeperId;
  String? filterPaymentType;
  String? filterOrderId;
  DateTimeRange? filterDateRange;
  String currentStatus = 'All order';

  // Selection logic
  Set<String> selectedOrderIds = {};

  OrderProvider(this._dataProvider);

  // Getters for filtered orders
  List<Order> get filteredOrders => _applyAdvancedFilters(_dataProvider.orders);

  // Calls DataProvider fetch method
  Future<void> loadOrders() async {
    await _dataProvider.getAllOrders();
    clearSelection();
    notifyListeners();
  }

  void updateSelectedDate(DateTime? date) {
    if (date == null) {
      filterDateRange = null;
    } else {
      filterDateRange = DateTimeRange(
        start: DateTime(date.year, date.month, date.day),
        end: DateTime(date.year, date.month, date.day, 23, 59, 59),
      );
    }
    notifyListeners();
  }

  void updateDateRange(DateTimeRange? range) {
    filterDateRange = range;
    notifyListeners();
  }

  void updateShopkeeperFilter(String? shopkeeperId) {
    filterShopkeeperId = shopkeeperId;
    notifyListeners();
  }

  void updatePaymentTypeFilter(String? paymentType) {
    filterPaymentType = paymentType;
    notifyListeners();
  }

  void updateOrderIdFilter(String? orderId) {
    filterOrderId = orderId;
    notifyListeners();
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
    final currentlyFiltered = _applyAdvancedFilters(orders);
    if (selectedOrderIds.length == currentlyFiltered.length && currentlyFiltered.isNotEmpty) {
      selectedOrderIds.clear();
    } else {
      selectedOrderIds = currentlyFiltered.map((o) => o.sId!).toSet();
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

  // Local filtering logic
  List<Order> _applyAdvancedFilters(List<Order> orders) {
    return orders.where((order) {
      // Status Filter
      if (currentStatus != 'All order' && order.orderStatus?.toLowerCase() != currentStatus.toLowerCase()) {
        return false;
      }

      // Order ID Filter
      if (filterOrderId != null && filterOrderId!.isNotEmpty) {
        final shortId = order.sId?.substring((order.sId?.length ?? 0) - 6).toUpperCase() ?? '';
        if (!order.sId!.toLowerCase().contains(filterOrderId!.toLowerCase()) && 
            !shortId.contains(filterOrderId!.toUpperCase())) {
          return false;
        }
      }

      // Shopkeeper Filter
      if (filterShopkeeperId != null && filterShopkeeperId!.isNotEmpty) {
        bool hasVendorItem = order.items?.any((item) => item.vendorId == filterShopkeeperId) ?? false;
        if (!hasVendorItem) return false;
      }

      // Payment Type Filter
      if (filterPaymentType != null && filterPaymentType!.isNotEmpty) {
        if (order.paymentMethod?.toLowerCase() != filterPaymentType!.toLowerCase()) {
          return false;
        }
      }

      // Date Range Filter
      if (filterDateRange != null) {
        if (order.orderDate == null) return false;
        final orderDate = DateTime.parse(order.orderDate!).toLocal();
        if (orderDate.isBefore(filterDateRange!.start) || orderDate.isAfter(filterDateRange!.end)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Calls DataProvider filter method
  Future<void> filterOrders(String status) async {
    currentStatus = status;
    clearSelection();
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
