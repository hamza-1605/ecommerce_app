import 'package:ecommerce/features/cart/domain/entities/cart_entity.dart';
import 'package:ecommerce/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce/features/cart/domain/repository/cart_repository.dart';

class AddToCartUsecase {
  final CartRepository repository;
  AddToCartUsecase(this.repository);

  Future<CartEntity> call({ required CartItemEntity item, required CartEntity cart, required int userId }) {
    return repository.addToCart( cart: cart, item: item, userId: userId );
  }
}