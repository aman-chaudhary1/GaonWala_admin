import 'dart:convert';
import 'package:get/get_connect.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utility/constants.dart';

class HttpService {
  final String baseUrl = MAIN_URL;
  final GetConnect _connect = GetConnect();

  HttpService() {
    _connect.baseUrl = baseUrl;
    _connect.timeout = const Duration(seconds: 30);
    _connect.httpClient.addRequestModifier<dynamic>((request) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      request.headers['Accept'] = 'application/json';
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }

  Future<Response> getItems({required String endpointUrl, Map<String, dynamic>? query}) async {
    try {
      final response = await _connect.get(endpointUrl, query: query);
      print('GET $endpointUrl - Status Code: ${response.statusCode}');
      print('GET $endpointUrl - Response Body: ${response.bodyString}');
      return response;
    } catch (e) {
      print('GET $endpointUrl - Error: $e');
      return Response(
          body: json.encode({'error': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> addItem(
      {required String endpointUrl, required dynamic itemData}) async {
    try {
      final response = await _connect.post(endpointUrl, itemData);
      print('Status Code: ${response.statusCode}');
      print('Body String: ${response.bodyString}'); 
      // Safe access
      if (response.body == null) {
         print('Warning: Response body is null');
      }
      return response;
    } catch (e) {
      print('Error in addItem: $e');
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> updateItem(
      {required String endpointUrl,
      required String itemId,
      required dynamic itemData}) async {
    try {
      return await _connect.put('$endpointUrl/$itemId', itemData);
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> deleteItem(
      {required String endpointUrl, required String itemId}) async {
    try {
      return await _connect.delete('$endpointUrl/$itemId');
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }
}
