import 'package:ekart/features/cart/domain/entities/cart_entity.dart';
import 'package:ekart/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ekart/features/cart/domain/repository/cart_repository.dart';

class UpdateCartUsecase {
  final CartRepository repository;
  UpdateCartUsecase(this.repository);

  Future<CartEntity> call({ required CartItemEntity updatedItem, required CartEntity cart, required int userId }) {
    return repository.updateCartItem( cart: cart, updatedItem: updatedItem, userId: userId );
  }
}