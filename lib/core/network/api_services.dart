import 'dart:convert';
import 'package:ekart/core/constants/api_constants.dart';
import 'package:ekart/core/network/api_provider.dart';
import 'package:ekart/core/network/response_model.dart';
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
          message: _friendlyHttpError(response.statusCode),
          statusCode: response.statusCode,
        );
      }
    } 
    catch (e) {
      return ApiResponse.failure(message: _friendlyExceptionError(e));
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


  String _friendlyHttpError(int statusCode) {
    switch (statusCode) {
      case 400: return 'Invalid request. Please check your data.';
      case 401: return 'Incorrect email or password.';
      case 403: return 'You don\'t have permission to do this.';
      case 404: return 'The requested resource was not found.';
      case 409: return 'An account with this email/username already exists.';
      case 422: return 'Invalid data provided. Please try again.';
      case 429: return 'Too many attempts. Please wait and try again.';
      case 500: return 'Internal Server error. Please try again.';
      case 503: return 'Server error. Please try again later.';
      default:  return 'Something went wrong. Please try again.';
    }
  }

  String _friendlyExceptionError(Object e) {
    if (e is SocketException) return 'No internet connection. Please check your network.';
    if (e is HttpException)   return 'Unable to reach the server. Please try again.';
    if (e is FormatException) return 'Unexpected response from server.';
    return 'Something went wrong. Please try again.';
  }
}