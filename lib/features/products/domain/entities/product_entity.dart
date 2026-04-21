class ProductEntity{
  final String? documentId;
  final String itemName;
  final String category;
  final int price;
  final int quantity;
  final String? description;
  final List< Map<dynamic, dynamic>>? imagesUrl;
  int? salePercent;

  ProductEntity({
    this.documentId, 
    required this.itemName, 
    this.description, 
    required this.category, 
    required this.price, 
    required this.quantity, 
    this.imagesUrl,
    this.salePercent
  });
}