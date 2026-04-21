import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:ecommerce/features/products/domain/repository/product_repository.dart';

class GetProductsUsecase {
  ProductRepository productRepository;
  GetProductsUsecase(this.productRepository);

  Future<List<ProductEntity>> call() async{
    return await productRepository.getProducts();
  }
}