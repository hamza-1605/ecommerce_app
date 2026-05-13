import 'package:ekart/features/profile/domain/entities/user_profile_entity.dart';

abstract class UserProfileRepository {
  
  Future<UserProfileEntity> getProfile({required int userId});
  
  Future<UserProfileEntity> updateProfile({required UserProfileEntity profile});
  
  Future<UserProfileEntity> createProfile({required int userId});
}