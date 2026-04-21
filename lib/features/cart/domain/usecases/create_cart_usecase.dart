import 'package:ecommerce/features/cart/domain/entities/cart_entity.dart';
import 'package:ecommerce/features/cart/domain/repository/cart_repository.dart';

class CreateCartUsecase {
  final CartRepository repository;
  CreateCartUsecase(this.repository);

  Future<CartEntity> call({ required int userId }) {
    return repository.createCart(userId: userId);
  }
}