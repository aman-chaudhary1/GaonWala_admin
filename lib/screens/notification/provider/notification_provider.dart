import 'dart:developer';
import 'package:sazedar_admin/models/api_response.dart';
import 'package:sazedar_admin/models/my_notification.dart';
import 'package:sazedar_admin/utility/snack_bar_helper.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../../../models/notification_result.dart';
import '../../../models/user.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';
import '../../../services/http_services.dart';

class NotificationProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final sendNotificationFormKey = GlobalKey<FormState>();

  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController imageUrlCtrl = TextEditingController();

  User? selectedUser;
  
  NotificationResult? notificationResult;

  NotificationProvider(this._dataProvider);

  //TODO: should complete sendNotification
  sendNotification() async {
    try {
      Map<String, dynamic> notification = {
        "title": titleCtrl.text,
        "description": descriptionCtrl.text,
        "imageUrl": imageUrlCtrl.text,
        if (selectedUser != null) "userId": selectedUser?.sId,
      };
      final response = await service.addItem(
          endpointUrl: 'notification/send-notification',
          itemData: notification);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          log('Notification send');
          _dataProvider.getAllNotifications();
        } else {
          SnackBarHelper.showErrorSnackBar('${apiResponse.message}');
          log('Failed to send notification: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message']} ?? response.statusText');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Exception: $e');
      rethrow;
    }
  }

  //TODO: should complete deleteNotification
  deleteNotification(MyNotification notification) async {
    try {
      Response response = await service.deleteItem(
          endpointUrl: 'notification/delete-notification',
          itemId: notification.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          log('Notification deleted');
          _dataProvider.getAllNotifications();
        } else {
          SnackBarHelper.showErrorSnackBar('${apiResponse.message}');
          log('Failed to delete notification: ${apiResponse.message}');
        }
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  getNotificationInfo(MyNotification? notification) {
    // We no longer need to call track-notification API because 
    // read status is now tracked directly in the Notification model's readBy field.
    // This also avoids issues with FCM IDs containing special characters.
    notificationResult = null; 
    notifyListeners();
  }

  clearFields() {
    titleCtrl.clear();
    descriptionCtrl.clear();
    imageUrlCtrl.clear();
    selectedUser = null;
    notifyListeners();
  }

  updateUI() {
    notifyListeners();
  }
}
