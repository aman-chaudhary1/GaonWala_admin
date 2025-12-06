import 'dart:developer' as Console;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../models/category.dart';
import '../../../models/sub_category.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';


class SubCategoryProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addSubCategoryFormKey = GlobalKey<FormState>();
  TextEditingController subCategoryNameCtrl = TextEditingController();
  Category? selectedCategory;
  SubCategory? subCategoryForUpdate;




  SubCategoryProvider(this._dataProvider);


  //TODO: should complete addSubCategory(complete)
  addSubCategory()async{
    try{

      Map<String, dynamic> subCategory = {
        'name': subCategoryNameCtrl.text,
       'categoryId': selectedCategory?.sId ?? '',
      };


      final response = await service.addItem(endpointUrl: 'subCategories',itemData:subCategory);

      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body,null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
        _dataProvider.getAllSubCategory();
          Console.log("Sub category added");
        }
        else{
          SnackBarHelper.showErrorSnackBar('Failed to add Sub category: ${apiResponse.message}');
        }
      }
      else{
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
    }catch(e){
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      rethrow;
    }
  }

  //TODO: should complete updateSubCategory(complete)
  updateSubCategory()async{
    try{
      
      Map<String, dynamic> subCategory = {
        'name': subCategoryNameCtrl.text,
        'categoryId': selectedCategory?.sId ?? '',
      };

      final response = await service.updateItem(endpointUrl: 'subCategories',itemData:subCategory, itemId: subCategoryForUpdate?.sId ?? '');

      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body,null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
         _dataProvider.getAllCategory();
          Console.log("Sub category updateed");
          _dataProvider.getAllSubCategory();
        }
        else{
          SnackBarHelper.showErrorSnackBar('Failed to add subcategory: ${apiResponse.message}');
        }
      }
      else{
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
    }catch(e){
print(e);
SnackBarHelper.showErrorSnackBar('An error occurred: $e');
rethrow;
    }
}
  //TODO: should complete submitSubCategory(complete)
submitSubCategory()async{
    if(subCategoryForUpdate == null){
      await addSubCategory();
    }
    else{
      await updateSubCategory();
    }
  }

  //TODO: should complete deleteSubCategory
deleteSubCategory(SubCategory subCategory)async{
        Console.log("category Deletedfffll");

    try{
      Response response = await service.deleteItem(endpointUrl: 'subCategories',itemId: subCategory.sId ?? '');
      Console.log("subcategory Deletedfff");

      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body,null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar('SubCategory Deleted Successfully');
         _dataProvider.getAllSubCategory();
          Console.log("subcategory Deleted");
        }
      else{
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
      }
    }catch(e){
print(e);
SnackBarHelper.showErrorSnackBar('An error occurred: $e');
rethrow;
    }
}

  setDataForUpdateSubCategory(SubCategory? subCategory) {
    if (subCategory != null) {
      subCategoryForUpdate = subCategory;
      subCategoryNameCtrl.text = subCategory.name ?? '';
      selectedCategory = _dataProvider.categories.firstWhereOrNull((element) => element.sId == subCategory.categoryId?.sId);
    } else {
      clearFields();
    }
  }

  clearFields() {
    subCategoryNameCtrl.clear();
    selectedCategory = null;
    subCategoryForUpdate = null;
  }

  updateUi(){
    notifyListeners();
  }
}
