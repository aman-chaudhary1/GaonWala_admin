import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../models/app_config.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class AppControlProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  final HttpService service = HttpService();

  AppConfig? appConfig;
  bool isLoading = false;

  final TextEditingController welcomeMsgCtrl = TextEditingController();
  final TextEditingController orderBlockedMsgCtrl = TextEditingController();
  
  bool isOrderingEnabled = true;
  bool showWelcomePopup = true;
  bool reviewEnabled = true;

  AppControlProvider(this._dataProvider) {
    fetchAppConfig();
  }

  Future<void> fetchAppConfig() async {
    isLoading = true;
    notifyListeners();
    try {
      Response response = await service.getItems(endpointUrl: 'app-config');
      if (response.isOk) {
        ApiResponse<AppConfig> apiResponse = ApiResponse<AppConfig>.fromJson(
          response.body,
          (json) => AppConfig.fromJson(json as Map<String, dynamic>),
        );
        if (apiResponse.success && apiResponse.data != null) {
          appConfig = apiResponse.data;
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
    if (appConfig != null) {
      welcomeMsgCtrl.text = appConfig?.welcomeMessage ?? '';
      orderBlockedMsgCtrl.text = appConfig?.orderBlockedMessage ?? '';
      isOrderingEnabled = appConfig?.isOrderingEnabled ?? true;
      showWelcomePopup = appConfig?.showWelcomePopup ?? true;
      reviewEnabled = appConfig?.reviewEnabled ?? true;
    }
  }

  void toggleOrdering(bool value) {
    isOrderingEnabled = value;
    notifyListeners();
  }

  void toggleWelcomePopup(bool value) {
    showWelcomePopup = value;
    notifyListeners();
  }

  void toggleReview(bool value) {
    reviewEnabled = value;
    notifyListeners();
  }

  Future<void> updateAppConfig() async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> body = {
        "isOrderingEnabled": isOrderingEnabled,
        "welcomeMessage": welcomeMsgCtrl.text,
        "orderBlockedMessage": orderBlockedMsgCtrl.text,
        "showWelcomePopup": showWelcomePopup,
        "reviewEnabled": reviewEnabled
      };

      Response response = await service.addItem(endpointUrl: 'app-config/update', itemData: body);
      if (response.isOk) {
        ApiResponse<AppConfig> apiResponse = ApiResponse<AppConfig>.fromJson(
          response.body,
          (json) => AppConfig.fromJson(json as Map<String, dynamic>),
        );
        if (apiResponse.success) {
          appConfig = apiResponse.data;
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
