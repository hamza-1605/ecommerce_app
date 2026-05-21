import 'dart:io';
import 'package:ekart/core/network/api_services.dart';
import 'package:ekart/core/utils/helper_functions.dart';
import 'package:ekart/core/utils/validators.dart';
import 'package:ekart/features/products/domain/entities/product_entity.dart';
import 'package:ekart/features/products/domain/usecases/add_product_usecase.dart';
import 'package:ekart/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:ekart/features/products/domain/usecases/edit_product_usecase.dart';
import 'package:ekart/features/products/domain/usecases/get_products_usecase.dart';
import 'package:ekart/features/products/domain/usecases/update_stock_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {

  final GetProductsUsecase getProductsUsecase;
  final AddProductUsecase createProductUsecase;
  final EditProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;
  final UpdateStockUsecase updateStockUsecase;

  ProductController({
    required this.getProductsUsecase,
    required this.createProductUsecase,
    required this.updateProductUsecase,
    required this.deleteProductUsecase,
    required this.updateStockUsecase,
  });


  // ── State ──────────────────────────────────────────
  final RxList<ProductEntity> products = <ProductEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;   // for create/edit/delete actions
  final RxString errorMessage = ''.obs;
  final RxString selectedCategory = 'All'.obs;

  // selected product for detail/edit screen
  final Rx<ProductEntity?> selectedProduct = Rx<ProductEntity?>(null);

  final sortOption = ''.obs;
  final searchQuery = ''.obs;


  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void onClose() {
    searchTextController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }  

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  bool validateProduct(String itemName, int? price, int? stock, int? percent){
    final validationError = Validators.validateProduct(itemName: itemName, price: price, stock: stock, percent: percent);
    
    if(validationError != null){
      HelperFunctions.showSnackbar(
        title: "Validation Error", 
        message: validationError,
        isError: true
      );
      return true;
    }
    return false;
  }

  // ── READ ───────────────────────────────────────────
  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await getProductsUsecase.call();
      
      result.sort((a, b) => a.itemName.compareTo(b.itemName));
      products.assignAll(result);
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error', 
        message: HelperFunctions().msg(e), 
        isError: true, 
        duration: Duration(seconds: 10)
      );
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
      HelperFunctions.showSnackbar(title: 'Error', message: HelperFunctions().msg(e), isError: true, duration: Duration(seconds: 10));
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
      
      // Update selectedProduct with the fresh data from the refetched list
      final updated = products.firstWhereOrNull(
        (p) => p.documentId == product.documentId,
      );

      if (updated != null) {
        selectedProduct.value = null;
        selectedProduct.value = updated;
      }             
      Get.back();                          
      HelperFunctions.showSnackbar(title: 'Success', message: 'Product Updated Successfully');
    } 
    catch (e) {
      HelperFunctions.showSnackbar(title: 'Error', message: HelperFunctions().msg(e), isError: true, duration: Duration(seconds: 10));
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
      HelperFunctions.showSnackbar(title: 'Error', message: HelperFunctions().msg(e), isError: true, duration: Duration(seconds: 8));
    } 
    finally {
      isSubmitting.value = false;
    }
  }


  // ── HELPER ─────────────────────────────────────────
  void selectProduct(ProductEntity product) {
    selectedProduct.value = product;
  }
  
  
  // --------------------- Filtering Categories Issues -------------------------

  // ── Filtered products based on Category & Search ──
  List<ProductEntity> get filteredProducts {
    List<ProductEntity> result = List.from(products);

    // ── CATEGORY FILTER ─────────────────────
    if (selectedCategory.value != 'All') {
      result = result
          .where( (p) => p.category == selectedCategory.value )
          .toList();
    }

    // ── SEARCH FILTER ───────────────────────
    if (searchQuery.value.isNotEmpty) {
      result = result.where( (p) {
        return p.itemName
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
              (p.description ?? "")
                .toLowerCase()
                .contains(searchQuery);

      }).toList();
    }

    // ── SORTING ─────────────────────────────
    switch (sortOption.value) {
      case 'price_low_high':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;

      case 'price_high_low':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;

      case 'name_az':
        result.sort((a, b) => a.itemName.compareTo(b.itemName));
        break;

      default:
        result.sort((a, b) => a.itemName.compareTo(b.itemName));
        break;
    }

    return result;
  }


  // ── Get unique categories from fetched products ───
  List<String> get categories {
    final cats = products.map((p) => p.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];    // ✅ 'All' always first
  }


  void selectCategory(String category) {
    selectedCategory.value = category;
  }


  //  ---------------- Update Stock on Each Order ---------------------------
  Future<void> updateStock({
    required String documentId,
    required int    newQuantity,
  }) async {
    try {
      await updateStockUsecase.call(
        documentId:  documentId,
        newQuantity: newQuantity,
      );

      // ✅ Update locally so UI reflects immediately
      final index = products.indexWhere((p) => p.documentId == documentId);
      if (index != -1) {
        final existing = products[index];
        products[index] = ProductEntity(
          documentId:  existing.documentId,
          itemName:    existing.itemName,
          category:    existing.category,
          price:       existing.price,
          quantity:    newQuantity,
          description: existing.description,
          salePercent: existing.salePercent,
          imagesUrl:   existing.imagesUrl,
        );
        products.refresh();
      }
    } catch (e) {
      HelperFunctions.showSnackbar(
        title:   'Stock Update Error',
        message: HelperFunctions().msg(e),
        isError: true,
      );
    }
  }


  // Upload multiple images
  Future<List<int>?> uploadProductImages(List<File> imageFiles) async {
    try {
      final mediaIds = await ApiServices().uploadImages(imageFiles);
      return mediaIds;
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title:   'Upload Failed',
        message: HelperFunctions().msg(e),
        isError: true,
      );
      return null;
    }
  }


  // Delete Product Image
  Future<void> deleteProductImage({
    required ProductEntity product,
    required int           mediaId,
    required String        mediaUrl,
  }) async {
    isSubmitting.value = true;
    try {
      // 1. Remove from Strapi media library
      await ApiServices().deleteMedia(mediaId);

      // 2. Update product without that image
      final updatedImages = (product.imagesUrl ?? [])
          .where((img) => (img as Map)['id'] != mediaId)
          .toList();

      // 3. Get remaining image ids
      final remainingIds = updatedImages
          .map((img) => (img as Map)['id'] as int)
          .toList();

      // 4. Update product in Strapi
      await updateProductUsecase.call(ProductEntity(
        documentId:       product.documentId,
        itemName:         product.itemName,
        category:         product.category,
        price:            product.price,
        quantity:         product.quantity,
        description:      product.description,
        salePercent:      product.salePercent,
        imagesUrl:        updatedImages,
        uploadedImageIds: remainingIds,       // ✅ send remaining ids
      ));

      await fetchProducts();

      // ✅ Update selectedProduct
      final updated = products.firstWhereOrNull(
        (p) => p.documentId == product.documentId,
      );
      if (updated != null) {
        selectedProduct.value = null;
        selectedProduct.value = updated;
      }

      HelperFunctions.showSnackbar(
        title:   'Deleted',
        message: 'Image removed successfully',
      );
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title:   'Error',
        message: HelperFunctions().msg(e),
        isError: true,
      );
    } 
    finally {
      isSubmitting.value = false;
    }
  }



  // ----- Filtering and Sorting ---------------------------------------------
  void searchProducts(String query) {
    searchQuery.value = query;
  }

  void sortProducts(String option) {
    sortOption.value = option;
  }

}