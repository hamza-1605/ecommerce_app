import 'package:ecommerce/core/constants/api_constants.dart';
import 'package:ecommerce/core/network/api_services.dart';
import 'package:ecommerce/features/profile/data/models/user_profile_model.dart';
import 'package:ecommerce/features/profile/domain/entities/user_profile_entity.dart';

class UserProfileRemoteDatasource {
  final ApiServices apiServices;
  UserProfileRemoteDatasource(this.apiServices);

  Future<UserProfileModel> getProfile({required int userId}) async {
    final apiResponse = await apiServices.getCall<UserProfileModel>(
      '${ApiConstants.profileEndpoint}?filters[user][id][\$eq]=$userId&populate=profileImage', 
      (json) {
        final List<dynamic> items = json['data'];

        if (items.isEmpty) throw Exception('Profile not found');

        return UserProfileModel.fromJson(items.first);  // one profile per user
      },
    ); 

    if (apiResponse.success) {
      return apiResponse.data!;
    } else {
      throw Exception(apiResponse.message);
    }
  }
  

  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    final apiResponse = await apiServices.putCall<UserProfileModel>(
      '${ApiConstants.profileEndpoint}/${profile.documentId}',
      { 
        "data": profile.toJson() 
      },
      (json) => UserProfileModel.fromJson(json['data']),
    );

    if (apiResponse.success) {
      return apiResponse.data!;
    } else {
      throw Exception(apiResponse.message);
    }
  }


  Future<UserProfileEntity> createProfile({required int userId}) async {
    final apiResponse = await ApiServices().postCall<UserProfileModel>(
      ApiConstants.profileEndpoint,
      {
        "data": {
          "user": userId,
        }
      },
      (json) => UserProfileModel.fromJson(json['data']),
    );

    if (apiResponse.success) {
      return apiResponse.data!;
    } else {
      throw Exception(apiResponse.message);
    }   
  }
}