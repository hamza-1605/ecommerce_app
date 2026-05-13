import 'package:ekart/features/orders/data/models/order_item_model.dart';
import 'package:ekart/features/orders/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.documentId,
    required super.orderItems,
    required super.deliveryAddress,
    required super.total,
    required super.paymentMethod,
    required super.orderStatus,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final items = ( json['orderItems'] as List<dynamic>? ?? [] )
                  .map((item) => OrderItemModel.fromJson(item))
                  .toList();

    return OrderModel(
      documentId:      json['documentId'],
      orderItems:      items,
      deliveryAddress: json['deliveryAddress'] ?? '',
      total:           (json['total'] as num).toInt(),
      paymentMethod:   json['paymentMethod'] ?? '',
      orderStatus:     json['orderStatus'].toString().toLowerCase(),
      createdAt:       DateTime.parse( json['createdAt'] ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderItems':      orderItems
                         .map( (item) => (item as OrderItemModel).toJson() )
                         .toList(),
      'deliveryAddress': deliveryAddress,
      'total':           total,
      'paymentMethod':   paymentMethod,
      'status':          orderStatus,
    };
  }
}