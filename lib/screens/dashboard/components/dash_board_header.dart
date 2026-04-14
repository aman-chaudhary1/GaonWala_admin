import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';
import '../../../utility/responsive.dart';
import '../../../utility/constants.dart';
import '../../../widgets/profile_card.dart';
import '../../../utility/notification_helper.dart';
import 'package:gap/gap.dart';

class DashBoardHeader extends StatelessWidget {
  const DashBoardHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isMobile(context))
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: 1),
        Expanded(
            child: SearchField(
          onChange: (val) {
            //TODO: should complete call filterProducts
          },
        )),
        Gap(defaultPadding),
        Consumer<DataProvider>(
          builder: (context, dataProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        NotificationHelper.requestPermission();
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/notification.svg",
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          dataProvider.notificationStatus.startsWith("Error")
                              ? Colors.red
                              : Colors.white54,
                          BlendMode.srcIn,
                        ),
                      ),
                      tooltip: "Enable Order Notifications",
                    ),
                    if (!Responsive.isMobile(context))
                      Text(
                        dataProvider.notificationStatus,
                        style: TextStyle(
                          fontSize: 10,
                          color: dataProvider.notificationStatus.startsWith("Error")
                              ? Colors.red
                              : Colors.white54,
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
        Gap(defaultPadding / 2),
        ProfileCard(userName: "Aman Chaudhary")
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  final Function(String) onChange;

  const SearchField({
    Key? key,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
      onChanged: (value) {
        onChange(value);
      },
    );
  }
}
