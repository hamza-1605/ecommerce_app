import 'package:ecommerce/features/orders/domain/entities/order_item_entity.dart';

class OrderEntity {
  final String documentId;
  final List<OrderItemEntity> orderItems;
  final String deliveryAddress;
  final int total;
  final String paymentMethod;
  final String orderStatus;
  final DateTime createdAt;

  OrderEntity({
    required this.documentId,
    required this.orderItems,
    required this.deliveryAddress,
    required this.total,
    required this.paymentMethod,
    required this.orderStatus,
    required this.createdAt,
  });
}