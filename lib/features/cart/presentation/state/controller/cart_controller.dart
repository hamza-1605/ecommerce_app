import 'package:ekart/core/utils/helper_functions.dart';
import 'package:ekart/features/cart/data/models/cart_item_model.dart';
import 'package:ekart/features/cart/domain/entities/cart_entity.dart';
import 'package:ekart/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ekart/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:ekart/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:ekart/features/cart/domain/usecases/create_cart_usecase.dart';
import 'package:ekart/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:ekart/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:ekart/features/cart/domain/usecases/update_cart_usecase.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartController extends GetxController {
  final GetCartUsecase         getCartUsecase;
  final CreateCartUsecase      createCartUsecase;
  final AddToCartUsecase       addToCartUsecase;
  final UpdateCartUsecase      updateCartItemUsecase;
  final RemoveFromCartUsecase  removeCartItemUsecase;
  final ClearCartUsecase       clearCartUsecase;

  CartController({
    required this.getCartUsecase,
    required this.createCartUsecase,
    required this.addToCartUsecase,
    required this.updateCartItemUsecase,
    required this.removeCartItemUsecase,
    required this.clearCartUsecase,
  });

  // ── State ──────────────────────────────────────────
  final Rx<CartEntity?> cart         = Rx<CartEntity?>(null);
  final RxBool          isLoading    = false.obs;
  final RxBool          isSubmitting = false.obs;

  int get userId => GetStorage().read('user_id');

  // ── Computed ───────────────────────────────────────
  int get itemCount  => cart.value?.cartItems.length ?? 0;
  int get cartTotal  => cart.value?.total ?? 0;
  bool get isEmpty   => cart.value == null || cart.value!.cartItems.isEmpty;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }


  // ── FETCH ───────────────────────────────────────────
  Future<void> fetchCart() async {
    isLoading.value = true;
    try {
      final result = await getCartUsecase.call(userId: userId);
      cart.value = result;
    } 
    catch (e) {
      if (e.toString().contains('Cart not found')) {
        await _createEmptyCart();             // auto-create if missing
      } 
      else {
        HelperFunctions.showSnackbar(
          title: 'Error',
          message: e.toString(),
          isError: true,
        );
      }
    } 
    finally {
      isLoading.value = false;
    }
  }


  // ── CREATE NEW CART ─────────────────────────────────────
  Future<void> _createEmptyCart() async {
    try {
      final result = await createCartUsecase.call(userId: userId);
      cart.value = result;
    } catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: 'Could not create cart: $e',
        isError: true,
      );
    }
  }


  // ── ADD TO CART ─────────────────────────────────────
  Future<void> addToCart({required CartItemEntity item}) async {
    if (cart.value == null) return;
    isSubmitting.value = true;

    try {
      final result = await addToCartUsecase.call(
        cart: cart.value!,
        item: item,
        userId: userId
      );
      cart.value = null;
      cart.value = result;
      
      HelperFunctions.showSnackbar(
        title: 'Success',
        message: '${item.productName} added to cart',
      );
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: '$e',
        isError: true,
      );
    } 
    finally {
      isSubmitting.value = false;
    }
  }


  // ── UPDATE QUANTITY ─────────────────────────────────
  Future<void> updateQuantity({
    required CartItemEntity item,
    required int newQuantity,
  }) async {
    if (cart.value == null) return;
    if (newQuantity < 1) {
      await removeItem(itemDocumentId: item.documentId);
      return;
    }

    isSubmitting.value = true;
    try {
      final updatedItem = CartItemModel(
        documentId:        item.documentId,
        productDocumentId: item.productDocumentId,
        productName:       item.productName,
        price:             item.price,
        quantity:          newQuantity,
      );

      final result = await updateCartItemUsecase.call(
        cart:        cart.value!,
        updatedItem: updatedItem,
        userId: userId
      );
      cart.value = null;
      cart.value = result;
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: e.toString(),
        isError: true,
      );
    } 
    finally {
      isSubmitting.value = false;
    }
  }


  // ── REMOVE ITEM ─────────────────────────────────────
  Future<void> removeItem({required String itemDocumentId}) async {
    if (cart.value == null) return;
    isSubmitting.value = true;

    try {
      final result = await removeCartItemUsecase.call(
        cart:           cart.value!,
        itemDocumentId: itemDocumentId,
        userId: userId
      );
      cart.value = null;
      cart.value = result;
      HelperFunctions.showSnackbar(
        title: 'Removed',
        message: 'Item removed from cart',
      );
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: e.toString(),
        isError: true,
      );
    } 
    finally {
      isSubmitting.value = false;
    }
  }


  // ── CLEAR CART ──────────────────────────────────────
  Future<void> clearCart() async {
    if (cart.value == null) return;
    isSubmitting.value = true;

    try {
      await clearCartUsecase.call(cart: cart.value!);
      await fetchCart();                    // refetch to get fresh empty cart
      HelperFunctions.showSnackbar(
        title: 'Cart Cleared',
        message: 'All items removed',
      );
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: e.toString(),
        isError: true,
      );
    } 
    finally {
      isSubmitting.value = false;
    }
  }
}