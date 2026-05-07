import 'package:ecommerce/core/network/api_services.dart';
import 'package:ecommerce/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:ecommerce/features/auth/data/repository/auth_user_repository_impl.dart';
import 'package:ecommerce/features/auth/domain/usecases/login_auth_user_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/logout_auth_user_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/register_auth_user_usecase.dart';
import 'package:ecommerce/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ecommerce/features/wishlist/data/datasource/wishlist_local_datasource.dart';
import 'package:ecommerce/features/wishlist/presentation/state/controller/wishlist_controller.dart';
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
      ),
      permanent: true,
    );
  }

}