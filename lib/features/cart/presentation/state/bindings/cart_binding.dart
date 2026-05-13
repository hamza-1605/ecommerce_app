import 'package:ekart/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:ekart/features/cart/domain/repository/cart_repository.dart';
import 'package:ekart/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:ekart/features/cart/domain/usecases/create_cart_usecase.dart';
import 'package:ekart/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:ekart/features/cart/domain/usecases/update_cart_usecase.dart';
import 'package:ekart/features/cart/data/repository/cart_repository_impl.dart';
import 'package:ekart/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:ekart/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:ekart/features/cart/presentation/state/controller/cart_controller.dart';
import 'package:get/get.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    // Datasource
    Get.lazyPut(() => CartRemoteDatasource( apiServices: Get.find()), fenix: true );

    // Repository
    Get.lazyPut<CartRepository>(
      () => CartRepositoryImpl( Get.find() ), 
      fenix: true
    );

    // Usecases
    Get.lazyPut(() => GetCartUsecase(Get.find()), fenix: true);
    Get.lazyPut(() => CreateCartUsecase(Get.find()), fenix: true);
    Get.lazyPut(() => AddToCartUsecase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdateCartUsecase(Get.find()), fenix: true);
    Get.lazyPut(() => RemoveFromCartUsecase(Get.find()), fenix: true);
    Get.lazyPut(() => ClearCartUsecase(Get.find()), fenix: true);

    // Controller
    Get.lazyPut(() => CartController(
      getCartUsecase:        Get.find(),
      createCartUsecase:     Get.find(),
      addToCartUsecase:      Get.find(),
      updateCartItemUsecase: Get.find(),
      removeCartItemUsecase: Get.find(),
      clearCartUsecase:      Get.find(),
    ), fenix: true);
  }
}