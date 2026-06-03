import 'package:ekart/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthUserRepository {
  
  Future<AuthUserEntity> login({ required String email, required String password });

  Future<AuthUserEntity> register({ required String username, required String email,  required String password });

  Future<void> forgotPassword({required String email});
  
  Future<void> resetPassword({required String code, required String password, required String passwordConfirmation});

  Future<void> logout({required int userId});
}