import 'package:ekart/features/auth/domain/repository/auth_user_repository.dart';

class ForgotPasswordUsecase {
  final AuthUserRepository repository;
  ForgotPasswordUsecase(this.repository);

  Future<void> call({required String email}){
    return repository.forgotPassword(email: email);
  }
}