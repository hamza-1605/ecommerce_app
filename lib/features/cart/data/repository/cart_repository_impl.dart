import 'package:ekart/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:ekart/features/cart/data/models/cart_item_model.dart';
import 'package:ekart/features/cart/domain/entities/cart_entity.dart';
import 'package:ekart/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ekart/features/cart/domain/repository/cart_repository.dart';
import 'package:get_storage/get_storage.dart';

class CartRepositoryImpl implements CartRepository{
  final CartRemoteDatasource cartRemoteDatasource;
  CartRepositoryImpl(this.cartRemoteDatasource);


  @override
  Future<void> clearCart({required CartEntity cart}) async {
    return await cartRemoteDatasource.clearCart(cartDocumentId: cart.documentId);
  }


  @override
  Future<CartEntity> createCart({required int userId}) async {
    return await cartRemoteDatasource.createCart(userId: userId); 
  }


  @override
  Future<CartEntity> getCart({required int userId}) async {
    return await cartRemoteDatasource.getCart(userId: userId); 
  }

  
  // ---- ADD CART ITEM ----------------------------------------------------
  @override
  Future<CartEntity> addToCart({required CartEntity cart, required CartItemEntity item, required int userId}) async {
    // Check if product already exists in cart
    final existingIndex = cart.cartItems.indexWhere( (i) => i.productDocumentId == item.productDocumentId);
    List<CartItemModel> updatedItems;

    if (existingIndex != -1) {
      // ✅ Product exists — increase quantity
      updatedItems = cart.cartItems.map( (i) {
        if (i.productDocumentId == item.productDocumentId) {
          return CartItemModel(
            documentId:         i.documentId,
            productDocumentId:  i.productDocumentId,
            productName:        i.productName,
            price:              i.price,
            quantity:           i.quantity + item.quantity,
          );
        }
        return CartItemModel(
          documentId:         i.documentId,
          productDocumentId:  i.productDocumentId,
          productName:        i.productName,
          price:              i.price,
          quantity:           i.quantity,
        );
      }).toList();
    } 
    else {
      // ✅ New product — append to list
      updatedItems = [
        ...cart.cartItems.map( (i) => CartItemModel(
          documentId:         i.documentId,
          productDocumentId:  i.productDocumentId,
          productName:        i.productName,
          price:              i.price,
          quantity:           i.quantity,
        )),
        CartItemModel(
          documentId:          '',
          productDocumentId:   item.productDocumentId,
          productName:         item.productName,
          price:               item.price,
          quantity:            item.quantity,
        ),
      ];
    }

    final newTotal = _calculateTotal(updatedItems);

    await cartRemoteDatasource.updateCart(
      cartDocumentId: cart.documentId,
      cartItems:      updatedItems,
      total:          newTotal,
      userId:         userId,
    );

    // Refetch to get populated product details
    return await cartRemoteDatasource.getCart(
      userId: GetStorage().read('user_id'),
    );
  }
  
    
  // ---- UPDATE CART ITEM ----------------------------------------------------
  @override
  Future<CartEntity> updateCartItem({
    required CartEntity cart,
    required CartItemEntity updatedItem,
    required int userId,
  }) async {
    final updatedItems = cart.cartItems.map( (i) {
      if (i.productDocumentId == updatedItem.productDocumentId) {
        return CartItemModel(
          documentId:         i.documentId,
          productDocumentId:  i.productDocumentId,
          productName:        i.productName,
          price:              i.price,
          quantity:           updatedItem.quantity,
        );
      }
      return CartItemModel(
        documentId:           i.documentId,
        productDocumentId:    i.productDocumentId,
        productName:          i.productName,
        price:                i.price,
        quantity:             i.quantity,
      );
    }).toList();

    final newTotal = _calculateTotal(updatedItems);

    await cartRemoteDatasource.updateCart(
      cartDocumentId: cart.documentId,
      cartItems:      updatedItems,
      total:          newTotal,
      userId:         userId
    );

    return await cartRemoteDatasource.getCart(
      userId: GetStorage().read('user_id'),
    );
  }


  // ---- REMOVE CART ITEM ----------------------------------------------------
  @override
  Future<CartEntity> removeCartItem({
    required CartEntity cart,
    required String itemDocumentId,
    required int userId,
  }) async {
    final updatedItems = cart.cartItems
        .where((i) => i.documentId != itemDocumentId)
        .map((i) => CartItemModel(
              documentId:           i.documentId,
              productDocumentId:    i.productDocumentId,
              productName:          i.productName,
              price:                i.price,
              quantity:             i.quantity,
            ))
        .toList();

    final newTotal = _calculateTotal(updatedItems);

    await cartRemoteDatasource.updateCart(
      cartDocumentId: cart.documentId,
      cartItems:      updatedItems,
      total:          newTotal,
      userId:         userId,
    );

    return await cartRemoteDatasource.getCart(
      userId: GetStorage().read('user_id'),
    );
  }
  
  // ── Helper ─────────────────────────────────────────
  int _calculateTotal(List<CartItemModel> items) {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}