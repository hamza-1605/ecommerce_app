import 'package:ecommerce/features/cart/domain/entities/cart_entity.dart';
import 'package:ecommerce/features/cart/domain/repository/cart_repository.dart';

class ClearCartUsecase {
  final CartRepository repository;
  ClearCartUsecase(this.repository);

  Future<void> call({ required CartEntity cart }) {
    return repository.clearCart( cart: cart );
  }
}