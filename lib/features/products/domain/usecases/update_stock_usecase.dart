import 'package:ecommerce/features/products/domain/repository/product_repository.dart';

class UpdateStockUsecase {
  final ProductRepository repository;
  UpdateStockUsecase(this.repository);

  Future<void> call({ required String documentId, required int newQuantity }) {
    return repository.updateStock( documentId:  documentId, newQuantity: newQuantity );
  }
}