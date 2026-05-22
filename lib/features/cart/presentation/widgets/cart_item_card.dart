import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ekart/features/cart/presentation/state/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;
  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.containerDecoration,
      child: Row(
        children: [
          // ── Product Info ───────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs. ${item.price}',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Subtotal: Rs. ${item.subtotal}',
                  style: AppTextStyles.titleSmall,
                ),
              ],
            ),
          ),


          // ── Quantity Controls ──────────────────────
          Column(
            children: [
              // Remove button
              GestureDetector(
                onTap: () => cartController.removeItem( itemDocumentId: item.documentId ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                ),
              ),

              const SizedBox(height: 8),

              // Quantity stepper
              Container(
                decoration: AppDecorations.containerDecoration.copyWith(border: Border.all(color: Colors.black12, width: 0.5)),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => cartController.updateQuantity(
                        item: item,
                        newQuantity: item.quantity - 1,
                      ),
                      icon: const Icon(Icons.remove, size: 16),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${item.quantity}',
                        style: AppTextStyles.titleMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: () => cartController.updateQuantity(
                        item:        item,
                        newQuantity: item.quantity + 1,
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}