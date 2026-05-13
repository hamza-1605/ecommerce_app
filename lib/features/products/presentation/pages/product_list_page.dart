import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/features/products/presentation/state/controller/product_controller.dart';
import 'package:ekart/features/products/presentation/widgets/product_grid.dart';
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
        child: GestureDetector(
          onTap: () => controller.searchFocusNode.unfocus(),
          child: Scaffold(
            backgroundColor: const Color(0xFFF8F6F3),
            appBar: AppBar(
              backgroundColor: const Color(0xFFF8F6F3),
              elevation: 0,
          
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Column(
                  children: [
                    // SEARCH + SORT
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
          
                          Expanded(
                            child: TextField(
                              autofocus: false,
                              controller: controller.searchTextController,
                              focusNode: controller.searchFocusNode,
                              onChanged: controller.searchProducts,
                              decoration: InputDecoration(
                                hintText: 'Search products...',
                                hintStyle: TextStyle(
                                  letterSpacing: -0.3
                                ),
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: controller.searchQuery.value.isNotEmpty
                                  ? IconButton(
                                      onPressed: (){
                                        controller.searchQuery.value = '';
                                        controller.searchTextController.clear();
                                        controller.searchFocusNode.unfocus();
                                      }, 
                                      icon: Icon(Icons.close_rounded)
                                    ) 
                                  : null,
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
          
                          const SizedBox(width: 10),
          
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.sort),
                            onSelected: controller.sortProducts,
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'price_low_high',
                                child: Text('Price: Low to High'),
                              ),
                              const PopupMenuItem(
                                value: 'price_high_low',
                                child: Text('Price: High to Low'),
                              ),
                              const PopupMenuItem(
                                value: 'name_az',
                                child: Text('Name: A-Z'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
          
                    const SizedBox(height: 10),
          
                    // TABS
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: const Color(0xFF1A1A1A),
                        unselectedLabelColor: const Color(0xFF888888),
                        onTap: (index) => controller.selectCategory(categories[index]),
                        tabs: categories
                            .map((cat) => Tab(text: cat))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
            body: TabBarView(
              children: categories.map(
                (category) => ProductGrid(category: category),
              ).toList(),
            ),
          
            floatingActionButton: isAdmin 
            ? FloatingActionButton(
                onPressed: () => Get.toNamed(AppRoutes.createProduct),
                child: Icon(Icons.add),
              ) 
            : null,
          ),
        ),
      );
    });
  }
}
