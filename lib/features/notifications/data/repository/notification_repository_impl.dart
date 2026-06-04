import 'package:ekart/features/notifications/data/datasource/notification_remote_datasource.dart';
import 'package:ekart/features/notifications/domain/entity/notification_entity.dart';
import 'package:ekart/features/notifications/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource datasource;
  NotificationRepositoryImpl(this.datasource);

  @override
  Future<List<NotificationEntity>> getNotifications() => datasource.getNotifications();

  @override
  Future<void> markAsRead(String documentId) => datasource.markAsRead(documentId);

  @override
  Future<void> markAllAsRead() => datasource.markAllAsRead();
}