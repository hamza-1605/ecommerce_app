import 'package:ekart/core/network/api_services.dart';
import 'package:ekart/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:ekart/features/auth/data/repository/auth_user_repository_impl.dart';
import 'package:ekart/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:ekart/features/auth/domain/usecases/login_auth_user_usecase.dart';
import 'package:ekart/features/auth/domain/usecases/logout_auth_user_usecase.dart';
import 'package:ekart/features/auth/domain/usecases/register_auth_user_usecase.dart';
import 'package:ekart/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:ekart/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ekart/features/wishlist/data/datasource/wishlist_local_datasource.dart';
import 'package:ekart/features/wishlist/presentation/state/controller/wishlist_controller.dart';
import 'package:get/get.dart';

class AppBinding {
  static void init() {
    // ── Global Dependencies ──────────────────────
    Get.put(ApiServices(), permanent: true);

    // ── Wishlist ─────────────────────────────────
    Get.put(
      WishlistController(
        datasource: WishlistLocalDatasource(),
      ),
      permanent: true,
    );

    // ── Auth ─────────────────────────────────────
    final authRemote = AuthRemoteDatasource( Get.find() );
    final authRepo   = AuthUserRepositoryImpl( authRemote );

    Get.put(
      AuthController(
        LoginAuthUserUsecase(authRepo),
        LogoutAuthUserUsecase(authRepo),
        RegisterAuthUserUsecase(authRepo),
        ForgotPasswordUsecase(authRepo),
        ResetPasswordUsecase(authRepo),
      ),
      permanent: true,
    );
  }

}