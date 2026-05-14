import 'package:ekart/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:ekart/features/auth/domain/entities/auth_user_entity.dart';
import 'package:ekart/features/auth/domain/repository/auth_user_repository.dart';

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
  Future<void> forgotPassword({required String email}) async {
    return await authRemoteDatasource.forgotPassword(email: email);
  }

  @override
  Future<void> resetPassword({ required String code, required String password, required String passwordConfirmation }) async {
    return await authRemoteDatasource.resetPassword(
      code:                 code,
      password:             password,
      passwordConfirmation: passwordConfirmation,
    );
  }

}