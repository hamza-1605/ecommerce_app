import 'package:ecommerce/features/products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity{
  ProductModel({
    super.documentId, 
    required super.itemName, 
    required super.category, 
    required super.price, 
    required super.quantity, 
    super.description, 
    super.salePercent,
    super.imagesUrl,
    super.uploadedImageIds, 
  });


  factory ProductModel.fromJson( Map<String, dynamic> json ){
    return ProductModel(
      documentId: json['documentId'], 
      itemName: json['itemName'], 
      category: json['category'], 
      price: (json['price'] as num).toInt(), 
      description: json['description'],  
      salePercent: (json['salePercent']),
      quantity: json['quantity'],
      imagesUrl: json['imagesUrl'] != null 
                ? List< Map<dynamic, dynamic>>.from( json['imagesUrl'] ) 
                : [],
    );
  }
}