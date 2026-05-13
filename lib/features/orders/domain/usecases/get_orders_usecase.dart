import 'package:ekart/features/orders/domain/entities/order_entity.dart';
import 'package:ekart/features/orders/domain/repository/order_repository.dart';

class GetOrdersUsecase {
  final OrderRepository orderRepository;
  GetOrdersUsecase(this.orderRepository);

  Future<List<OrderEntity>> call({required int userId}) async {
    return await orderRepository.getOrders(userId: userId);
  }
}