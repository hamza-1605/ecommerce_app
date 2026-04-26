import 'dart:convert';
import 'package:ecommerce/features/wishlist/domain/entity/wishlist_item_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistLocalDatasource {
  static const _key = 'wishlist_items';

  Future<List<WishlistItemEntity>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw   = prefs.getStringList(_key) ?? [];
    return raw
        .map((item) => WishlistItemEntity.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> addToWishlist(WishlistItemEntity item) async {
    final prefs   = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];

    // ✅ Avoid duplicates
    final exists = current.any((e) {
      final decoded = jsonDecode(e) as Map<String, dynamic>;
      return decoded['documentId'] == item.documentId;
    });

    if (!exists) {
      current.add(jsonEncode(item.toJson()));
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

  Future<bool> isWishlisted(String documentId) async {
    final prefs   = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];
    return current.any((e) {
      final decoded = jsonDecode(e) as Map<String, dynamic>;
      return decoded['documentId'] == documentId;
    });
  }

  Future<void> clearWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}