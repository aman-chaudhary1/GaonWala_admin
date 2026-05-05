import 'dart:convert';
import 'dart:html' as html; // Only for web support as requested
import 'package:csv/csv.dart';
import '../models/order.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class OrderCsvService {
  static void exportOrdersToCsv(List<Order> orders) {
    List<List<dynamic>> rows = [];

    // Add Header
    rows.add([
      "Order ID",
      "Customer Name",
      "Customer Phone",
      "Address",
      "Village",
      "Panchayat",
      "Block",
      "Landmark",
      "Total Amount",
      "Payment Method",
      "Order Status",
      "Order Date",
      "Items Count",
    ]);

    for (var order in orders) {
      rows.add([
        order.sId ?? '',
        order.userID?.name ?? '',
        order.shippingAddress?.phone ?? '',
        '${order.shippingAddress?.village ?? ''}, ${order.shippingAddress?.panchayat ?? ''}',
        order.shippingAddress?.village ?? '',
        order.shippingAddress?.panchayat ?? '',
        order.shippingAddress?.block ?? '',
        order.shippingAddress?.landmark ?? '',
        order.orderTotal?.total ?? 0,
        order.paymentMethod ?? '',
        order.orderStatus ?? '',
        order.orderDate ?? '',
        order.items?.length ?? 0,
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    
    if (kIsWeb) {
      final bytes = utf8.encode(csvData);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'Gravito_Orders_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv';
      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } else {
      // In mobile/desktop you would save to file, but user requested Flutter Web compatibility primarily.
      print("CSV Export not implemented for mobile/desktop in this demo, but logic is ready.");
    }
  }
}
