import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/core/constants/api_constants.dart';
import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/core/widgets/background_svg.dart';
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/features/products/presentation/state/controller/product_controller.dart';
import 'package:ekart/features/wishlist/presentation/state/controller/wishlist_controller.dart';
import 'package:ekart/features/wishlist/presentation/widgets/dialog_clear_favourites.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistPage extends GetView<WishlistController> {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70), 
        child: CustomizedAppbar(title: "My Favourites", backButton: true),
      ),
      
      body: Stack( 
        fit: StackFit.expand,
        alignment: AlignmentGeometry.center,
        children: [
          BackgroundSvg(),
          
          SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child:  Column(
                children: [
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Expanded(child: const Center(child: CircularProgressIndicator()));
                    }
              
                    // No favourites Saved
                    if (controller.items.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.favorite_border_rounded, size: 80),
                                const SizedBox(height: 16),
                                const Text('No Favourites saved.', style: AppTextStyles.bodyMedium),
                                const SizedBox(height: 8),
                                const Text('Tap the heart on any product to save it',  style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        itemCount: controller.items.length,
                        itemBuilder: (_, i) {
                          final item = controller.items[i];
                          return GestureDetector(
                            onTap: () { 
                              Get.find<ProductController>().selectedProduct.value = item ;
                              Get.toNamed( AppRoutes.productDetail );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: AppDecorations.containerDecoration,
                              child: Row(
                                children: [
                                  // ── Image ────────────────────────
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: 64, height: 64,
                                      child: item.imagesUrl != null && item.imagesUrl!.isNotEmpty
                                          ? Image.network( 
                                              ApiConstants.baseUrl + (item.imagesUrl!.first['url'] as String),
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.inventory_2_outlined),
                                            )
                                          : const Icon(Icons.inventory_2_outlined),
                                    ),
                                  ),
                                      
                                  const SizedBox(width: 16),
                                      
                                  // ── Info ─────────────────────────
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.itemName, style: AppTextStyles.titleMedium),
                                        const SizedBox(height: 4),
                                        Text(item.category, style: AppTextStyles.labelMedium),
                                        const SizedBox(height: 4),
                                        Text('Rs. ${item.price}', style: AppTextStyles.titleSmall),
                                      ],
                                    ),
                                  ),
                                      
                                  // ── Remove ───────────────────────
                                  GestureDetector(
                                    onTap: () => controller.removeItem(item.documentId!),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: AppDecorations.favIconDecoration,
                                      child: Icon(Icons.favorite_rounded, color: Colors.red, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),

                  // Clear Button
                  Obx(() => controller.items.isNotEmpty
                    ? TextButton.icon(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => DialogClearFavourites(controller: controller),
                        ),
                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 24),
                        label: const Text('Clear Favourites',
                          style: AppTextStyles.labelLargeRed
                        ),
                      )
                    : const SizedBox.shrink(),
                  ),
                ],
              ),
          ),
        ),
      ])
    );
  }
}