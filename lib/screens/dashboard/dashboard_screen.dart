import 'package:provider/provider.dart';

import '../../core/data/data_provider.dart';
import 'components/dash_board_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import 'components/add_product_form.dart';
import 'components/order_details_section.dart';
import 'components/product_list_section.dart';
import 'components/product_summery_section.dart';


class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();

    // Call API only once when screen loads
    Future.microtask(() {
      context.read<DataProvider>().getAllOrders(showSnack: false);
      context.read<DataProvider>().getAllProduct(showSnack: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            DashBoardHeader(),
            Gap(defaultPadding),
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 1200;
                final screenWidth = MediaQuery.of(context).size.width;
                final isSmallHeader = screenWidth < 800;
                
                Widget buildHeaderRow() {
                  return Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: isSmallHeader ? constraints.maxWidth : 200,
                        child: Text(
                          "My Products",
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isSmallHeader)
                        ElevatedButton.icon(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  defaultPadding * (isSmallHeader ? 1.0 : 1.5),
                              vertical: defaultPadding,
                            ),
                          ),
                          onPressed: () {
                            showAddProductForm(context, null);
                          },
                          icon: Icon(Icons.add),
                          label: Text("Adds New"),
                        )
                      else
                        IconButton(
                          onPressed: () {
                            showAddProductForm(context, null);
                          },
                          icon: Icon(Icons.add),
                          tooltip: "Add New",
                        ),
                      IconButton(
                        onPressed: () {
                          context
                              .read<DataProvider>()
                              .getAllProduct(showSnack: true);
                        },
                        icon: Icon(Icons.refresh),
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(8),
                      ),
                    ],
                  );
                }
                
                if (isNarrow) {
                  // Stack vertically on narrow screens
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          buildHeaderRow(),
                          Gap(defaultPadding),
                          ProductSummerySection(),
                          Gap(defaultPadding),
                          ProductListSection(),
                        ],
                      ),
                      Gap(defaultPadding),
                      OrderDetailsSection(),
                    ],
                  );
                }
                
                // Original horizontal layout for wide screens
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          buildHeaderRow(),
                          Gap(defaultPadding),
                          ProductSummerySection(),
                          Gap(defaultPadding),
                          ProductListSection(),
                        ],
                      ),
                    ),
                    SizedBox(width: defaultPadding),
                    Expanded(
                      flex: 2,
                      child: OrderDetailsSection(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// class DashboardScreen extends StatelessWidget {
//   late final DataProvider _dataProvider;
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         primary: false,
//         padding: EdgeInsets.all(defaultPadding),
//         child: Column(
//           children: [
//             DashBoardHeader(),
//             Gap(defaultPadding),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 5,
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               "My Products",
//                               style: Theme.of(context).textTheme.titleMedium,
//                             ),
//                           ),
//                           ElevatedButton.icon(
//                             style: TextButton.styleFrom(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: defaultPadding * 1.5,
//                                 vertical: defaultPadding,
//                               ),
//                             ),
//                             onPressed: () {
//                               showAddProductForm(context, null);
//                             },
//                             icon: Icon(Icons.add),
//                             label: Text("Adds New"),
//                           ),
//                           Gap(20),
//                           IconButton(
//                               onPressed: () {
//                                 //TODO: should complete call getAllProduct
//                                 _dataProvider.getAllProduct(showSnack: true);
//
//                               },
//                               icon: Icon(Icons.refresh)),
//                         ],
//                       ),
//                       Gap(defaultPadding),
//                       ProductSummerySection(),
//                       Gap(defaultPadding),
//                       ProductListSection(),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: defaultPadding),
//                 Expanded(
//                   flex: 2,
//                   child: OrderDetailsSection(),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
