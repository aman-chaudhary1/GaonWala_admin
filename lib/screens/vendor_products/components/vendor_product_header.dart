import 'package:flutter/material.dart';
import '../../../../utility/responsive.dart';
import '../../../../utility/constants.dart';

class VendorProductHeader extends StatelessWidget {
  const VendorProductHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isMobile(context))
          Text(
            "Vendor Product Approval",
            style: Theme.of(context).textTheme.titleLarge,
          ),
      ],
    );
  }
}
