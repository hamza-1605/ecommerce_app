import 'package:ekart/features/products/domain/entities/product_entity.dart';
import 'package:ekart/features/products/domain/repository/product_repository.dart';

class GetProductByIdUsecase {
  ProductRepository productRepository;
  GetProductByIdUsecase(this.productRepository);

  Future<ProductEntity> call( String documentId ) async{
    return await productRepository.getProductById(documentId: documentId);
  }
}