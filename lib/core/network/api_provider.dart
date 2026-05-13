import 'dart:convert';
import 'package:ekart/core/constants/api_constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  static const _timeout = Duration(seconds: 10);

  Map<String, String> _defaultHeaders( 
    Map<String, String>? headers, {
    bool requireAuth = true 
  }) {
    final token = GetStorage().read('jwt_token');

    return {
      'Content-Type': ApiConstants.contentType,
      if(requireAuth && token != null) 
        'Authorization' : 'Bearer $token',
      ...?headers,
    };
  }


  // Generic GET call
  Future<http.Response> getCall(
    String path, {
      Map<String, String>? headers,
    }
  ) async { 
    try {  
      final response = await http.get(
        Uri.parse(ApiConstants.baseUrl + path),
        headers: _defaultHeaders(headers)
      ).timeout( _timeout ); 

      return response;
    } 
    catch (e) {
      throw Exception('Error while GET call - $e');
    }
  }


  // Generic POST call
  Future<http.Response> postCall(
    String path, 
    Map<String, dynamic> body, {
      Map<String, String>? headers,
      bool requireAuth = true,
    }
  ) async { 
    try {  
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + path),
        headers: _defaultHeaders(headers),
        body: jsonEncode(body),
      ).timeout( _timeout );

      return response;
    } 
    catch (e) {
      throw Exception('Error while POST call - $e');
    }
  }


  // Generic PUT call
  Future<http.Response> putCall(
    String path, 
    Map<String, dynamic> body, {
      Map<String, String>? headers,
    }
  ) async { 
    try {
      final response = await http.put(
        Uri.parse(ApiConstants.baseUrl + path),
        headers: _defaultHeaders(headers),
        body: jsonEncode(body),
      ).timeout( _timeout );
      return response;
    } 
    catch (e) {
      throw Exception('Error while PUT call - $e');
    }
  }


  // Generic DELETE call
  Future<http.Response> deleteCall(
    String path, {
      Map<String, String>? headers,
    }
  ) async { 
    try {  
      final response = await http.delete(
        Uri.parse(ApiConstants.baseUrl + path),
        headers: _defaultHeaders(headers),
      ).timeout( _timeout ) ;
      
      return response;
    } 
    catch (e) {
      throw Exception('Error while DELETE call - $e');
    }
  }


  // http.Response _handleStatusCode(http.Response response){
  //   if(response.statusCode >= 200  &&  response.statusCode <= 300){
  //     return response;
  //   }
  //   else{
  //     throw Exception('API Error: ${response.statusCode} \nError Body: ${response.body}');
  //   }
  // }
}