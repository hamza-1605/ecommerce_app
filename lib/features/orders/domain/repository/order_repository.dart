import 'package:ecommerce/features/orders/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getOrders({ required int userId });

  Future<OrderEntity>       createOrder({ required int userId, required OrderEntity order });

  Future<OrderEntity>       updateOrder({ required String documentId, required String orderStatus });

  Future<void>              deleteOrder({required String documentId});

}