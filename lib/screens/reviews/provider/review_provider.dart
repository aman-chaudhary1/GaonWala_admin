import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../models/review.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class AdminReviewProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  final HttpService service = HttpService();

  List<Review> reviews = [];
  bool isLoading = false;

  AdminReviewProvider(this._dataProvider) {
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    isLoading = true;
    notifyListeners();
    try {
      Response response = await service.getItems(endpointUrl: 'reviews');
      if (response.isOk) {
        ApiResponse<List<Review>> apiResponse = ApiResponse<List<Review>>.fromJson(
          response.body,
          (json) => (json as List).map((e) => Review.fromJson(e)).toList(),
        );
        if (apiResponse.success && apiResponse.data != null) {
          reviews = apiResponse.data!;
        }
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
