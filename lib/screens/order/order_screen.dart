import 'package:sazedar_admin/screens/order/provider/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:sazedar_admin/screens/shopkeepers/provider/shopkeeper_provider.dart';
import 'package:sazedar_admin/services/order_pdf_service.dart';
import 'package:sazedar_admin/services/order_csv_service.dart';

import 'components/order_header.dart';
import 'components/order_list_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import '../../widgets/custom_dropdown.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrders();
      context.read<ShopkeeperProvider>().getAllShopkeepers();
    });
    
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            OrderHeader(),
            SizedBox(height: defaultPadding),
            _buildAdvancedFilterPanel(context),
            SizedBox(height: defaultPadding),
            OrderListSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFilterPanel(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter & Export",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                children: [
                  Consumer<OrderProvider>(
                    builder: (context, provider, _) => provider.selectedOrderIds.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              ),
                              onPressed: () => _showBulkUpdateDialog(context, provider),
                              icon: Icon(Icons.edit_notifications, color: Colors.white),
                              label: Text("Bulk Update (${provider.selectedOrderIds.length})",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    onPressed: () => _exportToPdf(context),
                    icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                    label: Text("Download PDF", style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      side: BorderSide(color: Colors.green),
                    ),
                    onPressed: () => _exportToCsv(context),
                    icon: Icon(Icons.table_view, color: Colors.green),
                    label: Text("Export CSV", style: TextStyle(color: Colors.green)),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      context.read<OrderProvider>().loadOrders();
                    },
                    icon: Icon(Icons.refresh, color: Colors.white),
                    tooltip: "Refresh Orders",
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: defaultPadding),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  // Status Filter
                  SizedBox(
                    width: 180,
                    child: Consumer<OrderProvider>(
                      builder: (context, provider, _) => CustomDropdown(
                        hintText: 'Order Status',
                        initialValue: provider.currentStatus,
                        items: ['All order', 'pending', 'processing', 'shipped', 'delivered', 'cancelled'],
                        displayItem: (val) => val,
                        onChanged: (val) => provider.filterOrders(val!),
                      ),
                    ),
                  ),
                  // Shopkeeper Filter
                  SizedBox(
                    width: 180,
                    child: Consumer2<OrderProvider, ShopkeeperProvider>(
                      builder: (context, orderProvider, shopProvider, _) => CustomDropdown(
                        hintText: 'By Shopkeeper',
                        items: [null, ...shopProvider.shopkeepers.map((s) => s.sId)],
                        displayItem: (id) {
                          if (id == null) return "All Shops";
                          final shop = shopProvider.shopkeepers.firstWhere((s) => s.sId == id);
                          return shop.name ?? "Unknown";
                        },
                        onChanged: (val) => orderProvider.updateShopkeeperFilter(val),
                      ),
                    ),
                  ),
                  // Payment Type Filter
                  SizedBox(
                    width: 180,
                    child: Consumer<OrderProvider>(
                      builder: (context, provider, _) => CustomDropdown(
                        hintText: 'Payment Type',
                        items: [null, 'cod', 'online'],
                        displayItem: (val) => val == null ? "All Payments" : val.toUpperCase(),
                        onChanged: (val) => provider.updatePaymentTypeFilter(val),
                      ),
                    ),
                  ),
                  // Order ID Search
                  SizedBox(
                    width: 200,
                    child: TextField(
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Order ID (e.g. 123456)",
                        hintStyle: TextStyle(color: Colors.white54),
                        prefixIcon: Icon(Icons.search, color: Colors.white54),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      ),
                      onChanged: (val) => context.read<OrderProvider>().updateOrderIdFilter(val),
                    ),
                  ),
                  // Date Range Picker
                  Consumer<OrderProvider>(
                    builder: (context, provider, _) => TextButton.icon(
                      onPressed: () async {
                        DateTimeRange? picked = await showDateRangePicker(
                          context: context,
                          initialDateRange: provider.filterDateRange ?? DateTimeRange(
                            start: DateTime.now().subtract(Duration(days: 7)),
                            end: DateTime.now(),
                          ),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          provider.updateDateRange(picked);
                        }
                      },
                      icon: Icon(Icons.date_range),
                      label: Text(provider.filterDateRange == null 
                        ? "Select Date Range" 
                        : "${DateFormat('dd/MM').format(provider.filterDateRange!.start)} - ${DateFormat('dd/MM').format(provider.filterDateRange!.end)}"),
                    ),
                  ),
                  if (context.watch<OrderProvider>().filterDateRange != null)
                    IconButton(
                      onPressed: () => context.read<OrderProvider>().updateDateRange(null),
                      icon: Icon(Icons.clear, color: Colors.red),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _exportToPdf(BuildContext context) async {
    final orderProvider = context.read<OrderProvider>();
    final selectedOrders = orderProvider.filteredOrders
        .where((o) => orderProvider.selectedOrderIds.contains(o.sId))
        .toList();

    if (selectedOrders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one order to export")),
      );
      return;
    }

    await OrderPdfService.generateBulkOrderPdf(
      orders: selectedOrders,
      adminName: "Gravito Admin",
    );
  }

  void _exportToCsv(BuildContext context) {
    final orderProvider = context.read<OrderProvider>();
    final selectedOrders = orderProvider.filteredOrders
        .where((o) => orderProvider.selectedOrderIds.contains(o.sId))
        .toList();

    if (selectedOrders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one order to export")),
      );
      return;
    }

    OrderCsvService.exportOrdersToCsv(selectedOrders);
  }


  void _showBulkUpdateDialog(BuildContext context, OrderProvider provider) {
    String? newStatus;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Bulk Update Status"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Update ${provider.selectedOrderIds.length} orders to:"),
            Gap(20),
            CustomDropdown(
              hintText: 'Select New Status',
              items: ['pending', 'processing', 'shipped', 'delivered', 'cancelled'],
              displayItem: (val) => val,
              onChanged: (val) => newStatus = val,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newStatus != null) {
                bool success = await provider.updateBulkOrderStatus(newStatus!);
                Navigator.pop(context);
                _showStatusDialog(context, success);
              }
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(BuildContext context, bool success) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(success ? "Success" : "Error"),
        content: Text(success ? "Orders updated successfully!" : "Failed to update orders."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
