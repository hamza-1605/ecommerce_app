import 'package:ekart/core/network/payment_service.dart';
import 'package:ekart/features/orders/domain/repository/order_repository.dart';
import 'package:ekart/features/orders/domain/usecases/delete_order_usecase.dart';
import 'package:ekart/features/orders/domain/usecases/get_all_orders_usecase.dart';
import 'package:ekart/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:ekart/features/orders/domain/usecases/update_order_usecase.dart';
import 'package:ekart/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:ekart/features/orders/data/repository/order_repository_impl.dart';
import 'package:ekart/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:ekart/features/orders/presentation/state/controller/order_controller.dart';
import 'package:get/get.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderRemoteDatasource(apiServices: Get.find()), fenix: true);

    Get.lazyPut<OrderRepository>(
      () => OrderRepositoryImpl(remoteDatasource: Get.find()),
      fenix: true,
    );

    Get.lazyPut( () => GetOrdersUsecase(Get.find()),   fenix: true);
    Get.lazyPut( () => CreateOrderUsecase(Get.find()), fenix: true);
    Get.lazyPut( () => UpdateOrderUsecase(Get.find()), fenix: true);
    Get.lazyPut( () => DeleteOrderUsecase(Get.find()), fenix: true);
    Get.lazyPut( () => GetAllOrdersUsecase(Get.find()), fenix: true);
    Get.lazyPut( () => PaymentService(apiServices: Get.find()), fenix: true);

    Get.lazyPut(() => OrderController(
      getOrdersUsecase:   Get.find(),
      createOrderUsecase: Get.find(),
      updateOrderUsecase: Get.find(),
      deleteOrderUsecase: Get.find(),
      getAllOrdersUsecase: Get.find(),
      paymentService:     Get.find(),
    ), fenix: true);
  }
}