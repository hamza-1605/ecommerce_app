class OrderItemEntity {
  final String productDocumentId;
  final String productName;
  final int    price;
  final int    quantity;

  OrderItemEntity({
    required this.productDocumentId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  int get subtotal => price * quantity;
}