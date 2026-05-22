import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/features/wishlist/presentation/state/controller/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogClearFavourites extends StatelessWidget {
  const DialogClearFavourites({super.key, required this.controller});
  final WishlistController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Clear Favourites', style: AppTextStyles.titleLarge),
      content: const Text('Remove all items from your favourites?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel', style: AppTextStyles.labelMedium),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            controller.clearWishlist();
          },
          child: const Text('Clear', style: AppTextStyles.labelLargeRed ),
        ),
      ],
    );
  }
}