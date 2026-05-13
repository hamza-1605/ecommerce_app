import 'package:ekart/core/utils/helper_functions.dart';
import 'package:ekart/features/products/domain/entities/product_entity.dart';
import 'package:ekart/features/wishlist/data/datasource/wishlist_local_datasource.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  final WishlistLocalDatasource datasource;
  WishlistController({required this.datasource});

  final RxList<ProductEntity> items     = <ProductEntity>[].obs; 
  final RxBool            isLoading     = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  // ── LOAD ───────────────────────────────────────────
  Future<void> loadWishlist() async {
    isLoading.value = true;
    try {
      final result = await datasource.getWishlist();
      items.assignAll(result);
    } 
    finally {
      isLoading.value = false;
    }
  }

  // ── TOGGLE ─────────────────────────────────────────
  Future<void> toggleWishlist(ProductEntity product) async {
    final isAlready = isWishlisted(product.documentId!);

    if (isAlready) {
      await datasource.removeFromWishlist(product.documentId!);
      items.removeWhere((i) => i.documentId == product.documentId);
      
      HelperFunctions.showSnackbar(
        title:   'Removed',
        message: '${product.itemName} removed from favourites',
      );
    } 
    else {
      await datasource.addToWishlist(product);
      items.add(product);
      
      HelperFunctions.showSnackbar(
        title:   'Added',
        message: '${product.itemName} added to favourites',
      );
    }
  }


  // ── REMOVE ─────────────────────────────────────────
  Future<void> removeItem(String documentId) async {
    await datasource.removeFromWishlist(documentId);
    items.removeWhere((i) => i.documentId == documentId);
  }

  // ── CLEAR ──────────────────────────────────────────
  Future<void> clearWishlist() async {
    await datasource.clearWishlist();
    items.clear();
  }

  // ── CHECK ──────────────────────────────────────────
  bool isWishlisted(String documentId) {
    return items.any( (i) => i.documentId == documentId );
  }
}