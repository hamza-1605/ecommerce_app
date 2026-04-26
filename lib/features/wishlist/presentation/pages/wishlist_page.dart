import 'package:ecommerce/core/constants/api_constants.dart';
import 'package:ecommerce/features/wishlist/presentation/state/controller/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistPage extends GetView<WishlistController> {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F6F3),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
          ),
        ),
        title: const Text('My Favourites',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          )),
        actions: [
          Obx(() => controller.items.isNotEmpty
            ? TextButton.icon(
                onPressed: () => _confirmClear(context),
                icon: const Icon(Icons.delete_outline,
                    color: Colors.red, size: 18),
                label: const Text('Clear',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  )),
              )
            : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border_rounded,
                    size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text('No favourites yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF888888),
                  )),
                const SizedBox(height: 8),
                const Text('Tap the heart on any product to save it',
                  style: TextStyle(color: Color(0xFFBBBBBB))),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: controller.items.length,
          itemBuilder: (_, i) {
            final item = controller.items[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
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

                  // ── Image ────────────────────────
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 64, height: 64,
                      color: const Color(0xFFF8F6F3),
                      child: item.imagesUrl != null &&
                              item.imagesUrl!.isNotEmpty
                          ? Image.network(
                              ApiConstants.baseUrl +
                                  (item.imagesUrl!.first['url'] as String),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.inventory_2_outlined,
                                color: Color(0xFFBBBBBB),
                              ),
                            )
                          : const Icon(
                              Icons.inventory_2_outlined,
                              color: Color(0xFFBBBBBB),
                            ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // ── Info ─────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.itemName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          )),
                        const SizedBox(height: 4),
                        Text(item.category ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF888888),
                          )),
                        const SizedBox(height: 4),
                        Text('Rs. ${item.price}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                          )),
                      ],
                    ),
                  ),

                  // ── Remove ───────────────────────
                  GestureDetector(
                    onTap: () => controller.removeItem(item.documentId),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.favorite_rounded,
                          color: Colors.red.shade400, size: 18),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Favourites',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Remove all items from your favourites?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF888888))),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearWishlist();
            },
            child: const Text('Clear',
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}