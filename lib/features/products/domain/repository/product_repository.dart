import 'package:ecommerce/features/products/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
  
  Future<ProductEntity> getProductById({ required String documentId });

  Future<void> addProduct({ required ProductEntity product });

  Future<void> editProduct({ required ProductEntity product });

  Future<void> deleteProduct({ required String documentId });
}