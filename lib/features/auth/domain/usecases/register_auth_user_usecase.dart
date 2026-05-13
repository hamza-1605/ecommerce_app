import 'package:ekart/features/auth/domain/entities/auth_user_entity.dart';
import 'package:ekart/features/auth/domain/repository/auth_user_repository.dart';

class RegisterAuthUserUsecase {
  final AuthUserRepository authUserRepository;
  RegisterAuthUserUsecase(this.authUserRepository);

  Future<AuthUserEntity> call(String email, String username, String password) async{
    return await authUserRepository.register(username: username, email: email, password: password);
  }
}