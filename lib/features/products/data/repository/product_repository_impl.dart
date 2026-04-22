import 'package:ecommerce/features/products/data/datasources/remote_products_datasource.dart';
import 'package:ecommerce/features/products/data/models/product_model.dart';
import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:ecommerce/features/products/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteProductsDatasource remoteProductsDatasource;
  ProductRepositoryImpl({required this.remoteProductsDatasource});

  @override
  Future<void> addProduct({ required ProductEntity product }) async {
    final productModel = ProductModel(
      itemName: product.itemName, 
      category: product.category, 
      price: product.price, 
      quantity: product.quantity,
      description: product.description,
      imagesUrl: product.imagesUrl,
      salePercent: product.salePercent
    );
    
    return await remoteProductsDatasource.createProduct(productModel);
  }


  @override
  Future<void> editProduct({required ProductEntity product}) async {
    final productModel = ProductModel(
      documentId: product.documentId,
      itemName: product.itemName, 
      category: product.category, 
      price: product.price, 
      quantity: product.quantity,
      description: product.description,
      imagesUrl: product.imagesUrl,
      salePercent: product.salePercent
    );

    await remoteProductsDatasource.updateProduct( productModel );
  }


  @override
  Future<void> deleteProduct({ required String documentId }) async {
    return await remoteProductsDatasource.deleteProduct( documentId );
  }


  @override
  Future<ProductEntity> getProductById({ required String documentId }) async {
    return await remoteProductsDatasource.getProductById(documentId);
  }


  @override
  Future<List<ProductEntity>> getProducts() async{
    return await remoteProductsDatasource.readProducts();
  }


  @override
  Future<void> updateStock({ required String documentId, required int newQuantity}) async {
    return await remoteProductsDatasource.updateStock(documentId: documentId, newQuantity: newQuantity);
  }
}