import 'package:sazedar_admin/screens/order/provider/order_provider.dart';
import 'package:provider/provider.dart';

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
    context.read<OrderProvider>().loadOrders();
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            OrderHeader(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              "My Orders",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Gap(20),
                          Consumer<OrderProvider>(
                            builder: (context, orderProvider, child) {
                              return orderProvider.selectedOrderIds.isNotEmpty
                                  ? ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                      onPressed: () => _showBulkUpdateDialog(context, orderProvider),
                                      icon: Icon(Icons.edit, color: Colors.white),
                                      label: Text(
                                          "Bulk Update (${orderProvider.selectedOrderIds.length})",
                                          style: TextStyle(color: Colors.white)),
                                    )
                                  : SizedBox.shrink();
                            },
                          ),
                          Gap(20),
                          Consumer<OrderProvider>(
                            builder: (context, orderProvider, child) {
                              return Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: orderProvider.selectedDate ?? DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        orderProvider.updateSelectedDate(pickedDate);
                                      }
                                    },
                                    icon: Icon(Icons.calendar_month),
                                    label: Text(orderProvider.selectedDate == null
                                        ? "Select Date"
                                        : DateFormat('dd-MM-yyyy').format(orderProvider.selectedDate!)),
                                  ),
                                  if (orderProvider.selectedDate != null)
                                    IconButton(
                                      onPressed: () => orderProvider.updateSelectedDate(null),
                                      icon: Icon(Icons.clear, color: Colors.red),
                                    ),
                                ],
                              );
                            },
                          ),
                          Gap(20),
                          SizedBox(
                            width: 280,
                            child: CustomDropdown(
                              hintText: 'Filter Order By status',
                              initialValue: 'All order',
                              items: ['All order', 'pending', 'processing', 'shipped', 'delivered', 'cancelled'],
                              displayItem: (val) => val,
                              onChanged: (newValue) {
                                if (newValue?.toLowerCase() == 'all order') {
                                  //TODO: should complete call filterOrders
                                  context.read<OrderProvider>().loadOrders();
                                } else {
                                  //TODO: should complete call filterOrders
                                  context.read<OrderProvider>().filterOrders(newValue!);
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select status';
                                }
                                return null;
                              },
                            ),
                          ),
                          Gap(40),
                          IconButton(
                              onPressed: () {
                                //TODO: should complete call getAllOrders
                                context.read<OrderProvider>().loadOrders();
                              },
                              icon: Icon(Icons.refresh)),
                        ],
                      ),
                      Gap(defaultPadding),
                      OrderListSection(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
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
