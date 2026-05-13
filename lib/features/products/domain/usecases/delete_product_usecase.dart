import 'package:ekart/features/products/domain/repository/product_repository.dart';

class DeleteProductUsecase {
  ProductRepository productRepository;
  DeleteProductUsecase(this.productRepository);

  Future<void> call( String documentId ) async{
    return await productRepository.deleteProduct( documentId: documentId );
  }
}