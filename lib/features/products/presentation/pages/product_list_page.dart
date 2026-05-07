import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/features/products/presentation/state/controller/product_controller.dart';
import 'package:ecommerce/features/products/presentation/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProductListPage extends GetView<ProductController> {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = controller.categories;
    final isAdmin = GetStorage().read('user_is_admin') ?? false;

      return DefaultTabController(
        length: categories.length,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F6F3),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF8F6F3),
            elevation: 0,
            title: const Text(
              'Shop',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                color: Color(0xFF1A1A1A),
              ),
            ),

            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: const Color(0xFF1A1A1A),
                  unselectedLabelColor: const Color(0xFF888888),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  indicator: UnderlineTabIndicator(
                    borderSide: const BorderSide(
                      width: 2.5,
                      color: Color(0xFF1A1A1A),
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  onTap: (index) =>
                      controller.selectCategory(categories[index]),
                  tabs: categories
                      .map((cat) => Tab(text: cat))
                      .toList(),
                ),
              ),
            ),
          ),

          body: TabBarView(
            children: categories.map( (cat) =>
              ProductGrid( category: cat ),
            ).toList(),
          ),

          floatingActionButton: isAdmin 
          ? FloatingActionButton(
              onPressed: () => Get.toNamed(AppRoutes.createProduct),
              child: Icon(Icons.add),
            ) 
          : null,
        ),
      );
    });
  }
}

// ── Product Grid per tab ────────────────────────────
