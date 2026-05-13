import 'package:ekart/features/products/data/datasources/remote_products_datasource.dart';
import 'package:ekart/features/products/data/repository/product_repository_impl.dart';
import 'package:ekart/features/products/domain/repository/product_repository.dart';
import 'package:ekart/features/products/domain/usecases/add_product_usecase.dart';
import 'package:ekart/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:ekart/features/products/domain/usecases/edit_product_usecase.dart';
import 'package:ekart/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:ekart/features/products/domain/usecases/get_products_usecase.dart';
import 'package:ekart/features/products/domain/usecases/update_stock_usecase.dart';
import 'package:ekart/features/products/presentation/state/controller/product_controller.dart';
import 'package:get/get.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    // Datasource
    Get.lazyPut(() => RemoteProductsDatasource(apiServices: Get.find()) , fenix: true);

    // Repository
    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(remoteProductsDatasource: Get.find()),
      fenix: true
    );

    // Usecases
    Get.lazyPut(() => GetProductsUsecase( Get.find() ), fenix: true);
    Get.lazyPut(() => GetProductByIdUsecase( Get.find() ), fenix: true);
    Get.lazyPut(() => AddProductUsecase( Get.find() ), fenix: true);
    Get.lazyPut(() => EditProductUsecase( Get.find() ), fenix: true);
    Get.lazyPut(() => DeleteProductUsecase( Get.find() ), fenix: true);
    Get.lazyPut(() => UpdateStockUsecase( Get.find() ), fenix: true);

    // Controller
    Get.lazyPut(() => ProductController(
      getProductsUsecase: Get.find(),
      getProductByIdUsecase: Get.find(),
      createProductUsecase: Get.find(),
      updateProductUsecase: Get.find(),
      deleteProductUsecase: Get.find(),
      updateStockUsecase: Get.find(),
    ),
    fenix: true);
  }
}