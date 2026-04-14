import 'dart:html' as html;

class NotificationHelper {
  static Future<void> requestPermission() async {
    if (html.Notification.permission == 'default') {
      await html.Notification.requestPermission();
    }
  }

  static void showNotification(String title, String body) {
    if (html.Notification.permission == 'granted') {
      html.Notification(title, body: body);
    } else {
      print("Notification permission not granted");
    }
  }
}
