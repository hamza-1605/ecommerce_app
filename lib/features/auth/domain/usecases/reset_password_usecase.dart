import 'package:ecommerce/features/auth/domain/repository/auth_user_repository.dart';

class ResetPasswordUsecase {
  final AuthUserRepository repository;
  ResetPasswordUsecase(this.repository);

  Future<void> call({ required String code, required String password, required String passwordConfirmation}){ 
    return repository.resetPassword(
      code:                 code,
      password:             password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}