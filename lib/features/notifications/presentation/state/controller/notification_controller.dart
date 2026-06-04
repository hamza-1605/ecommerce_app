import 'package:ekart/core/utils/helper_functions.dart';
import 'package:ekart/features/notifications/domain/entity/notification_entity.dart';
import 'package:ekart/features/notifications/domain/usecases/get_notification_usecase.dart';
import 'package:ekart/features/notifications/domain/usecases/mark_all_as_read_usecase.dart';
import 'package:ekart/features/notifications/domain/usecases/mark_as_read_usecase.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final GetNotificationsUsecase getNotificationsUsecase;
  final MarkAsReadUsecase markAsReadUsecase;
  final MarkAllAsReadUsecase markAllAsReadUsecase;

  NotificationController({
    required this.getNotificationsUsecase,
    required this.markAsReadUsecase,
    required this.markAllAsReadUsecase,
  });

  final RxList<NotificationEntity> notifications = <NotificationEntity>[].obs;
  final RxBool isLoading = false.obs;

  // unread count for badge
  int get unreadCount => notifications.where((n) => !n.isRead).length;


  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }


  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final result = await getNotificationsUsecase.call();
      notifications.assignAll(result);
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: HelperFunctions().msg(e),
        isError: true,
      );
    } 
    finally {
      isLoading.value = false;
    }
  }



  Future<void> markAsRead(String documentId) async {
    try {
      await markAsReadUsecase.call(documentId);
      final index = notifications.indexWhere((n) => n.documentId == documentId);
      if (index != -1) {
        final existing = notifications[index];
        notifications[index] = NotificationEntity(
          documentId:  existing.documentId,
          title:       existing.title,
          message:     existing.message,
          orderId:     existing.orderId,
          type:        existing.type,
          isRead:      true, // 👈 update locally
          createdAt:   existing.createdAt,
        );
        notifications.refresh();
      }
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: HelperFunctions().msg(e),
        isError: true,
      );
    }
  }



  Future<void> markAllAsRead() async {
    try {
      await markAllAsReadUsecase.call();
      final updated = notifications.map((n) => NotificationEntity(
        documentId:  n.documentId,
        title:       n.title,
        message:     n.message,
        orderId:     n.orderId,
        type:        n.type,
        isRead:      true,
        createdAt:   n.createdAt,
      )).toList();
      notifications.assignAll(updated);
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: HelperFunctions().msg(e),
        isError: true,
      );
    }
  }
}