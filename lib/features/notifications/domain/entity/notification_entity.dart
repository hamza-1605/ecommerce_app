class NotificationEntity {
  final String documentId;
  final String title;
  final String message;
  final String orderId;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.documentId,
    required this.title,
    required this.message,
    required this.orderId,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });
}