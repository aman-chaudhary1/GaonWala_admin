import 'dart:developer';

import '../../../models/api_response.dart';
import '../../../models/coupon.dart';
import '../../../models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../models/sub_category.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class CouponCodeProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  Coupon? couponForUpdate;

  final addCouponFormKey = GlobalKey<FormState>();
  TextEditingController couponCodeCtrl = TextEditingController();
  TextEditingController discountAmountCtrl = TextEditingController();
  TextEditingController minimumPurchaseAmountCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  String selectedDiscountType = 'fixed';
  String selectedCouponStatus = 'active';
  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  Product? selectedProduct;

  CouponCodeProvider(this._dataProvider);

  // Add a new coupon
  addCoupon() async {

    try {
if(endDateCtrl.text.isEmpty){
    SnackBarHelper.showErrorSnackBar('End date cannot be empty');
    return;
  }
        Map<String, dynamic> coupon = {
        'couponCode': couponCodeCtrl.text,
        'discountType': selectedDiscountType,
        'discountAmount': double.tryParse(discountAmountCtrl.text) ?? 0.0,
        'minimumPurchaseAmount': double.tryParse(minimumPurchaseAmountCtrl.text) ?? 0.0,
        'endDate': endDateCtrl.text,
        'status': selectedCouponStatus,
        'applicableCategory': selectedCategory?.sId,
        'applicableSubCategory': selectedSubCategory?.sId,
        'applicableProduct': selectedProduct?.sId,
      };
      final response = await service.addItem(endpointUrl: 'couponCodes',itemData: coupon);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true){
          clearFields();
          Get.snackbar('Success', 'Coupon added successfully');
          log('Coupon added: ${apiResponse.data}');
          _dataProvider.getAllCoupons();
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to add coupon');
        }
      }
      else {
        SnackBarHelper.showErrorSnackBar('Failed to add coupon. Status code: ${response.statusCode}');
      }
    
    } catch (e) {
      Get.snackbar('Error', e.toString());
      rethrow;
    }

  }

  // Update an existing coupon
  updateCoupon() async {
    if (couponForUpdate != null) {
     
    

    try {
      Map<String, dynamic> coupon = {
        'couponCode': couponCodeCtrl.text,
        'discountType': selectedDiscountType,
        'discountAmount': double.tryParse(discountAmountCtrl.text) ?? 0.0,
        'minimumPurchaseAmount': double.tryParse(minimumPurchaseAmountCtrl.text) ?? 0.0,
        'endDate': endDateCtrl.text,
        'status': selectedCouponStatus,
        'applicableCategory': selectedCategory?.sId,
        'applicableSubCategory': selectedSubCategory?.sId,
        'applicableProduct': selectedProduct?.sId,
      };

      final response = await service.updateItem(
        endpointUrl: 'couponCodes',
        itemData: coupon,
        itemId: couponForUpdate?.sId ?? '',
      );

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          Get.snackbar('Success', 'Coupon updated successfully');
          log('Coupon updated: ${apiResponse.data}');
          _dataProvider.getAllCoupons();
        } else {
          SnackBarHelper.showErrorSnackBar(' Failed to update coupon');
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Failed to update coupon. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      rethrow;
    }
  }
}

  // Submit coupon (logic to decide between add or update)
  submitCoupon() {
    if (addCouponFormKey.currentState!.validate()) {
      if (couponForUpdate == null) {
        addCoupon();
      } else {
        updateCoupon();
      }
    }
  }

  // Delete a coupon
  deleteCoupon(Coupon coupon) async {
    try {
      Response response = await service.deleteItem(
        endpointUrl: 'couponCodes',
        itemId: coupon.sId ?? '',
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          Get.snackbar('Success', 'Coupon deleted successfully');
          log('Coupon deleted: ${apiResponse.data}');
          _dataProvider.getAllCoupons();
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to delete coupon');
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error: Failed to delete coupon.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      rethrow;
    }
  }


  //? set data for update on editing
  setDataForUpdateCoupon(Coupon? coupon) {
    if (coupon != null) {
      couponForUpdate = coupon;
      couponCodeCtrl.text = coupon.couponCode ?? '';
      selectedDiscountType = coupon.discountType ?? 'fixed';
      discountAmountCtrl.text = '${coupon.discountAmount}';
      minimumPurchaseAmountCtrl.text = '${coupon.minimumPurchaseAmount}';
      endDateCtrl.text = '${coupon.endDate}';
      selectedCouponStatus = coupon.status ?? 'active';
      selectedCategory = _dataProvider.categories.firstWhereOrNull((element) => element.sId == coupon.applicableCategory?.sId);
      selectedSubCategory =
          _dataProvider.subCategories.firstWhereOrNull((element) => element.sId == coupon.applicableSubCategory?.sId);
      selectedProduct = _dataProvider.products.firstWhereOrNull((element) => element.sId == coupon.applicableProduct?.sId);
    } else {
      clearFields();
    }
  }

  //? to clear text field and images after adding or update coupon
  clearFields() {
    couponForUpdate = null;
    selectedCategory = null;
    selectedSubCategory = null;
    selectedProduct = null;

    couponCodeCtrl.text = '';
    discountAmountCtrl.text = '';
    minimumPurchaseAmountCtrl.text = '';
    endDateCtrl.text = '';
  }

  clearRestrictions() {
    selectedCategory = null;
    selectedSubCategory = null;
    selectedProduct = null;
    notifyListeners();
  }

  updateUi() {
    notifyListeners();
  }
}
