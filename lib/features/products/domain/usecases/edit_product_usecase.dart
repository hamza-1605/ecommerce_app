import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:ecommerce/features/products/domain/repository/product_repository.dart';

class EditProductUsecase {
  ProductRepository productRepository;
  EditProductUsecase(this.productRepository);

  Future<void> call(ProductEntity product) async{
    return await productRepository.editProduct( product: product );
  }
}