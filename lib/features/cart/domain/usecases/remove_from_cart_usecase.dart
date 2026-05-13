import 'package:ekart/features/cart/domain/entities/cart_entity.dart';
import 'package:ekart/features/cart/domain/repository/cart_repository.dart';

class RemoveFromCartUsecase {
  final CartRepository repository;
  RemoveFromCartUsecase(this.repository);

  Future<CartEntity> call({ required String itemDocumentId, required CartEntity cart, required int userId }) {
    return repository.removeCartItem( cart: cart, itemDocumentId: itemDocumentId, userId: userId );
  }
}