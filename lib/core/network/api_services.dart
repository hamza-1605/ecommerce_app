import 'dart:convert';

import 'package:ecommerce/core/network/api_provider.dart';
import 'package:ecommerce/core/network/response_model.dart';
import 'package:http/http.dart';

class ApiServices {
  final ApiProvider _apiProvider = ApiProvider();

  Future<ApiResponse<T>> handleApiCall<T> (
    Future<Response> Function() apiCall,
    T Function(dynamic) fromJson,
  ) async {
    try {
      final response = await apiCall();
      if(response.statusCode >= 200 && response.statusCode <= 300){
        if (response.body.isEmpty) {
          return ApiResponse.success(null as T);
        }
        final data = fromJson( jsonDecode(response.body) );
        return ApiResponse.success(data);
      }
      else{
        return ApiResponse.failure(
          message: 'Request failed with code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } 
    catch (e) {
      return ApiResponse.failure(message: 'Unexpected Error Occurred: $e');
    }
  }



  // Specific GET call
  Future<ApiResponse<T>> getCall<T> (
    String endPoint,
    T Function(dynamic) fromJson,
  ) async {
    return handleApiCall(
      () => _apiProvider.getCall( endPoint ), 
      fromJson
    );
  }

  // specific POST call
  Future<ApiResponse<T>> postCall<T> (
    String endPoint,
    Map<String, dynamic> body,
    T Function(dynamic) fromJson,
    {bool requireAuth = true}
  ) async {
    return handleApiCall(
      () => _apiProvider.postCall( endPoint, body ), 
      fromJson,
    );
  }

  // specific PUT call
  Future<ApiResponse> putCall<T> (
    String endPoint,
    Map<String, dynamic> body,
    Function(dynamic) fromJson,
  ) async {
    return handleApiCall(
      () => _apiProvider.putCall( endPoint, body ), 
      fromJson,
    );
  }

  // specific DELETE call
  Future<ApiResponse<T>> deleteCall<T> (
    String endPoint,
    T Function(dynamic) fromJson,
  ) async {
    return handleApiCall(
      () => _apiProvider.deleteCall( endPoint ), 
      fromJson,
    );
  }
}