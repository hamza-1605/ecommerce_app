import 'package:ekart/features/notifications/data/datasource/notification_remote_datasource.dart';
import 'package:ekart/features/notifications/data/repository/notification_repository_impl.dart';
import 'package:ekart/features/notifications/domain/repository/notification_repository.dart';
import 'package:ekart/features/notifications/domain/usecases/get_notification_usecase.dart';
import 'package:ekart/features/notifications/domain/usecases/mark_all_as_read_usecase.dart';
import 'package:ekart/features/notifications/domain/usecases/mark_as_read_usecase.dart';
import 'package:ekart/features/notifications/presentation/state/controller/notification_controller.dart';
import 'package:get/get.dart';

class NotificationBindings extends Bindings{
  @override
  void dependencies() {
    // Datasource
    Get.lazyPut( () => NotificationRemoteDatasource( Get.find() ) );
    
    // Repository
    Get.lazyPut<NotificationRepository>( 
      () => NotificationRepositoryImpl( Get.find() ) 
    );

    // Usecases
    Get.lazyPut( () => GetNotificationsUsecase( Get.find() ) );
    Get.lazyPut( () => MarkAllAsReadUsecase( Get.find() ) );
    Get.lazyPut( () => MarkAsReadUsecase( Get.find() ) );

    // Controller
    Get.lazyPut(() => NotificationController(
      getNotificationsUsecase: Get.find(), 
      markAsReadUsecase: Get.find(), 
      markAllAsReadUsecase: Get.find()
    ) );
  }
}