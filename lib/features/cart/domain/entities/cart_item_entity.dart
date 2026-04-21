class CartItemEntity {
  final String documentId;
  final String productDocumentId;
  final String productName;
  final int quantity;
  final int price;

  CartItemEntity({
    required this.documentId, 
    required this.productDocumentId, 
    required this.productName, 
    required this.quantity, 
    required this.price
  });

  int get subtotal => price * quantity;
}