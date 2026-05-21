import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/features/products/presentation/state/controller/product_controller.dart';
import 'package:ekart/features/products/presentation/widgets/filter_popup_menu.dart';
import 'package:ekart/features/products/presentation/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProductListPage extends GetView<ProductController> {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = controller.categories;
      final isAdmin = GetStorage().read('user_is_admin') ?? false;

      return _ProductListView(
        categories: categories,
        isAdmin: isAdmin,
        controller: controller,
      );
    });
  }
}



class _ProductListView extends StatefulWidget {
  final List<String> categories;
  final bool isAdmin;
  final ProductController controller;

  const _ProductListView({
    required this.categories,
    required this.isAdmin,
    required this.controller,
  });

  @override
  State<_ProductListView> createState() => _ProductListViewState();
}


class _ProductListViewState extends State<_ProductListView> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.categories.length,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_ProductListView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.categories.length != widget.categories.length) {
      _tabController.removeListener(_onTabChanged);
      _tabController.dispose();

      _tabController = TabController(
        length: widget.categories.length,
        vsync: this,
      );
      _tabController.addListener(_onTabChanged);
    }
  }
  
  void _onTabChanged() {
    widget.controller.selectCategory(
      widget.categories[_tabController.index],
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.controller.searchFocusNode.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F6F3),
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(65),
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
                          controller: widget.controller.searchTextController,
                          focusNode: widget.controller.searchFocusNode,
                          onChanged: widget.controller.searchProducts,
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: widget.controller.searchQuery.value.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    widget.controller.searchQuery.value = '';
                                    widget.controller.searchTextController.clear();
                                    widget.controller.searchFocusNode.unfocus();
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                )
                              : null,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilterPopupMenu(controller: widget.controller),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // TABS
                Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: widget.categories
                        .map((cat) => Tab(text: cat))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),

        body: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: 0.5,
              child: SvgPicture.asset(
                'assets/svg/ecommerce_wallpaper.svg',
                fit: BoxFit.cover,
                alignment: AlignmentGeometry.center,
              ),
            ),
            TabBarView(
              controller: _tabController,
              children: widget.categories
                  .map((category) => ProductGrid(category: category))
                  .toList(),
            ),
          ],
        ),

        floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () => Get.toNamed(AppRoutes.createProduct),
              child: const Icon(Icons.library_add),
            )
          : null,
      ),
    );
  }
}