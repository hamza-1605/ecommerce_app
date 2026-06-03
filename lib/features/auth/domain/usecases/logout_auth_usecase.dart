import 'package:ekart/features/auth/domain/repository/auth_user_repository.dart';

class LogoutAuthUsecase {
  final AuthUserRepository authUserRepository;
  LogoutAuthUsecase(this.authUserRepository);

  Future<void> call({required int userId}) async{
    return await authUserRepository.logout(userId: userId);
  }
}