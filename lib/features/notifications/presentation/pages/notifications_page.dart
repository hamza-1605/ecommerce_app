import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/core/widgets/background_svg.dart';
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/features/notifications/presentation/state/controller/notification_controller.dart';
import 'package:ekart/features/notifications/presentation/widgets/notfication_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsPage extends GetView<NotificationController> {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 70),
        child: CustomizedAppbar(
          title: 'Notifications',
          backButton: true,
          anyWidget: Obx(() => controller.unreadCount > 0
            ? TextButton(
                onPressed: controller.markAllAsRead,
                child: Text(
                  'Mark all as read',
                  style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                ),
              )
            : const SizedBox.shrink()),
        ),
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          BackgroundSvg(),
          
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
          
            if (controller.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_none_rounded, size: 72, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    const Text(
                      'No notifications yet',
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Order updates will appear here',
                      style: AppTextStyles.labelMedium,
                    ),
                  ],
                ),
              );
            }
          
            return RefreshIndicator(
              onRefresh: controller.fetchNotifications,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.notifications.length,
                itemBuilder: (context, index) {
                  return NotificationCard(
                    notification: controller.notifications[index],
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}