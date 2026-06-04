import 'package:ekart/features/notifications/domain/entity/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications();

  Future<void> markAsRead(String documentId);
  
  Future<void> markAllAsRead();
}