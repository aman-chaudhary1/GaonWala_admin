import '../../../models/my_notification.dart';
import '../provider/notification_provider.dart';
import '../../../utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'notification_statics_card.dart';

class ViewNotificationForm extends StatelessWidget {
  final MyNotification? notification;

  const ViewNotificationForm({Key? key, this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //TODO: should complete getNotificationInfo
    context.read<NotificationProvider>().getNotificationInfo(notification);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        width: size.width * 0.5,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (notification?.imageUrl != null && notification!.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  notification!.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 50),
                ),
              ),
            Gap(20),
            Text(
              "Title",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              notification?.title ?? 'N/A',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Gap(15),
            Text(
              "Description",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              notification?.description ?? 'N/A',
              style: TextStyle(fontSize: 14),
            ),
            Gap(20),
            Divider(color: Colors.grey.withOpacity(0.2)),
            Gap(10),
            _buildDetailRow("Sent To:", notification?.userId != null ? (notification?.userId!['name'] ?? 'Unknown') : "All Users"),
            _buildDetailRow("Sent Date:", notification?.createdAt?.split('T').first ?? 'N/A'),
            _buildStatusRow(notification),
            Gap(30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildStatusRow(MyNotification? notification) {
    String status = "Sent";
    Color statusColor = Colors.orange;

    if (notification?.userId != null) {
      final String targetUserId = notification?.userId!['_id'] ?? '';
      final bool isRead = notification?.readBy?.contains(targetUserId) ?? false;
      status = isRead ? "Read by user" : "Unread by user";
      statusColor = isRead ? Colors.green : Colors.orange;
    } else {
      int count = notification?.readBy?.length ?? 0;
      status = "$count users read this";
      statusColor = Colors.blue;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Status:", style: TextStyle(color: Colors.grey)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.5)),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// How to show the order popup
void viewNotificationStatics(
    BuildContext context, MyNotification? notification) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
            child: Text('Notification Statics'.toUpperCase(),
                style: TextStyle(color: primaryColor))),
        content: ViewNotificationForm(notification: notification),
      );
    },
  );
}
