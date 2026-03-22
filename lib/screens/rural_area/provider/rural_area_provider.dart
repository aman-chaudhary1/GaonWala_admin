import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/rural_area.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class RuralAreaProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  final HttpService service = HttpService();

  List<Block> blocks = [];
  List<Panchayat> panchayats = [];
  List<Village> villages = [];

  RuralAreaProvider(this._dataProvider);

  // 🔹 FETCH BLOCKS
  Future<void> fetchBlocks() async {
    try {
      final response = await service.getItems(endpointUrl: 'api/rural-areas/blocks');
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        blocks = data.map((e) => Block.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching blocks: $e');
    }
  }

  // 🔹 ADD BLOCK
  Future<void> addBlock(String name) async {
    try {
      final response = await service.addItem(
        endpointUrl: 'api/rural-areas/blocks',
        itemData: {'name': name},
      );
      if (response.statusCode == 201) {
        SnackBarHelper.showSuccessSnackBar('Block added');
        fetchBlocks();
      } else {
        SnackBarHelper.showErrorSnackBar(response.body['message'] ?? 'Failed to add block');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error: $e');
    }
  }

  // 🔹 FETCH PANCHAYATS
  Future<void> fetchPanchayats(String blockId) async {
    try {
      final response = await service.getItems(endpointUrl: 'api/rural-areas/panchayats?blockId=$blockId');
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        panchayats = data.map((e) => Panchayat.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching panchayats: $e');
    }
  }

  // 🔹 ADD PANCHAYAT
  Future<void> addPanchayat(String name, String blockId) async {
    try {
      final response = await service.addItem(
        endpointUrl: 'api/rural-areas/panchayats',
        itemData: {'name': name, 'blockId': blockId},
      );
      if (response.statusCode == 201) {
        SnackBarHelper.showSuccessSnackBar('Panchayat added');
        fetchPanchayats(blockId);
      } else {
        SnackBarHelper.showErrorSnackBar(response.body['message'] ?? 'Failed to add panchayat');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error: $e');
    }
  }

  // 🔹 FETCH VILLAGES
  Future<void> fetchVillages(String panchayatId) async {
    try {
      final response = await service.getItems(endpointUrl: 'api/rural-areas/villages?panchayatId=$panchayatId');
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        villages = data.map((e) => Village.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching villages: $e');
    }
  }

  // 🔹 ADD VILLAGE
  Future<void> addVillage(String name, String panchayatId, double deliveryFee) async {
    try {
      final response = await service.addItem(
        endpointUrl: 'api/rural-areas/villages',
        itemData: {
          'name': name,
          'panchayatId': panchayatId,
          'deliveryFee': deliveryFee,
        },
      );
      if (response.statusCode == 201) {
        SnackBarHelper.showSuccessSnackBar('Village added');
        fetchVillages(panchayatId);
      } else {
        SnackBarHelper.showErrorSnackBar(response.body['message'] ?? 'Failed to add village');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error: $e');
    }
  }

  // 🔹 UPDATE BLOCK
  Future<void> updateBlock(String id, String name) async {
    try {
      final response = await service.updateItem(
        endpointUrl: 'api/rural-areas/blocks',
        itemId: id,
        itemData: {'name': name},
      );
      if (response.statusCode == 200) {
        SnackBarHelper.showSuccessSnackBar('Block updated');
        fetchBlocks();
      } else {
        SnackBarHelper.showErrorSnackBar(response.body['message'] ?? 'Failed to update block');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error: $e');
    }
  }

  // 🔹 DELETE BLOCK
  Future<void> deleteBlock(String id) async {
    try {
      final response = await service.deleteItem(
        endpointUrl: 'api/rural-areas/blocks',
        itemId: id,
      );
      if (response.statusCode == 200) {
        SnackBarHelper.showSuccessSnackBar('Block deleted');
        fetchBlocks();
      } else {
        SnackBarHelper.showErrorSnackBar(response.body['message'] ?? 'Failed to delete block');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error: $e');
    }
  }

  // 🔹 UPDATE PANCHAYAT
  Future<void> updatePanchayat(String id, String name, String blockId) async {
    try {
      final response = await service.updateItem(
        endpointUrl: 'api/rural-areas/panchayats',
        itemId: id,
        itemData: {'name': name},
      );
      if (response.statusCode == 200) {
        SnackBarHelper.showSuccessSnackBar('Panchayat updated');
        fetchPanchayats(blockId);
      } else {
        SnackBarHelper.showErrorSnackBar(response.body['message'] ?? 'Failed to update panchayat');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error: $e');
    }
  }

  // 🔹 DELETE PANCHAYAT
  Future<void> deletePanchayat(String id, String blockId) async {
    try {
      final response = await service.deleteItem(
        endpointUrl: 'api/rural-areas/panchayats',
        itemId: id,
      );
      if (response.statusCode == 200) {
        SnackBarHelper.showSuccessSnackBar('Panchayat deleted');
        fetchPanchayats(blockId);
      } else {
        SnackBarHelper.showErrorSnackBar(response.body['message'] ?? 'Failed to delete panchayat');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error: $e');
    }
  }

  // 🔹 UPDATE VILLAGE
  Future<void> updateVillage(String id, String name, double fee, String panchayatId) async {
    try {
      final response = await service.updateItem(
        endpointUrl: 'api/rural-areas/villages',
        itemId: id,
        itemData: {'name': name, 'deliveryFee': fee},
      );
      if (response.statusCode == 200) {
        SnackBarHelper.showSuccessSnackBar('Village updated');
        fetchVillages(panchayatId);
      } else {
        SnackBarHelper.showErrorSnackBar(response.body['message'] ?? 'Failed to update village');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error: $e');
    }
  }

  // 🔹 DELETE VILLAGE
  Future<void> deleteVillage(String id, String panchayatId) async {
    try {
      final response = await service.deleteItem(
        endpointUrl: 'api/rural-areas/villages',
        itemId: id,
      );
      if (response.statusCode == 200) {
        SnackBarHelper.showSuccessSnackBar('Village deleted');
        fetchVillages(panchayatId);
      } else {
        SnackBarHelper.showErrorSnackBar(response.body['message'] ?? 'Failed to delete village');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error: $e');
    }
  }
}
