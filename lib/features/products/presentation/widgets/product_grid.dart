import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/features/products/presentation/state/controller/product_controller.dart';
import 'package:ekart/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductGrid extends GetView<ProductController> {
  final String category;
  const ProductGrid({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final products = (category == 'All')
                        ? controller.filteredProducts
                        : controller.filteredProducts
                            .where( (p) => p.category == category)
                            .toList();

                            
      final screenWidth = MediaQuery.of(context).size.width;
      final itemWidth = (screenWidth - 16 * 2 - 15) / 2; // padding + spacing
      final itemHeight = itemWidth + 110; // 1:1 image + ~130px for info section
      final ratio = itemWidth / itemHeight;


      if (products.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.fetchProducts,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text(
                  'No $category products found',
                  style: AppTextStyles.bodyLarge,
                ),
              ],
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchProducts,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:   2,
            crossAxisSpacing: 15,
            mainAxisSpacing:  15,
            childAspectRatio: ratio,
          ),
          itemCount: products.length,
          itemBuilder: (_, i) => ProductCard(
            product: products[i],
            onTap: () {
              controller.selectProduct( products[i] );
              Get.toNamed( AppRoutes.productDetail );
            },
          ),
        ),
      );
    });
  }
}