import 'package:ekart/core/constants/api_constants.dart';
import 'package:ekart/core/network/api_services.dart';
import 'package:ekart/features/profile/data/models/user_profile_model.dart';
import 'package:ekart/features/profile/domain/entities/user_profile_entity.dart';

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
  

  Future<UserProfileModel> updateProfile({
    required UserProfileModel profile,
    required int userId,  
  }) async {
    final apiResponse = await apiServices.putCall<void>(
      '${ApiConstants.profileEndpoint}/${profile.documentId}',
      { 
        "data": profile.toJson() 
      },
      (json) {},
    );
    
    if (apiResponse.success) {
      return await getProfile(userId: userId);
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