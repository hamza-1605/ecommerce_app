import 'package:ekart/features/profile/data/datasources/remote/user_profile_remote_datasource.dart';
import 'package:ekart/features/profile/data/models/user_profile_model.dart';
import 'package:ekart/features/profile/domain/entities/user_profile_entity.dart';
import 'package:ekart/features/profile/domain/repository/user_profile_repository.dart';
import 'package:get_storage/get_storage.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDatasource userProfileRemoteDatasource;
  UserProfileRepositoryImpl(this.userProfileRemoteDatasource);
  
  @override
  Future<UserProfileEntity> getProfile({required int userId}) async {
    return await userProfileRemoteDatasource.getProfile( userId: userId );
  }
  
  
  @override
  Future<UserProfileEntity> updateProfile({required UserProfileEntity profile}) async {
    final userId = GetStorage().read('user_id') as int;
    final profileModel = UserProfileModel(
      documentId:   profile.documentId,
      fullName:     profile.fullName,
      phone:        profile.phone,
      address:      profile.address,
      city:         profile.city,
      country:      profile.country,
      postalCode:   profile.postalCode,
      dob:          profile.dob,
      gender:       profile.gender,
      profileImage: null, 
    );

    return await userProfileRemoteDatasource.updateProfile(profile: profileModel, userId: userId);
  }
  

  @override
  Future<UserProfileEntity> createProfile({required int userId}) async {
    return await userProfileRemoteDatasource.createProfile(userId: userId);
  }
}

