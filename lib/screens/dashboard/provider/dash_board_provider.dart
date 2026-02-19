import 'dart:developer';
import 'dart:io';
import '../../../models/api_response.dart';
import '../../../models/brand.dart';
import '../../../models/sub_category.dart';
import '../../../models/variant_type.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../services/http_services.dart';
import '../../../models/product.dart';
import '../../../utility/snack_bar_helper.dart';

class DashBoardProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addProductFormKey = GlobalKey<FormState>();

  //?text editing controllers in dashBoard screen
  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productDescCtrl = TextEditingController();
  TextEditingController productQntCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();
  TextEditingController productOffPriceCtrl = TextEditingController();
  TextEditingController productSizeCtrl = TextEditingController();
  TextEditingController customUnitCtrl = TextEditingController();

  //? dropdown value
  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  Brand? selectedBrand;
  VariantType? selectedVariantType;
  List<String> selectedVariants = [];
  String? selectedUnit = 'kg'; // Default unit
  bool isTodaysSpecial = false;
  bool isAvailable = true;

  Product? productForUpdate;
  File? selectedMainImage,
      selectedSecondImage,
      selectedThirdImage,
      selectedFourthImage,
      selectedFifthImage;
  XFile? mainImgXFile,
      secondImgXFile,
      thirdImgXFile,
      fourthImgXFile,
      fifthImgXFile;

