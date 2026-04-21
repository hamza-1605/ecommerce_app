import 'package:ecommerce/features/cart/domain/entities/cart_entity.dart';
import 'package:ecommerce/features/cart/domain/repository/cart_repository.dart';

class GetCartUsecase {
  final CartRepository repository;
  GetCartUsecase(this.repository);
  
  Future<CartEntity> call({ required int userId }) {
    return repository.getCart(userId: userId);
  }
}