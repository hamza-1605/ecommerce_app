import 'package:ekart/features/orders/domain/entities/order_entity.dart';
import 'package:ekart/features/orders/domain/repository/order_repository.dart';

class GetAllOrdersUsecase {
  final OrderRepository orderRepository;
  GetAllOrdersUsecase(this.orderRepository);

  Future<List<OrderEntity>> call() async {
    return await orderRepository.getAllOrders();
  }
}