import 'package:ecommerce/features/cart/data/models/cart_item_model.dart';
import 'package:ecommerce/features/cart/domain/entities/cart_entity.dart';

class CartModel extends CartEntity {
  CartModel({
    required super.documentId, 
    required super.cartItems, 
    required super.total
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final items = (json['cartItems'] as List<dynamic>? ?? [])
        .map( (item) => CartItemModel.fromJson(item) )
        .toList();

    return CartModel(
      documentId: json['documentId'],
      cartItems:  items,
      total:      (json['total'] as num? ?? 0).toInt(),
    );
  }


  Map<String, dynamic> toJson(){
    return {
      'cartItems': cartItems.map((item) => (item as CartItemModel).toJson())
                            .toList(),
      'total': total,
    };
  }

}