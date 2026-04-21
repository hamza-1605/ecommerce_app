import 'package:ecommerce/features/orders/domain/entities/order_entity.dart';
import 'package:ecommerce/features/orders/domain/repository/order_repository.dart';

class CreateOrderUsecase {
  final OrderRepository orderRepository;
  CreateOrderUsecase(this.orderRepository);

  Future<OrderEntity> call({required int userId, required OrderEntity order}) async {
    return await orderRepository.createOrder(userId: userId, order: order);
  }
}