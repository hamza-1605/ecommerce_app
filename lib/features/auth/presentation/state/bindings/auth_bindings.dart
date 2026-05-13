import 'package:ekart/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:ekart/features/auth/data/repository/auth_user_repository_impl.dart';
import 'package:ekart/features/auth/domain/repository/auth_user_repository.dart';
import 'package:ekart/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:ekart/features/auth/domain/usecases/login_auth_user_usecase.dart';
import 'package:ekart/features/auth/domain/usecases/logout_auth_user_usecase.dart';
import 'package:ekart/features/auth/domain/usecases/register_auth_user_usecase.dart';
import 'package:ekart/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:ekart/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthBindings extends Bindings {

  @override
  void dependencies() {
    // Remote Datasource
    Get.lazyPut( () => AuthRemoteDatasource( Get.find() ) , fenix: true);

    // Repository
    Get.lazyPut<AuthUserRepository>( 
      () => AuthUserRepositoryImpl( Get.find() ), 
      fenix: true
    );

    // Usecases
    Get.lazyPut( () => LoginAuthUserUsecase( Get.find() ) , fenix: true);
    Get.lazyPut( () => RegisterAuthUserUsecase( Get.find() ) , fenix: true);
    Get.lazyPut( () => LogoutAuthUserUsecase( Get.find() ) , fenix: true);
    Get.lazyPut( () => ForgotPasswordUsecase( Get.find() ) , fenix: true);
    Get.lazyPut( () => ResetPasswordUsecase( Get.find() ) , fenix: true);

    // Controller
    Get.put(
      AuthController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
      ),
      permanent: true,
    );
  }

}