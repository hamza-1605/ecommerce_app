import 'package:ecommerce/features/profile/domain/entities/user_profile_entity.dart';
import 'package:ecommerce/features/profile/domain/repository/user_profile_repository.dart';

class GetUserProfileUsecase {
  final UserProfileRepository userProfileRepository;
  GetUserProfileUsecase(this.userProfileRepository);

  Future<UserProfileEntity> call({required int userId}) async {
    return await userProfileRepository.getProfile(userId: userId);
  }
}