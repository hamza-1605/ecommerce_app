import 'package:ecommerce/features/cart/domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  CartItemModel({
    required super.documentId, 
    required super.productDocumentId, 
    required super.productName, 
    required super.quantity, 
    required super.price
  });


  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = (json['product'] as List<dynamic>).first;
    
    return CartItemModel(
      documentId:        json['id'].toString(),
      productDocumentId: product['documentId'],
      productName:       product['itemName'],
      price:             (json['price'] as num).toInt(),
      quantity:          json['quantity'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'product' : productDocumentId,
      'price' : price,
      'quantity' : quantity,
    };
  } 
}