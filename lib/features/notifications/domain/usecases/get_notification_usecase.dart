import 'package:ekart/features/notifications/domain/entity/notification_entity.dart';
import 'package:ekart/features/notifications/domain/repository/notification_repository.dart';

class GetNotificationsUsecase {
  final NotificationRepository notificationRepository;
  GetNotificationsUsecase(this.notificationRepository);
  
  Future<List<NotificationEntity>> call() => notificationRepository.getNotifications();
}