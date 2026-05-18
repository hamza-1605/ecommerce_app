import 'package:ekart/app/routes/app_routes.dart';
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

      final products = category == 'All'
                        ? controller.filteredProducts
                        : controller.filteredProducts
                            .where( (p) => p.category == category)
                            .toList();

      if (products.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                'No $category products found',
                style: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchProducts,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:   2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing:  12,
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