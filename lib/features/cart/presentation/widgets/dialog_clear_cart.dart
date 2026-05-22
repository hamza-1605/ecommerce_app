import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/features/cart/presentation/state/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogClearCart extends StatelessWidget {
  const DialogClearCart({super.key, required this.controller});
  final CartController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cart?', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to remove all items from the cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: AppTextStyles.labelMedium),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearCart();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
    );
  }
}