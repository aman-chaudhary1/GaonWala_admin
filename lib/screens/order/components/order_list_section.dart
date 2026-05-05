import '../../../core/data/data_provider.dart';
import '../provider/order_provider.dart';
import 'view_order_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/color_list.dart';
import '../../../models/order.dart';
import '../../../utility/constants.dart';
import 'package:intl/intl.dart';


class OrderListSection extends StatelessWidget {
  const OrderListSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Order",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                final orders = orderProvider.filteredOrders;
                return ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 1000),
                  child: DataTable(
                    columnSpacing: defaultPadding,
                    // minWidth: 600,
                    columns: [
                      DataColumn(
                        label: Checkbox(
                          value: orderProvider.selectedOrderIds.length == orders.length && orders.isNotEmpty,
                          onChanged: (val) {
                            orderProvider.selectAll(dataProvider.orders);
                          },
                        ),
                      ),
                      DataColumn(
                        label: Text("Customer Name"),
                      ),
                      DataColumn(
                        label: Text("Order Amount"),
                      ),
                      DataColumn(
                        label: Text("Payment"),
                      ),
                      DataColumn(
                        label: Text("Status"),
                      ),
                      DataColumn(
                        label: Text("Date"),
                      ),
                      DataColumn(
                        label: Text("Edit"),
                      ),
                      DataColumn(
                        label: Text("Delete"),
                      ),
                    ],
                    rows: List.generate(
                      orders.length,
                      (index) {
                        final order = orders[index];
                        return orderDataRow(
                          order,
                          index + 1,
                          isSelected: orderProvider.isSelected(order.sId ?? ''),
                          onSelect: (val) {
                            orderProvider.toggleSelection(order.sId ?? '');
                          },
                          delete: () {
                            context.read<OrderProvider>().deleteOrder(order.sId!);
                          },
                          edit: () {
                            showOrderForm(context, order);
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

DataRow orderDataRow(Order orderInfo, int index,
    {required bool isSelected, required Function(bool?) onSelect, Function? edit, Function? delete}) {
  return DataRow(
    selected: isSelected,
    onSelectChanged: onSelect,
    cells: [
      DataCell(
        Checkbox(
          value: isSelected,
          onChanged: onSelect,
        ),
      ),
      DataCell(
        Row(
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
              child: Text(index.toString(), textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(orderInfo.userID?.name ?? ''),
            ),
          ],
        ),
      ),
      DataCell(Text('Rs ${orderInfo.orderTotal?.total}')),
      DataCell(Text(orderInfo.paymentMethod ?? '')),
      DataCell(Text(orderInfo.orderStatus ?? '')),
      DataCell(Text(orderInfo.orderDate != null
          ? DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(orderInfo.orderDate!).toLocal())
          : '')),
      DataCell(IconButton(
          onPressed: () {
            if (edit != null) edit();
          },
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ))),
      DataCell(IconButton(
          onPressed: () {
            if (delete != null) delete();
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ))),
    ],
  );
}