//?to filter the data depend on the parent dropdown value
  List<SubCategory> subCategoriesByCategory = [];
  List<Brand> brandsBySubCategory = [];
  List<String> variantsByVariantType = [];

  DashBoardProvider(this._dataProvider);

  //TODO: should complete addProduct
  addProduct() async {
    try {
      if (selectedMainImage == null) {
        SnackBarHelper.showErrorSnackBar(
          'Please select a image',
        );
        return;
      }
      Map<String, dynamic> formDataMap = {
        'name': productNameCtrl.text,
        'description': productDescCtrl.text,
        'proCategoryId': selectedCategory?.sId ?? '',
        'proSubCategoryId': selectedSubCategory?.sId ?? '',
        'price': productPriceCtrl.text,
        'offPrice': productOffPriceCtrl.text.isEmpty
            ? productPriceCtrl.text
            : productOffPriceCtrl.text,
        'quantity': productQntCtrl.text,
        'proBrandId': selectedBrand?.sId ?? '',
        'proVariantTypeId': selectedVariantType?.sId ?? '',
        'proVariantId': selectedVariants,
        'todaysSpecial': isTodaysSpecial.toString(),
        'isAvailable': isAvailable.toString(),
        'unit': selectedUnit == 'Other' ? customUnitCtrl.text : selectedUnit ?? 'kg',
        'productSize': productSizeCtrl.text,
      };
      final FormData form = await createFormDataForMultipleImage(imgXFiles: [
        {'image1': mainImgXFile},
        {'image2': secondImgXFile},
        {'image3': thirdImgXFile},
        {'image4': fourthImgXFile},
        {'image5': fifthImgXFile},
      ], formData: formDataMap);
      if (productForUpdate != null) {}
      final response = await service.addItem(
        endpointUrl: 'products',
        itemData: form,
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log('Product added successfully');
          _dataProvider.getAllProduct(showSnack: true);
          clearFields();
        } else {
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Failed to add product. Please try again.');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
  }

  //TODO: should complete updateProduct(complete)
  updateProduct() async {
    try {
      Map<String, dynamic> formDataMap = {
        'name': productNameCtrl.text,
        'description': productDescCtrl.text,
        'proCategoryId': selectedCategory?.sId ?? '',
        'proSubCategoryId': selectedSubCategory?.sId ?? '',
        'price': productPriceCtrl.text,
        'offerPrice': productOffPriceCtrl.text.isEmpty
            ? productPriceCtrl.text
            : productOffPriceCtrl.text,
        'quantity': productQntCtrl.text,
        'proBrandId': selectedBrand?.sId ?? '',
        'proVariantTypeId': selectedVariantType?.sId ?? '',
        'proVariantId': selectedVariants,
        'todaysSpecial': isTodaysSpecial.toString(),
        'isAvailable': isAvailable.toString(),
        'unit': selectedUnit == 'Other' ? customUnitCtrl.text : selectedUnit ?? 'kg',
        'unit': selectedUnit == 'Other' ? customUnitCtrl.text : selectedUnit ?? 'kg',
        'productSize': productSizeCtrl.text.isEmpty ? '' : productSizeCtrl.text,
      };

      final FormData form = await createFormDataForMultipleImage(
        imgXFiles: [
          {'image1': mainImgXFile},
          {'image2': secondImgXFile},
          {'image3': thirdImgXFile},
          {'image4': fourthImgXFile},
          {'image5': fifthImgXFile},
        ],
        formData: formDataMap,
      );

      final response = await service.updateItem(
        endpointUrl: 'products',
        itemData: form,
        itemId: productForUpdate!.sId!,
      );

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log('Product updated successfully');
          _dataProvider.getAllProduct(showSnack: true);
        } else {
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Failed to update product. Please try again.');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
  }

  //TODO: should complete submitProduct
  submitProduct() async {
    if (productForUpdate == null) {
      await addProduct();
    } else {
      await updateProduct();
    }
  }

  //TODO: should complete deleteProduct

  deleteProduct(Product product) async {
    try {
      Response response = await service.deleteItem(
        endpointUrl: 'products',
        itemId: product.sId ?? '',
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          log('Product deleted successfully');
          _dataProvider.getAllProduct(showSnack: true);
        } else {
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Failed to delete product. Please try again.');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
  }

  void pickImage({required int imageCardNumber}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (imageCardNumber == 1) {
        selectedMainImage = File(image.path);
        mainImgXFile = image;
      } else if (imageCardNumber == 2) {
        selectedSecondImage = File(image.path);
        secondImgXFile = image;
      } else if (imageCardNumber == 3) {
        selectedThirdImage = File(image.path);
        thirdImgXFile = image;
      } else if (imageCardNumber == 4) {
        selectedFourthImage = File(image.path);
        fourthImgXFile = image;
      } else if (imageCardNumber == 5) {
        selectedFifthImage = File(image.path);
        fifthImgXFile = image;
      }
      notifyListeners();
    }
  }

  Future<FormData> createFormDataForMultipleImage({
    required List<Map<String, XFile?>>? imgXFiles,
    required Map<String, dynamic> formData,
  }) async {
    // Loop over the provided image files and add them to the form data
    if (imgXFiles != null) {
      for (int i = 0; i < imgXFiles.length; i++) {
        XFile? imgXFile = imgXFiles[i]['image' + (i + 1).toString()];
        if (imgXFile != null) {
          // Check if it's running on the web
          if (kIsWeb) {
            String fileName = imgXFile.name;
            Uint8List byteImg = await imgXFile.readAsBytes();
            formData['image' + (i + 1).toString()] =
                MultipartFile(byteImg, filename: fileName);
          } else {
            String filePath = imgXFile.path;
            String fileName = filePath.split('/').last;
            formData['image' + (i + 1).toString()] =
                await MultipartFile(filePath, filename: fileName);
          }
        }
      }
    }

    // Create and return the FormData object
    final FormData form = FormData(formData);
    return form;
  }

  //TODO: should complete filterSubcategory
  filterSubcategory(Category category) {
    selectedSubCategory = null;
    selectedBrand = null;
    selectedCategory = category;
    subCategoriesByCategory.clear();
    final newList = _dataProvider.subCategories
        .where((subcategory) => subcategory.categoryId?.sId == category.sId)
        .toList();
    subCategoriesByCategory = newList;
    notifyListeners();
  }

  //TODO: should complete filterBrand(compleyte)
  filterBrand(SubCategory subCategory) {
    selectedBrand = null;
    selectedSubCategory = subCategory;
    brandsBySubCategory.clear();
    final newList = _dataProvider.brands
        .where((brand) => brand.subcategoryId?.sId == subCategory.sId)
        .toList();
    brandsBySubCategory = newList;
    notifyListeners();
  }

  //TODO: should complete filterVariant
  filterVariant(VariantType variantType) {
    selectedVariants = [];
    selectedVariantType = variantType;
    final newList = _dataProvider.variants
        .where((variant) => variant.variantTypeId?.sId == variantType.sId)
        .toList();
    final List<String> variantNames =
        newList.map((variant) => variant.name ?? '').toList();
    variantsByVariantType = variantNames;
    notifyListeners();
  }

  setDataForUpdateProduct(Product? product) {
    if (product != null) {
      productForUpdate = product;

      productNameCtrl.text = product.name ?? '';
      productDescCtrl.text = product.description ?? '';
      productPriceCtrl.text = product.price.toString();
      productOffPriceCtrl.text = '${product.offerPrice}';
      productQntCtrl.text = '${product.quantity}';
      productQntCtrl.text = '${product.quantity}';
      productSizeCtrl.text = (product.productSize != null) ? '${product.productSize}' : '';
      
      const standardUnits = ['kg', 'gm', 'ltr', 'ml', 'pc', 'Half Plate', 'Full Plate', 'Other'];
      if (standardUnits.contains(product.unit)) {
         selectedUnit = product.unit;
      } else {
         selectedUnit = 'Other';
         customUnitCtrl.text = product.unit ?? '';
      }

      selectedCategory = _dataProvider.categories.firstWhereOrNull(
          (element) => element.sId == product.proCategoryId?.sId);

      final newListCategory = _dataProvider.subCategories
          .where((subcategory) =>
              subcategory.categoryId?.sId == product.proCategoryId?.sId)
          .toList();
      subCategoriesByCategory = newListCategory;
      selectedSubCategory = _dataProvider.subCategories.firstWhereOrNull(
          (element) => element.sId == product.proSubCategoryId?.sId);

      final newListBrand = _dataProvider.brands
          .where((brand) =>
              brand.subcategoryId?.sId == product.proSubCategoryId?.sId)
          .toList();
      brandsBySubCategory = newListBrand;
      selectedBrand = _dataProvider.brands.firstWhereOrNull(
          (element) => element.sId == product.proBrandId?.sId);

      selectedVariantType = _dataProvider.variantTypes.firstWhereOrNull(
          (element) => element.sId == product.proVariantTypeId?.sId);

      final newListVariant = _dataProvider.variants
          .where((variant) =>
              variant.variantTypeId?.sId == product.proVariantTypeId?.sId)
          .toList();
      final List<String> variantNames =
          newListVariant.map((variant) => variant.name ?? '').toList();
      variantsByVariantType = variantNames;
      selectedVariants = product.proVariantId ?? [];
      isTodaysSpecial = product.todaysSpecial ?? false;
      isAvailable = product.isAvailable ?? true;
    } else {
      clearFields();
    }
  }

  clearFields() {
    productNameCtrl.clear();
    productDescCtrl.clear();
    productPriceCtrl.clear();
    productOffPriceCtrl.clear();
    productQntCtrl.clear();
    productSizeCtrl.clear();
    customUnitCtrl.clear();

    selectedMainImage = null;
    selectedSecondImage = null;
    selectedThirdImage = null;
    selectedFourthImage = null;
    selectedFifthImage = null;

    mainImgXFile = null;
    secondImgXFile = null;
    thirdImgXFile = null;
    fourthImgXFile = null;
    fifthImgXFile = null;

    selectedCategory = null;
    selectedSubCategory = null;
    selectedBrand = null;
    selectedVariantType = null;
    selectedUnit = 'kg';
    selectedVariants = [];
    isTodaysSpecial = false;
    isAvailable = true;

    productForUpdate = null;

    subCategoriesByCategory = [];
    brandsBySubCategory = [];
    variantsByVariantType = [];
  }

  updateUI() {
    notifyListeners();
  }
}
