import 'package:ekart/features/orders/domain/entities/order_entity.dart';
import 'package:ekart/features/orders/presentation/state/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogDeleteOrder extends StatelessWidget {
  const DialogDeleteOrder({super.key, required this.order});
  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Delete Order', style: TextStyle(fontWeight: FontWeight.w700)),
      content: const Text('Remove this cancelled order from your history?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('No', style: TextStyle(color: Color(0xFF888888))),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            Get.find<OrderController>().deleteOrder(documentId: order.documentId);
          },
          child: const Text('Delete',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}