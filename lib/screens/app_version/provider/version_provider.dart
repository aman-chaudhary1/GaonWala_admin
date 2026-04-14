import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../models/app_version.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class VersionProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  final HttpService service = HttpService();

  AppVersion? versionInfo;
  bool isLoading = false;

  final TextEditingController latestVersionCtrl = TextEditingController();
  final TextEditingController minVersionCtrl = TextEditingController();
  final TextEditingController messageCtrl = TextEditingController();
  bool forceUpdate = false;

  VersionProvider(this._dataProvider) {
    fetchVersionInfo();
  }

  Future<void> fetchVersionInfo() async {
    isLoading = true;
    notifyListeners();
    try {
      Response response = await service.getItems(endpointUrl: 'app-version');
      if (response.isOk) {
        ApiResponse<AppVersion> apiResponse = ApiResponse<AppVersion>.fromJson(
          response.body,
          (json) => AppVersion.fromJson(json as Map<String, dynamic>),
        );
        if (apiResponse.success && apiResponse.data != null) {
          versionInfo = apiResponse.data;
          _setData();
        }
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _setData() {
    if (versionInfo != null) {
      latestVersionCtrl.text = versionInfo?.latestVersion ?? '';
      minVersionCtrl.text = versionInfo?.minRequiredVersion ?? '';
      messageCtrl.text = versionInfo?.message ?? '';
      forceUpdate = versionInfo?.forceUpdate ?? false;
    }
  }

  void updateForceUpdate(bool value) {
    forceUpdate = value;
    notifyListeners();
  }

  Future<void> updateVersionInfo() async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> body = {
        "latest_version": latestVersionCtrl.text,
        "min_required_version": minVersionCtrl.text,
        "force_update": forceUpdate,
        "message": messageCtrl.text
      };

      Response response = await service.addItem(endpointUrl: 'app-version/update', itemData: body);
      if (response.isOk) {
        ApiResponse<AppVersion> apiResponse = ApiResponse<AppVersion>.fromJson(
          response.body,
          (json) => AppVersion.fromJson(json as Map<String, dynamic>),
        );
        if (apiResponse.success) {
          versionInfo = apiResponse.data;
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        }
      } else {
        SnackBarHelper.showErrorSnackBar(response.statusText ?? 'Update failed');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
