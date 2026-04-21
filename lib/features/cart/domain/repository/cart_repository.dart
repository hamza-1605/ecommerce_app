import 'package:ecommerce/features/cart/domain/entities/cart_entity.dart';
import 'package:ecommerce/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<CartEntity> getCart({ required int userId });

  Future<CartEntity> createCart({ required int userId });

  Future<CartEntity> addToCart({ required CartEntity cart, required CartItemEntity item, required int userId });

  Future<CartEntity> updateCartItem({ required CartEntity cart, required CartItemEntity updatedItem, required int userId });

  Future<CartEntity> removeCartItem({ required CartEntity cart, required String itemDocumentId, required int userId });

  Future<void>       clearCart({ required CartEntity cart });
}