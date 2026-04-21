import 'package:ecommerce/core/utils/helper_functions.dart';
import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:ecommerce/features/products/domain/usecases/add_product_usecase.dart';
import 'package:ecommerce/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:ecommerce/features/products/domain/usecases/edit_product_usecase.dart';
import 'package:ecommerce/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:ecommerce/features/products/domain/usecases/get_products_usecase.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {

  final GetProductsUsecase getProductsUsecase;
  final AddProductUsecase createProductUsecase;
  final EditProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;
  final GetProductByIdUsecase getProductByIdUsecase;

  ProductController({
    required this.getProductsUsecase,
    required this.createProductUsecase,
    required this.updateProductUsecase,
    required this.deleteProductUsecase,
    required this.getProductByIdUsecase
  });


  // ── State ──────────────────────────────────────────
  final RxList<ProductEntity> products = <ProductEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;   // for create/edit/delete actions
  final RxString errorMessage = ''.obs;

  // selected product for detail/edit screen
  final Rx<ProductEntity?> selectedProduct = Rx<ProductEntity?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // ── READ ───────────────────────────────────────────
  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await getProductsUsecase.call();
      products.assignAll(result);
    } 
    catch (e) {
      errorMessage.value = e.toString();
      HelperFunctions.showSnackbar(title: 'Error', message: errorMessage.value, isError: true, duration: Duration(seconds: 10));
    } 
    finally {
      isLoading.value = false;
    }
  }

  // ── READ BY ID ───────────────────────────────────────────
  Future<void> fetchProductById( String documentId ) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await getProductByIdUsecase.call( documentId );
      selectedProduct.value = result;
    } 
    catch (e) {
      errorMessage.value = e.toString();
      HelperFunctions.showSnackbar(title: 'Error', message: errorMessage.value, isError: true, duration: Duration(seconds: 10));
    } 
    finally {
      isLoading.value = false;
    }
  }

  // ── CREATE ─────────────────────────────────────────
  Future<void> createProduct(ProductEntity product) async {
    isSubmitting.value = true;

    try {
      await createProductUsecase.call(product);
      await fetchProducts();                  
      Get.back();         
      HelperFunctions.showSnackbar(title: "Success", message: "Product Created Successfully!", duration: Duration(seconds: 5));
    } 
    catch (e) {
      HelperFunctions.showSnackbar(title: 'Error', message: e.toString(), isError: true, duration: Duration(seconds: 10));
    } 
    finally {
      isSubmitting.value = false;
    }
  }


  // ── UPDATE ─────────────────────────────────────────
  Future<void> updateProduct(ProductEntity product) async {
    isSubmitting.value = true;

    try {
      await updateProductUsecase.call(product);
      await fetchProducts();
      selectedProduct.value = null;                
      selectedProduct.value = product;                
      Get.back();                          
      HelperFunctions.showSnackbar(title: 'Success', message: 'Product Updated Successfully');
    } 
    catch (e) {
      HelperFunctions.showSnackbar(title: 'Error', message: e.toString(), isError: true, duration: Duration(seconds: 10));
    } 
    finally {
      isSubmitting.value = false;
    }
  }


  // ── DELETE ─────────────────────────────────────────
  Future<void> deleteProduct(String documentId) async {
    isSubmitting.value = true;

    try {
      await deleteProductUsecase.call(documentId);
      products.removeWhere((p) => p.documentId == documentId);  // update list locally, no need to refetch
      Get.back();
      HelperFunctions.showSnackbar(title: 'Success', message: 'Product deleted successfully');
    } 
    catch (e) {
      HelperFunctions.showSnackbar(title: 'Error', message: e.toString(), isError: true, duration: Duration(seconds: 8));
    } 
    finally {
      isSubmitting.value = false;
    }
  }


  // ── HELPER ─────────────────────────────────────────
  void selectProduct(ProductEntity product) {
    selectedProduct.value = product;
  }


  
  var isFavorite = false.obs;

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }
}