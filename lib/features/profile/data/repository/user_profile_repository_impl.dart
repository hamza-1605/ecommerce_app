import 'package:ecommerce/features/profile/data/datasources/remote/user_profile_remote_datasource.dart';
import 'package:ecommerce/features/profile/data/models/user_profile_model.dart';
import 'package:ecommerce/features/profile/domain/entities/user_profile_entity.dart';
import 'package:ecommerce/features/profile/domain/repository/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDatasource userProfileRemoteDatasource;
  UserProfileRepositoryImpl(this.userProfileRemoteDatasource);
  
  @override
  Future<UserProfileEntity> getProfile({required int userId}) async {
    return await userProfileRemoteDatasource.getProfile( userId: userId );
  }
  
  
  @override
  Future<UserProfileEntity> updateProfile({required UserProfileEntity profile}) async {
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
      profileImage: profile.profileImage,
    );

    return await userProfileRemoteDatasource.updateProfile( profileModel );
  }
  

  @override
  Future<UserProfileEntity> createProfile({required int userId}) async {
    return await userProfileRemoteDatasource.createProfile(userId: userId);
  }
}

