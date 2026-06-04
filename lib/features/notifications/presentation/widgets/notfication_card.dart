// import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/features/notifications/domain/entity/notification_entity.dart';
import 'package:ekart/features/notifications/presentation/state/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends GetView<NotificationController> {
  const NotificationCard({super.key, required this.notification});
  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // mark as read
        if (!notification.isRead) {
          controller.markAsRead(notification.documentId);
        }
        // navigate to orders
        // Get.toNamed(AppRoutes.orders);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: AppDecorations.containerDecoration.copyWith(
          color: notification.isRead ? Colors.white : const Color.fromARGB(255, 255, 237, 227),
          border: Border.all(
            color: notification.isRead
              ? const Color(0xFFF0EEEB)
              : AppColors.appMainColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon ────────────────────────────
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(_icon, color: _iconColor, size: 20),
            ),

            const SizedBox(width: 12),

            // ── Content ──────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      // unread dot
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.appMainColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: AppTextStyles.labelSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timeago.format(notification.createdAt),
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Utils for Notfication Card
  IconData get _icon {
    switch (notification.type) {
      case 'order_created':   return Icons.shopping_bag_outlined;
      case 'cancelled':      return Icons.cancel_outlined;
      case 'status_changed': return Icons.local_shipping_outlined;
      default:               return Icons.notifications_outlined;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case 'order_created':   return AppColors.success;
      case 'status_changed':  return AppColors.appMainColor;
      case 'cancelled':       return AppColors.error;
      default:                return AppColors.textSecondary;
    }
  }

  Color get _iconBg {
    switch (notification.type) {
      case 'order_created':  return const Color(0xFFE8F5E9);
      case 'status_changed': return const Color(0xFFFFEDE0);
      case 'cancelled':      return const Color(0xFFFFEBEE);
      default:               return const Color(0xFFF2F0ED);
    }
  }
}