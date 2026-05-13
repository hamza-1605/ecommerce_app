import 'package:ekart/features/products/domain/entities/product_entity.dart';
import 'package:ekart/features/products/domain/repository/product_repository.dart';

class AddProductUsecase {
  ProductRepository productRepository;
  AddProductUsecase(this.productRepository);

  Future<void> call(ProductEntity product) async{
    return await productRepository.addProduct(product: product);
  }
}