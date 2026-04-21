import 'package:ecommerce/features/orders/domain/repository/order_repository.dart';

class DeleteOrderUsecase {
  final OrderRepository repository;
  DeleteOrderUsecase(this.repository);

  Future<void> call({required String documentId}) =>
      repository.deleteOrder(documentId: documentId);
}