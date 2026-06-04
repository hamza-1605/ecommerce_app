import 'package:ekart/features/notifications/domain/entity/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.documentId,
    required super.title,
    required super.message,
    required super.orderId,
    required super.type,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      documentId: json['documentId'],
      title:      json['title']   ?? '',
      message:    json['message']    ?? '',
      orderId:    json['orderId'] ?? '',
      type:       json['type']    ?? '',
      isRead:     json['isRead']  ?? false,
      createdAt:  DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'isRead': isRead,
  };
}