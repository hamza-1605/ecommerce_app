import 'dart:convert';
import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistLocalDatasource {
  static const _key = 'wishlist_items';

  Future<List<ProductEntity>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw   = prefs.getStringList(_key) ?? [];

    return raw.map((item) {
      final json = jsonDecode(item) as Map<String, dynamic>;
      return ProductEntity(
        documentId:  json['documentId'],
        itemName:    json['itemName'],
        price:       json['price'],
        category:    json['category'],
        quantity:    json['quantity'] ?? 0,
        description: json['description'],
        salePercent: json['salePercent'],
        imagesUrl:   json['imagesUrl'] != null
                     ? List<dynamic>.from(json['imagesUrl'])
                     : null,
      );
    }).toList();
  }


  Future<void> addToWishlist(ProductEntity product) async {
    final prefs   = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];

    // Avoid duplicates
    final exists = current.any((e) {
      final decoded = jsonDecode(e) as Map<String, dynamic>;
      return decoded['documentId'] == product.documentId;
    });

    if (!exists) {
      current.add(jsonEncode(_productToJson(product)));
      await prefs.setStringList(_key, current);
    }
  }


  Future<void> removeFromWishlist(String documentId) async {
    final prefs   = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];
    current.removeWhere((e) {
      final decoded = jsonDecode(e) as Map<String, dynamic>;
      return decoded['documentId'] == documentId;
    });
    await prefs.setStringList(_key, current);
  }


  Future<void> clearWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }


  //  Convert ProductEntity to JSON-safe Map
  Map<String, dynamic> _productToJson(ProductEntity product) {
    return {
      'documentId':  product.documentId,
      'itemName':    product.itemName,
      'price':       product.price,
      'category':    product.category,
      'quantity':    product.quantity,
      'description': product.description,
      'salePercent': product.salePercent,
      // ✅ imagesUrl contains Maps — encode them properly
      'imagesUrl':   product.imagesUrl?.map((img) {
        if (img is Map) {
          return {
            'url': img['url'],
            'id':  img['id'],
          };
        }
        return img;
      }).toList(),
    };
  }
}