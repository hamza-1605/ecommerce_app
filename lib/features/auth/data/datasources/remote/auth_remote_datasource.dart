import 'package:ecommerce/core/constants/api_constants.dart';
import 'package:ecommerce/core/network/api_services.dart';
import 'package:ecommerce/features/auth/data/models/auth_user_model.dart';

class AuthRemoteDatasource {
  final ApiServices apiServices;
  AuthRemoteDatasource(this.apiServices);

  // Login
  Future<AuthUserModel> login({required String email, required String password}) async {
    final apiResponse = await apiServices.postCall(
      ApiConstants.loginEndpoint, 
      {
        "identifier" : email,
        "password" : password
      }, 
      (json) => AuthUserModel.fromJson(json),
      requireAuth: false,
    );

    if (apiResponse.success) {
      return apiResponse.data!;
    } else {
      throw Exception(apiResponse.message);
    }
  }

  // Registeration
  Future<AuthUserModel> register({required String username, required String email, required String password}) async {
    final apiResponse = await apiServices.postCall(
      ApiConstants.registerEndpoint, 
      {
        "email" : email,
        "username" : username,
        "password" : password
      }, 
      (json) => AuthUserModel.fromJson(json),
      requireAuth: false,
    );

    if (apiResponse.success) {
      return apiResponse.data!;
    } else {
      throw Exception(apiResponse.message);
    }
  }


  Future<void> logout() async{
    return ;
  }


  // Forget Password
  Future<void> forgotPassword({required String email}) async {
    final apiResponse = await apiServices.postCall<void>(
      '/api/auth/forgot-password',
      { "email": email },
      (json) {},
      requireAuth: false,
    );

    if (!apiResponse.success) {
      throw Exception(apiResponse.message);
    }
  }

  
  // Reset Password
  Future<void> resetPassword({
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    final apiResponse = await apiServices.postCall<void>(
      '/api/auth/reset-password',
      {
        "code":                 code,
        "password":             password,
        "passwordConfirmation": passwordConfirmation,
      },
      (json) {},
      requireAuth: false,               // no token needed
    );

    if (!apiResponse.success) {
      throw Exception(apiResponse.message);
    }
  }

}