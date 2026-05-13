import 'package:ekart/core/constants/api_constants.dart';
import 'package:ekart/core/network/api_services.dart';
import 'package:ekart/features/cart/data/models/cart_item_model.dart';
import 'package:ekart/features/cart/data/models/cart_model.dart';

class CartRemoteDatasource {
  final ApiServices apiServices;
  CartRemoteDatasource({required this.apiServices});

  // ── GET CART ───────────────────────────────────────
  Future<CartModel> getCart({required int userId}) async {
    final apiResponse = await apiServices.getCall<CartModel>(
      '${ApiConstants.cartEndpoint}?filters[user][id][\$eq]=$userId&populate[cartItems][populate]=product',
      
      (json) {
        final List<dynamic> items = json['data'];
        if (items.isEmpty) throw Exception('Cart not found');
        return CartModel.fromJson(items.first);
      },
    );

    if (apiResponse.success) {
      return apiResponse.data!;
    } else {
      throw Exception(apiResponse.message);
    }
  }


  // ── CREATE CART ────────────────────────────────────
  Future<CartModel> createCart({required int userId}) async {
    final apiResponse = await apiServices.postCall<CartModel>(
      ApiConstants.cartEndpoint,
      {
        "data": {
          "user":      userId,
          "cartItems": [],
          "total":     0,
        }
      },
      (json) => CartModel.fromJson(json['data']),
    );

    if (apiResponse.success) {
      return apiResponse.data!;
    } else {
      throw Exception(apiResponse.message);
    }
  }


  // ── UPDATE CART ────────────────────────────────────
  // Single method for add, update quantity, remove, clear
  // We always send the full updated cartItems list to Strapi
  Future<CartModel> updateCart({
    required int userId,
    required String cartDocumentId,
    required List<CartItemModel> cartItems,
    required int total,
  }) async {
    final body = {
      "data": {
        "cartItems": cartItems.map((item) => item.toJson()).toList(),
        "total":     total,
      }
    };

    final apiResponse = await apiServices.putCall<CartModel>(
      '${ApiConstants.cartEndpoint}/$cartDocumentId',
      body,
      (json) async {
        // Strapi PUT response doesn't populate relations
        // So refetch the cart to get full product details
        return await getCart(userId: userId);   // placeholder — handled in repository
      },
    );

    if (apiResponse.success) {
      return apiResponse.data!;
    } else {
      throw Exception(apiResponse.message);
    }
  }


  // ── CLEAR CART ─────────────────────────────────────
  Future<void> clearCart({required String cartDocumentId}) async {
    final apiResponse = await apiServices.putCall<void>(
      '${ApiConstants.cartEndpoint}/$cartDocumentId',
      {
        "data": {
          "cartItems": [],
          "total":     0,
        }
      },
      (json) {},
    );

    if (!apiResponse.success) {
      throw Exception(apiResponse.message);
    }
  }
}