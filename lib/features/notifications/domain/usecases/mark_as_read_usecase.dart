import 'package:ekart/features/notifications/domain/repository/notification_repository.dart';

class MarkAsReadUsecase {
  final NotificationRepository notificationRepository;
  MarkAsReadUsecase(this.notificationRepository);
  
  Future<void> call(String documentId) => notificationRepository.markAsRead(documentId);
}