import 'package:ecommerce/features/auth/domain/entities/auth_user_entity.dart';
import 'package:ecommerce/features/auth/domain/repository/auth_user_repository.dart';

class LoginAuthUserUsecase {
  final AuthUserRepository authUserRepository;
  LoginAuthUserUsecase(this.authUserRepository);

  Future<AuthUserEntity> call(String email, String password) async {
    return await authUserRepository.login(email: email, password: password);
  }
}