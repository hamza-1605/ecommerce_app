// pages/product_list_page.dart
import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/features/products/presentation/state/controller/product_controller.dart';
import 'package:ecommerce/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListPage extends GetView<ProductController> {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.createProduct),
        child: const Icon(Icons.add),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        if (controller.products.isEmpty) {
          return const Center(child: Text('No products found.'));
        }
        
        return RefreshIndicator(
          onRefresh: controller.fetchProducts,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7, // controls height
              ),
              itemCount: controller.products.length,
              itemBuilder: (context, index) => ProductCard(
                product: controller.products[index],
                onTap: () {
                  controller.selectProduct(controller.products[index]);
                  Get.toNamed(AppRoutes.productDetail);
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}