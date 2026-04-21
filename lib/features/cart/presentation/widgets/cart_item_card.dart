import 'package:ecommerce/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce/features/cart/presentation/state/controller/cart_controller.dart';
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [

          // ── Product Info ───────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs. ${item.price}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF888888),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Subtotal: Rs. ${item.subtotal}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),

          // ── Quantity Controls ──────────────────────
          Column(
            children: [
              // Remove button
              GestureDetector(
                onTap: () => cartController.removeItem(
                  itemDocumentId: item.documentId,
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                ),
              ),

              const SizedBox(height: 8),

              // Quantity stepper
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F6F3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => cartController.updateQuantity(
                        item:        item,
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
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
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