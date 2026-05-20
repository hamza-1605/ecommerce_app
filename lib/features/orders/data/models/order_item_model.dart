import 'package:ekart/features/orders/domain/entities/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  OrderItemModel({
    required super.productDocumentId,
    required super.productName,
    required super.price,
    required super.quantity,
  });


  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final productList = json['product'] as List<dynamic>;
    final product = productList.isNotEmpty 
        ? productList.first as Map<String, dynamic>
        : null; // 👈 guard against empty/deleted product

    return OrderItemModel(
      productDocumentId: product?['documentId'] ?? '',
      productName:       product?['itemName']    ?? 'Deleted Product',
      price:             (json['price'] as num).toInt(),
      quantity:          json['quantity'],
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'product':  productDocumentId,
      'price':    price,
      'quantity': quantity,
    };
  }
}