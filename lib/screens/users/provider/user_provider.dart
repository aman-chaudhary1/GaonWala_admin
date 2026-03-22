import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../models/user.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class UserProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  UserProvider(this._dataProvider);

  // Update user status (active/inactive)
  Future<void> updateUserStatus(User user) async {
    try {
      String newStatus = user.userStatus == 'inactive' ? 'active' : 'inactive';
      Map<String, dynamic> data = {'userStatus': newStatus};

      final response = await service.updateItem(
          endpointUrl: 'users', itemId: user.sId ?? '', itemData: data);

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllUsers();
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to update status: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error: ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(User user) async {
    try {
      final response = await service.deleteItem(
          endpointUrl: 'users', itemId: user.sId ?? '');

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('User Deleted Successfully');
          _dataProvider.getAllUsers();
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to delete user: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error: ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
    }
  }
}
