import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/core/network/api_services.dart';
import 'package:ekart/core/services/notification_service.dart';
import 'package:ekart/core/utils/helper_functions.dart';
import 'package:ekart/core/utils/validators.dart';
import 'package:ekart/features/auth/domain/entities/auth_user_entity.dart';
import 'package:ekart/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:ekart/features/auth/domain/usecases/login_auth_user_usecase.dart';
import 'package:ekart/features/auth/domain/usecases/logout_auth_usecase.dart';
import 'package:ekart/features/auth/domain/usecases/register_auth_user_usecase.dart';
import 'package:ekart/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:ekart/features/home/presentation/state/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class AuthController extends GetxController {
  final LoginAuthUserUsecase loginAuthUserUsecase;
  final RegisterAuthUserUsecase registerAuthUserUsecase;
  final ForgotPasswordUsecase forgotPasswordUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;
  final LogoutAuthUsecase logoutAuthUsecase;

  AuthController(
    this.loginAuthUserUsecase, 
    this.registerAuthUserUsecase,
    this.forgotPasswordUsecase,
    this.resetPasswordUsecase,
    this.logoutAuthUsecase,
  );

  final Rx<AuthUserEntity?> currentUser = Rx<AuthUserEntity?>(null);
  final RxBool isLoading = false.obs;

  Future<void> registerUser({required String email, required String username, required String password}) async {
    final usernameValidationError = Validators.validateUsername(username: username);
    if (usernameValidationError != null) {
      HelperFunctions.showSnackbar(
        title: 'Invalid Username',
        message: usernameValidationError,
        isError: true,
      );
      return;
    }
    
    final emailValidationError = Validators.validateEmail(email: email);
    if (emailValidationError != null) {
      HelperFunctions.showSnackbar(
        title: 'Invalid Email',
        message: emailValidationError,
        isError: true,
      );
      return;
    }

    final passwordValidationError = Validators.validatePassword(password: password);
    if (passwordValidationError != null) {
      HelperFunctions.showSnackbar(
        title: 'Invalid Password',
        message: passwordValidationError,
        isError: true,
      );
      return;
    }

    isLoading.value = true;

    try {
      final user = await registerAuthUserUsecase.call(email, username, password);
      currentUser.value = user;
      await _saveUserData(user); 
      HelperFunctions.showSnackbar(
        title: 'Welcome Aboard',
        message: 'Signup Successful! You may browse the app now and place an order.'
      );
      if (user.isAdmin) {
        Get.offAllNamed(AppRoutes.adminHome);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: "Registeration Failed", 
        message: HelperFunctions().msg(e),
        isError: true,
      );
    }
    finally{
      isLoading.value = false;
    }
  }


  Future<void> loginUser({required String email, required String password}) async {
    final emailValidationError = Validators.validateEmail(email: email);
    if (emailValidationError != null) {
      HelperFunctions.showSnackbar(
        title: 'Invalid Email',
        message: emailValidationError,
        isError: true,
      );
      return;
    }

    final passwordValidationError = Validators.validatePassword(password: password);
    if (passwordValidationError != null) {
      HelperFunctions.showSnackbar(
        title: 'Invalid Password',
        message: passwordValidationError,
        isError: true,
      );
      return;
    }
    isLoading.value = true;

    try {
      final user = await loginAuthUserUsecase.call(email, password);
      currentUser.value = user;
      await _saveUserData(user);
      await _saveFcmToken();          // token for notification

      HelperFunctions.showSnackbar(
        title: 'Log in', 
        message: 'Successfully Logged In!', 
        isError: false
      );  
      if (user.isAdmin) {
        Get.offAllNamed(AppRoutes.adminHome);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: "Login Failed", 
        message: HelperFunctions().msg(e),
        isError: true,
      );
    }
    finally{
      isLoading.value = false;
    }
  }


  Future<void> logout({required int userId}) async {
    try {
      await logoutAuthUsecase.call(userId: userId);
      await _clearUserData();      
      currentUser.value = null;
      HelperFunctions.showSnackbar(
        title: 'Log Out', 
        message: 'Successfully Logged Out!', 
        isError: false
      );
      await Get.offAllNamed(AppRoutes.login);
      final homeController = Get.find<HomeController>();
      homeController.navigateTo(0);
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error', 
        message: HelperFunctions().msg(e), 
        isError: true
      );
    }
  }


  Future<void> forgotPassword({required String email}) async {
    final validationError = Validators.validateEmail(email: email);
    if (validationError != null) {
      HelperFunctions.showSnackbar(
        title: 'Invalid Email',
        message: validationError,
        isError: true,
      );
      return;
    }

    isLoading.value = true;
    try {
      await forgotPasswordUsecase.call(email: email);
      Get.back();                               // go back to login
      HelperFunctions.showSnackbar(
        title:   'Email Sent!',
        message: 'Check your inbox for the reset link',
      );
      Get.toNamed(AppRoutes.resetPassword);
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title:   'Error',
        message: HelperFunctions().msg(e),
        isError: true,
      );
    } 
    finally {
      isLoading.value = false;
    }
  }


  Future<void> resetPassword({
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    final validationError = Validators.validateResetPassword(
      code: code,
      password: password,
      confirmPassword: passwordConfirmation,
    );

    if (validationError != null) {
      HelperFunctions.showSnackbar(
        title: 'Validation Error',
        message: validationError,
        isError: true,
      );
      return;
    }

    isLoading.value = true;
    try {
      await resetPasswordUsecase.call(
        code:                 code,
        password:             password,
        passwordConfirmation: passwordConfirmation,
      );
      Get.offAllNamed(AppRoutes.login);     // go to login after reset
      HelperFunctions.showSnackbar(
        title:   'Success!',
        message: 'Password reset successfully. Please login.',
      );
    } catch (e) {
      HelperFunctions.showSnackbar(
        title:   'Error',
        message: HelperFunctions().msg(e),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }


  // ── Credentials Management ──────────────────────────────
  Future<void> _saveUserData(AuthUserEntity user) async {
    GetStorage().write('jwt_token', user.token);
    GetStorage().write('user_id',    user.id);
    GetStorage().write('user_email',    user.email);  
    GetStorage().write('user_username', user.username);
    GetStorage().write('user_is_admin', user.isAdmin);
  }

  Future<void> _clearUserData() async {
    GetStorage().remove('jwt_token');
    GetStorage().remove('user_id');
    GetStorage().remove('user_email');
    GetStorage().remove('user_username');
    GetStorage().remove('user_is_admin');
  }

  String? getToken() {
    return GetStorage().read('jwt_token');
  }



  Future<void> _saveFcmToken() async {
    try {
      final token = await NotificationService.getToken();
      print('=== FCM TOKEN SAVE ===');
      print('Token: $token');

      if (token == null) return;

      final userId = GetStorage().read('user_id');
      print('User ID: $userId');

      final response = await ApiServices().putCall(
        '/api/users/$userId',         // 👈 use existing users endpoint
        {'deviceToken': token},
        (json) {},
      );

      print('Response success: ${response.success}');
      print('Response message: ${response.message}');

    } catch (e, stack) {
      print('FCM token save failed: $e');
      print('Stack: $stack');
    }
  }
}