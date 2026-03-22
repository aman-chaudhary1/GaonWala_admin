import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utility/constants.dart';
import 'components/analytic_info_card.dart';
import 'components/order_chart.dart';
import 'components/revenue_chart.dart';
import 'provider/analytics_provider.dart';

class StatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Consumer<AnalyticsProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Business Status",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                SizedBox(height: defaultPadding),
                GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: defaultPadding,
                  mainAxisSpacing: defaultPadding,
                  shrinkWrap: true,
                  childAspectRatio: 1.4,
                  children: [
                    AnalyticInfoCard(
                      title: "Total Orders",
                      count: provider.totalOrders.toString(),
                      svgSrc: "",
                      color: primaryColor,
                    ),
                    AnalyticInfoCard(
                      title: "Pending Orders",
                      count: provider.pendingOrders.toString(),
                      svgSrc: "",
                      color: Colors.orange,
                    ),
                    AnalyticInfoCard(
                      title: "Total Revenue",
                      count: "Rs ${provider.totalRevenue.toStringAsFixed(0)}",
                      svgSrc: "",
                      color: Colors.green,
                    ),
                    AnalyticInfoCard(
                      title: "Cancelled Value",
                      count: "Rs ${provider.totalCancelledValue.toStringAsFixed(0)}",
                      svgSrc: "",
                      color: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          OrderChart(),
                          SizedBox(height: defaultPadding),
                          RevenueChart(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
