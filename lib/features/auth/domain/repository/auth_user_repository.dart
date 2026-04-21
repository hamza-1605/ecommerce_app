import 'package:ecommerce/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthUserRepository {
  
  Future<AuthUserEntity> login({ required String email, required String password });

  Future<AuthUserEntity> register({ required String username, required String email,  required String password });

  Future<void> logout();
}