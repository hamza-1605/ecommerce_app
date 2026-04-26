import 'package:ecommerce/features/products/domain/entities/product_entity.dart';

class WishlistItemEntity {
  final String        documentId;
  final String        itemName;
  final int           price;
  final String?       category;
  final List<dynamic>? imagesUrl;

  WishlistItemEntity({
    required this.documentId,
    required this.itemName,
    required this.price,
    this.category,
    this.imagesUrl,
  });

  // ✅ Convert to/from JSON for SharedPreferences storage
  Map<String, dynamic> toJson() => {
    'documentId': documentId,
    'itemName':   itemName,
    'price':      price,
    'category':   category,
  };

  factory WishlistItemEntity.fromJson(Map<String, dynamic> json) {
    return WishlistItemEntity(
      documentId: json['documentId'],
      itemName:   json['itemName'],
      price:      json['price'],
      category:   json['category'],
    );
  }

  // ✅ Create from ProductEntity
  factory WishlistItemEntity.fromProduct(ProductEntity product) {
    return WishlistItemEntity(
      documentId: product.documentId!,
      itemName:   product.itemName,
      price:      product.price,
      category:   product.category,
      imagesUrl:  product.imagesUrl,
    );
  }
}