import 'package:ekart/features/auth/domain/repository/auth_user_repository.dart';

class LogoutAuthUserUsecase {
  final AuthUserRepository authUserRepository;
  LogoutAuthUserUsecase(this.authUserRepository);

  Future<void> call() async {
    return await authUserRepository.logout();
  }
}