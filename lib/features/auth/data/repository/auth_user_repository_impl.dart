import 'package:ecommerce/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:ecommerce/features/auth/domain/entities/auth_user_entity.dart';
import 'package:ecommerce/features/auth/domain/repository/auth_user_repository.dart';

class AuthUserRepositoryImpl implements AuthUserRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  AuthUserRepositoryImpl(this.authRemoteDatasource);

  @override
  Future<AuthUserEntity> login({required String email, required String password}) async {
    return await authRemoteDatasource.login(
      email: email,
      password: password,
    );
  }


  @override
  Future<AuthUserEntity> register({required String username, required String email, required String password}) async {
    return await authRemoteDatasource.register(
      username: username,
      email: email,
      password: password,
    );
  }


  @override
  Future<void> logout() async {
    await authRemoteDatasource.logout();
  }

}