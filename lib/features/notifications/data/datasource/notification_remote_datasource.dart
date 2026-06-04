import 'package:ekart/core/constants/api_constants.dart';
import 'package:ekart/core/network/api_services.dart';
import 'package:ekart/features/notifications/data/model/notification_model.dart';
import 'package:get_storage/get_storage.dart';

class NotificationRemoteDatasource {
  final ApiServices apiServices;
  NotificationRemoteDatasource(this.apiServices);

  Future<List<NotificationModel>> getNotifications() async {
    final userId = GetStorage().read('user_id');
    final apiResponse = await apiServices.getCall<List<NotificationModel>>(
      '${ApiConstants.notificationsEndpoint}?filters[user][id][\$eq]=$userId&sort=createdAt:desc',
      (json) {
        final List<dynamic> items = json['data'];
        return items.map((item) => NotificationModel.fromJson(item)).toList();
      },
    );

    if (apiResponse.success) return apiResponse.data!;
    throw Exception(apiResponse.message);
  }


  Future<void> markAsRead(String documentId) async {
    final apiResponse = await apiServices.putCall<void>(
      '${ApiConstants.notificationsEndpoint}/$documentId',
      {'data': {'isRead': true}},
      (json) {},
    );

    if (!apiResponse.success) throw Exception(apiResponse.message);
  }


  Future<void> markAllAsRead() async {
    final userId = GetStorage().read('user_id');

    // fetch unread ones first
    final apiResponse = await apiServices.getCall<List<NotificationModel>>(
      '${ApiConstants.notificationsEndpoint}?filters[user][id][\$eq]=$userId&filters[isRead][\$eq]=false',
      (json) {
        final List<dynamic> items = json['data'];
        return items.map((item) => NotificationModel.fromJson(item)).toList();
      },
    );

    if (!apiResponse.success) throw Exception(apiResponse.message);

    // mark each as read
    for (final n in apiResponse.data!) {
      await markAsRead(n.documentId);
    }
  }
}