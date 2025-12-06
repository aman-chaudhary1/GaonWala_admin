import '../../../models/variant_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../models/variant.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class VariantsProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addVariantsFormKey = GlobalKey<FormState>();
  TextEditingController variantCtrl = TextEditingController();
  VariantType? selectedVariantType;
  Variant? variantForUpdate;




  VariantsProvider(this._dataProvider);


  //TODO: should complete addVariant(complete)
addVariant() async {
    try {
      Map<String, dynamic> variantData = {
        'name': variantCtrl.text.trim(),
        'variantTypeId': selectedVariantType?.sId,
      };
      final response = await service.addItem(
        endpointUrl: 'variants',
        itemData: variantData,
      );
if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body,null);
        if (apiResponse.success) {
          SnackBarHelper.showSuccessSnackBar('Variant added successfully');
          await _dataProvider.getAllVariant();
          clearFields();
          notifyListeners();
        } else {
          SnackBarHelper.showErrorSnackBar(apiResponse.message ?? 'Failed to add variant');
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Failed to add variant: ${response.statusText}');
      }
    } catch (e) {
      print('Error adding variant: $e');
      SnackBarHelper.showErrorSnackBar('Failed to add variant: $e');
      rethrow;
    }
  }
  //TODO: should complete updateVariant(complete)
updateVariant() async {
  try {
    if (variantForUpdate != null) {
      Map<String, dynamic> updatedData = {
        'name': variantCtrl.text.trim(),
        'variantTypeId': selectedVariantType?.sId,
      };
      final response = await service.updateItem(
        endpointUrl: 'variants',
        itemId: variantForUpdate!.sId ?? '',
        itemData: updatedData,
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success) {
          SnackBarHelper.showSuccessSnackBar('Variant updated successfully');
          await _dataProvider.getAllVariant();
          clearFields();
          notifyListeners();
        } else {
          SnackBarHelper.showErrorSnackBar(
              apiResponse.message ?? 'Failed to update variant');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Failed to update variant: ${response.statusText}');
      }
    }
    }catch(e) {
      print('Error updating variant: $e');
      SnackBarHelper.showErrorSnackBar('Failed to update variant: $e');
      ;
    }
  }

    
  //TODO: should complete submitVariant(complete)

submitVariant() {
    if (variantForUpdate == null) {
      addVariant();
    } else {
      updateVariant();
    }
  }

  //TODO: should complete deleteVariant(complete)
deleteVariant(Variant variant) async {
  try {
    Response response = await service.deleteItem(
      endpointUrl: 'variants',
      itemId: variant.sId ?? '',
    );
    if (response.isOk) {
      ApiResponse apiResponse = ApiResponse.fromJson(response.body,null);
      if (apiResponse.success) {
        SnackBarHelper.showSuccessSnackBar('Variant deleted successfully');
        await _dataProvider.getAllVariant();
        notifyListeners();
      } else {
        SnackBarHelper.showErrorSnackBar(
            apiResponse.message ?? 'Failed to delete variant');
      }
    } else {
      SnackBarHelper.showErrorSnackBar(
          'Failed to delete variant: ${response.statusText}');
    }
  } catch (e) {
    print('Error deleting variant: $e');
    SnackBarHelper.showErrorSnackBar('Failed to delete variant: $e');
    rethrow;
  }
}

  setDataForUpdateVariant(Variant? variant) {
    if (variant != null) {
      variantForUpdate = variant;
      variantCtrl.text = variant.name ?? '';
      selectedVariantType =
          _dataProvider.variantTypes.firstWhereOrNull((element) => element.sId == variant.variantTypeId?.sId);
    } else {
      clearFields();
    }
  }

  clearFields() {
    variantCtrl.clear();
    selectedVariantType = null;
    variantForUpdate = null;
  }

  void updateUI() {
    notifyListeners();
  }
}
