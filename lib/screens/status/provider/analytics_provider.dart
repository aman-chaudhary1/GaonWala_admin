import 'package:flutter/material.dart';
import '../../../models/order.dart';
import '../../../core/data/data_provider.dart';
import 'package:intl/intl.dart';

class AnalyticsProvider extends ChangeNotifier {
  final DataProvider _dataProvider;

  AnalyticsProvider(this._dataProvider);

  // Get total orders count
  int get totalOrders => _dataProvider.orders.length;

  // Get pending orders count
  int get pendingOrders => _dataProvider.orders.where((o) => o.orderStatus == 'pending').length;

  // Get total revenue (delivered orders)
  double get totalRevenue => _dataProvider.orders
      .where((o) => o.orderStatus == 'delivered')
      .fold(0, (sum, o) => sum + (o.totalPrice ?? 0));

  // Get total cancelled value
  double get totalCancelledValue => _dataProvider.orders
      .where((o) => o.orderStatus == 'cancelled')
      .fold(0, (sum, o) => sum + (o.totalPrice ?? 0));

  // Data for Line Chart (Daily Orders)
  Map<DateTime, int> get dailyOrders {
    Map<DateTime, int> data = {};
    for (var order in _dataProvider.orders) {
      if (order.orderDate != null) {
        DateTime date = DateTime.parse(order.orderDate!).copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
        data[date] = (data[date] ?? 0) + 1;
      }
    }
    return data;
  }

  // Data for Bar Chart (Revenue vs Cancelled)
  List<Map<String, dynamic>> get revenueStats {
    return [
      {'label': 'Delivered', 'value': totalRevenue},
      {'label': 'Cancelled', 'value': totalCancelledValue},
    ];
  }
}
