import 'package:ecommerce/features/profile/domain/entities/user_profile_entity.dart';
import 'package:ecommerce/features/profile/domain/repository/user_profile_repository.dart';

class CreateUserProfileUsecase {
  final UserProfileRepository repository;
  CreateUserProfileUsecase(this.repository);

  Future<UserProfileEntity> call({required int userId}) async {
    return await repository.createProfile(userId: userId);
  }
}