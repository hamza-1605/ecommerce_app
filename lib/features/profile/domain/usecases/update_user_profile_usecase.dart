import 'package:ecommerce/features/profile/domain/entities/user_profile_entity.dart';
import 'package:ecommerce/features/profile/domain/repository/user_profile_repository.dart';

class UpdateUserProfileUsecase {
  final UserProfileRepository userProfileRepository;
  UpdateUserProfileUsecase(this.userProfileRepository);

  Future<UserProfileEntity> call({required UserProfileEntity profile}) async{
    return await userProfileRepository.updateProfile(profile: profile);
  }
}