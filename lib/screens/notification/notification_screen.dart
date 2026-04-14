import 'package:sazedar_admin/utility/extensions.dart';

import 'components/notification_header.dart';
import 'components/notification_list_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import 'components/send_notification_form.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            NotificationHeader(),
            Gap(defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isSmall = constraints.maxWidth < 600;
                          return Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              SizedBox(
                                width: isSmall ? constraints.maxWidth : 200,
                                child: Text(
                                  "My Notifications",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              ElevatedButton.icon(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: defaultPadding * 1.5,
                                    vertical: defaultPadding,
                                  ),
                                ),
                                onPressed: () {
                                  sendNotificationFormForm(context);
                                },
                                icon: Icon(Icons.add),
                                label: Text("Send New"),
                              ),
                              IconButton(
                                  onPressed: () {
                                    context.dataProvider
                                        .getAllNotifications(showSnack: true);
                                  },
                                  icon: Icon(Icons.refresh)),
                            ],
                          );
                        },
                      ),
                      Gap(defaultPadding),
                      NotificationListSection(),
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
}
