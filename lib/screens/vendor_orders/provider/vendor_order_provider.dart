import 'package:flutter/cupertino.dart';
import '../../../services/http_services.dart';
import '../../../models/order.dart';
import '../../../models/user.dart';

class VendorOrderProvider extends ChangeNotifier {
  final HttpService _service = HttpService();
  List<VendorOrderGroup> _allGroups = [];
  List<VendorOrderGroup> _filteredGroups = [];
  bool _isLoading = false;
  String _currentFilter = 'all';

  List<VendorOrderGroup> get groups => _filteredGroups;
  bool get isLoading => _isLoading;
  String get currentFilter => _currentFilter;

  Future<void> loadVendorOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch orders and shopkeepers in parallel
      final ordersResponse = await _service.getItems(endpointUrl: 'orders');
      final usersResponse = await _service.getItems(endpointUrl: 'users');

      // Parse shopkeepers
      Map<String, User> shopkeeperMap = {};
      if (usersResponse.statusCode == 200 && usersResponse.body != null) {
        final userData = usersResponse.body;
        List userList = [];
        if (userData is Map && userData['data'] != null) {
          userList = userData['data'] as List;
        } else if (userData is List) {
          userList = userData;
        }
        for (var json in userList) {
          final user = User.fromJson(json);
          if (user.role == 'shopkeeper' && user.sId != null) {
            shopkeeperMap[user.sId!] = user;
          }
        }
      }

      // Parse orders
      List<Order> allOrders = [];
      if (ordersResponse.statusCode == 200 && ordersResponse.body != null) {
        final data = ordersResponse.body;
        if (data is Map && data['data'] != null) {
          allOrders = (data['data'] as List)
              .map((json) => Order.fromJson(json))
              .toList();
        } else if (data is List) {
          allOrders = data.map((json) => Order.fromJson(json)).toList();
        }
      }

      // Group: For each order, for each unique vendorId, create a VendorOrderGroup
      _allGroups = [];
      for (var order in allOrders) {
        final items = order.items ?? [];
        // Get unique vendorIds in this order
        final vendorIds = items
            .where((item) => item.vendorId != null && item.vendorId!.isNotEmpty)
            .map((item) => item.vendorId!)
            .toSet();

        for (var vendorId in vendorIds) {
          final vendorItems = items.where((i) => i.vendorId == vendorId).toList();
          final shopkeeper = shopkeeperMap[vendorId];

          _allGroups.add(VendorOrderGroup(
            order: order,
            vendorId: vendorId,
            vendorName: shopkeeper?.name ?? 'Unknown Vendor',
            shopName: shopkeeper?.shopName ?? 'N/A',
            shopAddress: shopkeeper?.shopAddress ?? 'N/A',
            vendorPhone: shopkeeper?.phoneNo ?? 'N/A',
            vendorEmail: shopkeeper?.email ?? 'N/A',
            vendorItems: vendorItems,
          ));
        }
      }

      // Sort by date descending
      _allGroups.sort((a, b) => (b.order.orderDate ?? '').compareTo(a.order.orderDate ?? ''));

      _applyFilter();
    } catch (e) {
      print('Error loading vendor orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByStatus(String status) {
    _currentFilter = status;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_currentFilter == 'all') {
      _filteredGroups = List.from(_allGroups);
    } else {
      _filteredGroups = _allGroups
          .where((g) => g.vendorStatus.toLowerCase() == _currentFilter.toLowerCase())
          .toList();
    }
  }
}

/// Represents one vendor's items within a single order
class VendorOrderGroup {
  final Order order;
  final String vendorId;
  final String vendorName;
  final String shopName;
  final String shopAddress;
  final String vendorPhone;
  final String vendorEmail;
  final List<Items> vendorItems;

  VendorOrderGroup({
    required this.order,
    required this.vendorId,
    required this.vendorName,
    required this.shopName,
    required this.shopAddress,
    required this.vendorPhone,
    required this.vendorEmail,
    required this.vendorItems,
  });

  String get vendorStatus {
    if (vendorItems.isEmpty) return 'pending';
    
    final statuses = vendorItems.map((i) => (i.status ?? 'pending').toLowerCase()).toSet();
    
    if (statuses.length == 1) return statuses.first;
    
    // Priority: If any are pending/accepted, overall is not yet packed.
    if (statuses.contains('pending')) return 'pending';
    if (statuses.contains('accepted')) return 'accepted';
    if (statuses.contains('processing')) return 'processing';
    if (statuses.contains('packed')) return 'packed';
    
    return statuses.first;
  }
}
