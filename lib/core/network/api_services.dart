import 'dart:convert';
import 'package:ecommerce/core/constants/api_constants.dart';
import 'package:ecommerce/core/network/api_provider.dart';
import 'package:ecommerce/core/network/response_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:io';


class ApiServices {
  final ApiProvider _apiProvider = ApiProvider();

  Future<ApiResponse<T>> handleApiCall<T> (
    Future<http.Response> Function() apiCall,
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


  // ---------------------------- Image Handling ----------------------------
  // Single Image 
  Future<int> uploadImage(File imageFile) async {
    final token = GetStorage().read('jwt_token');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}/api/upload'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
      await http.MultipartFile.fromPath('files', imageFile.path),
    );

    final response = await request.send();
    final body     = await response.stream.bytesToString();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(body);
      try {
        return json[0]['id'] as int;          // ✅ Strapi returns array
      } catch (e) {
        throw Exception('Failed to parse upload response: $e');
      }
    } else {
      throw Exception('Image upload failed with status: ${response.statusCode}');
    }
  }



  // Multiple Images
  Future<List<int>> uploadImages(List<File> imageFiles) async {
    final List<int> mediaIds = [];

    for (final file in imageFiles) {
      final id = await uploadImage(file);
      mediaIds.add(id);
    }

    return mediaIds;                         // ✅ list of all media ids
  }


  // Delete Image/Media
  Future<ApiResponse<void>> deleteMedia(int mediaId) async {
    return handleApiCall(
      () => _apiProvider.deleteCall('/api/upload/files/$mediaId'),
      (json) {},
    );
  }


  // Search users by email or username
  Future<ApiResponse<List<dynamic>>> searchUsers(String query) async {
    return handleApiCall(
      () => _apiProvider.getCall(
        '/api/users?filters[\$or][0][email][\$containsi]=$query'
        '&filters[\$or][1][username][\$containsi]=$query',
      ),
      (json) => json as List<dynamic>,
    );
  }

  // Update user isAdmin
  Future<ApiResponse<void>> updateUserAdminStatus({
    required int  userId,
    required bool isAdmin,
  }) async {
    return handleApiCall(
      () => _apiProvider.putCall(
        '/api/users/$userId',
        { "isAdmin": isAdmin },
      ),
      (json) {},
    );
  }
}