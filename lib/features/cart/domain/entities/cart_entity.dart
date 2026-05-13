import 'package:ekart/features/cart/domain/entities/cart_item_entity.dart';

class CartEntity {
  final String documentId;
  final List<CartItemEntity> cartItems;
  final int total;

  CartEntity({
    required this.documentId, 
    required this.cartItems, 
    required this.total
  });
}