import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/features/orders/domain/entities/order_entity.dart';
import 'package:ekart/features/orders/presentation/state/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogCancelOrder extends StatelessWidget {
  const DialogCancelOrder({super.key, required this.order});
  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Cancel Order', style: TextStyle(fontWeight: FontWeight.w700)),
      content: const Text('Are you sure you want to cancel this order?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('No', style: AppTextStyles.bodyMedium ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            Get.find<OrderController>().updateOrder(
              documentId: order.documentId,
              orderStatus: 'cancelled',
            );
          },
          child: Text('Yes, Cancel', style: AppTextStyles.titleMedium.copyWith(color: Colors.red) ),
        ),
      ],
    );
  }
}