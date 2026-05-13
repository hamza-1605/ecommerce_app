import 'package:ekart/features/orders/domain/entities/order_entity.dart';
import 'package:ekart/features/orders/domain/repository/order_repository.dart';

class UpdateOrderUsecase {
  final OrderRepository orderRepository;
  UpdateOrderUsecase(this.orderRepository);

  Future<OrderEntity> call({required String orderId, required String orderStatus}) async {
    return await orderRepository.updateOrder(documentId: orderId, orderStatus: orderStatus);
  }
}