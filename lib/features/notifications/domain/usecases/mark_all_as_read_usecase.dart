import 'package:ekart/features/notifications/domain/repository/notification_repository.dart';

class MarkAllAsReadUsecase {
  final NotificationRepository notificationRepository;
  MarkAllAsReadUsecase(this.notificationRepository);

  Future<void> call() => notificationRepository.markAllAsRead();
}