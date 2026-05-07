class ProductEntity{
  final String? documentId;
  final String itemName;
  final String category;
  final int price;
  final int quantity;
  final String? description;
  int? salePercent;
  final List<dynamic>? imagesUrl;          // existing images from Strapi
  final List<int>?     uploadedImageIds;   // new — media ids after upload

  ProductEntity({
    this.documentId, 
    required this.itemName, 
    this.description, 
    required this.category, 
    required this.price, 
    required this.quantity, 
    this.salePercent,
    this.imagesUrl,
    this.uploadedImageIds
  });
}