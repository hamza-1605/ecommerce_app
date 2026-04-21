import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/core/utils/helper_functions.dart';
import 'package:ecommerce/features/auth/domain/entities/auth_user_entity.dart';
import 'package:ecommerce/features/auth/domain/usecases/login_auth_user_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/logout_auth_user_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/register_auth_user_usecase.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class AuthController extends GetxController {
  final LoginAuthUserUsecase loginAuthUserUsecase;
  final LogoutAuthUserUsecase logoutAuthUserUsecase;
  final RegisterAuthUserUsecase registerAuthUserUsecase;

  AuthController(
    this.loginAuthUserUsecase, 
    this.logoutAuthUserUsecase, 
    this.registerAuthUserUsecase
  );

  final Rx<AuthUserEntity?> currentUser = Rx<AuthUserEntity?>(null);
  final RxBool isLoading = false.obs;

  Future<void> registerUser({required String email, required String username, required String password}) async {
    isLoading.value = true;

    try {
      final user = await registerAuthUserUsecase.call(email, username, password);
      currentUser.value = user;
      await _saveUserData(user); 
      Get.offAllNamed( AppRoutes.home );
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: "Registeration Failed", 
        message: e.toString(),
        isError: true,
      );
    }
    finally{
      isLoading.value = false;
    }
  }


  Future<void> loginUser({required String email, required String password}) async {
    isLoading.value = true;

    try {
      final user = await loginAuthUserUsecase.call(email, password);
      currentUser.value = user;
      await _saveUserData(user);
      Get.offAllNamed( AppRoutes.home );
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: "Login Failed", 
        message: e.toString(),
        isError: true,
      );
    }
    finally{
      isLoading.value = false;
    }
  }


  Future<void> logout() async {
    try {
      await logoutAuthUserUsecase.call();
      await _clearUserData();                  
      currentUser.value = null;
      Get.offAllNamed(AppRoutes.login);       
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error', 
        message: e.toString(), 
        isError: true
      );
    }
  }


  // ── TOKEN Management ──────────────────────────────
  Future<void> _saveUserData(AuthUserEntity user) async {
    GetStorage().write('jwt_token', user.token);
    GetStorage().write('user_id',    user.id);
    GetStorage().write('user_email',    user.email);  
    GetStorage().write('user_username', user.username);
  }

  Future<void> _clearUserData() async {
    GetStorage().remove('jwt_token');
    GetStorage().remove('user_id');
    GetStorage().remove('user_email');
    GetStorage().remove('user_username');
  }

  String? getToken() {
    return GetStorage().read('jwt_token');
  }
}