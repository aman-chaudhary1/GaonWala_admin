import '../../../core/data/data_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/constants.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  int touchedIndex = -1;

  final Map<int, String> statusMapping = {
    0: 'pending',
    1: 'cancelled',
    2: 'shipped',
    3: 'delivered',
    4: 'processing',
  };

  @override
  Widget build(BuildContext context) {
    final orderStats = context.watch<DataProvider>().calculateOrdersWithStatus();
    int totalOrder = orderStats['all'] ?? 0;

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 70,
                  startDegreeOffset: -90,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      if (!event.isInterestedForInteractions || response == null || response.touchedSection == null) {
                        setState(() => touchedIndex = -1);
                        return;
                      }

                      final index = response.touchedSection!.touchedSectionIndex;
                      setState(() => touchedIndex = index);

                      final selectedStatus = statusMapping[index];

                      if (selectedStatus != null) {
                        context.read<DataProvider>().filterOrders(selectedStatus);
                      }
                    },
                  ),
                  sections: _buildPieChartSections(orderStats),
                ),
              ),

              /// Center Count
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$totalOrder',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                    ),
                    SizedBox(height: defaultPadding / 2),
                    Text(
                      "Orders",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: defaultPadding),

        /// Legend
        Wrap(
          spacing: 10,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            _legend(Color(0xFFFFCF26), 'Pending', orderStats['pending'] ?? 0),
            _legend(Color(0xFFEE2727), 'Cancelled', orderStats['cancelled'] ?? 0),
            _legend(Color(0xFF2697FF), 'Shipped', orderStats['shipped'] ?? 0),
            _legend(Color(0xFF26FF31), 'Delivered', orderStats['delivered'] ?? 0),
            _legend(Colors.white, 'Processing', orderStats['processing'] ?? 0),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieChartSections(Map<String, int> stats) {
    final values = [
      stats['pending'] ?? 0,
      stats['cancelled'] ?? 0,
      stats['shipped'] ?? 0,
      stats['delivered'] ?? 0,
      stats['processing'] ?? 0,
    ];

    final colors = [
      Color(0xFFFFCF26),
      Color(0xFFEE2727),
      Color(0xFF2697FF),
      Color(0xFF26FF31),
      Colors.white,
    ];

    return List.generate(values.length, (i) {
      final isTouched = i == touchedIndex;
      final double radius = isTouched ? 28 : 20;

      return PieChartSectionData(
        color: colors[i],
        value: values[i].toDouble(),
        radius: radius,
        showTitle: false,
      );
    });
  }

  Widget _legend(Color color, String title, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 6),
        Text("$title ($count)", style: TextStyle(color: Colors.white70)),
      ],
    );
  }
}






// import '../../../core/data/data_provider.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../utility/constants.dart';
//
// class Chart extends StatelessWidget {
//   const Chart({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       child: Stack(
//         children: [
//           PieChart(
//             PieChartData(
//               sectionsSpace: 0,
//               centerSpaceRadius: 70,
//               startDegreeOffset: -90,
//               sections: _buildPieChartSelectionData(context),
//             ),
//           ),
//           Positioned.fill(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(height: defaultPadding),
//                 Consumer<DataProvider>(
//                   builder: (context, dataProvider, child) {
//                     return Text(
//                       '${0}', //TODO: should complete Make this order number dynamic bt calling calculateOrdersWithStatus
//                       style: Theme.of(context).textTheme.headlineMedium!.copyWith(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         height: 0.5,
//                       ),
//                     );
//                   },
//                 ),
//                 SizedBox(height: defaultPadding),
//                 Text("Order")
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<PieChartSectionData> _buildPieChartSelectionData(BuildContext context) {
//     final DataProvider dataProvider = Provider.of<DataProvider>(context);
//
//     //TODO: should complete Make this order number dynamic bt calling calculateOrdersWithStatus
//     int totalOrder = 0;
//     int pendingOrder = 0;
//     int processingOrder = 0;
//     int cancelledOrder = 0;
//     int shippedOrder = 0;
//     int deliveredOrder = 0;
//
//     List<PieChartSectionData> pieChartSelectionData = [
//       PieChartSectionData(
//         color: Color(0xFFFFCF26),
//         value: pendingOrder.toDouble(),
//         showTitle: false,
//         radius: 20,
//       ),
//       PieChartSectionData(
//         color: Color(0xFFEE2727),
//         value: cancelledOrder.toDouble(),
//         showTitle: false,
//         radius: 20,
//       ),
//       PieChartSectionData(
//         color: Color(0xFF2697FF),
//         value: shippedOrder.toDouble(),
//         showTitle: false,
//         radius: 20,
//       ),
//       PieChartSectionData(
//         color: Color(0xFF26FF31),
//         value: deliveredOrder.toDouble(),
//         showTitle: false,
//         radius: 20,
//       ),
//       PieChartSectionData(
//         color: Colors.white,
//         value: processingOrder.toDouble(),
//         showTitle: false,
//         radius: 20,
//       ),
//     ];
//
//     return pieChartSelectionData;
//   }
// }
//
