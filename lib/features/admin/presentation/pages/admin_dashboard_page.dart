import 'package:ekart/core/widgets/background_svg.dart';
import 'package:ekart/core/widgets/blur_button.dart';
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/features/admin/presentation/widgets/admin_order_card.dart';
import 'package:ekart/features/admin/presentation/widgets/dashboard_stat_card.dart';
import 'package:ekart/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ekart/features/orders/presentation/state/controller/order_controller.dart';
import 'package:ekart/features/products/presentation/pages/product_detail_page.dart';
import 'package:ekart/features/products/presentation/state/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController   = Get.find<OrderController>();
    final productController = Get.find<ProductController>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70), 
        child: CustomizedAppbar(
          title: "Dashboard", 
          backButton: false, 
          anyWidget: BlurButton(
            buttonIconData: Icons.refresh, 
            onPressed: (){
              orderController.fetchAllOrders();
              productController.fetchProducts();
            } 
          ),
        ),
      ),
      
      body: Stack( 
        fit: StackFit.expand,
        alignment: AlignmentGeometry.center,
        children: [
          BackgroundSvg(),
          
          SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${Get.find<AuthController>().currentUser.value?.username}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF888888),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // ── Orders Section ──────────────────────
              const Text('Orders Overview',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              
              Obx(() {
                final orders = orderController.allOrders;
                
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DashboardStatCard(
                            title:  'Pending',
                            count:  orders.where((o) => o.orderStatus.toLowerCase() == 'pending').length,
                            icon:   Icons.hourglass_empty_rounded,
                            color:  Colors.orange,
                            onTap:  () => _openFilteredOrders(context, 'Pending', orderController),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DashboardStatCard(
                            title:  'Processing',
                            count:  orders.where((o) => o.orderStatus.toLowerCase() == 'processing').length,
                            icon:   Icons.settings_outlined,
                            color:  Colors.blue,
                            onTap:  () => _openFilteredOrders(context, 'Processing', orderController),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DashboardStatCard(
                            title:  'Delivered',
                            count:  orders.where((o) => o.orderStatus.toLowerCase() == 'delivered').length,
                            icon:   Icons.check_circle_outline_rounded,
                            color:  Colors.green,
                            onTap:  () => _openFilteredOrders(context, 'Delivered', orderController),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DashboardStatCard(
                            title:  'Cancelled',
                            count:  orders.where((o) => o.orderStatus.toLowerCase() == 'cancelled').length,
                            icon:   Icons.cancel_outlined,
                            color:  Colors.red,
                            onTap:  () => _openFilteredOrders(context, 'Cancelled', orderController),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              
              const SizedBox(height: 32),
              
              // ── Products Section ────────────────────
              const Text('Inventory Alerts',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              
              Obx(() {
                final products = productController.products;
                final outOfStock  = products.where((p) => p.quantity == 0).toList();
                final lowStock    = products.where((p) => p.quantity > 0 && p.quantity < 20).toList();
              
                return Column(
                  children: [
                    DashboardStatCard(
                      title:    'Out of Stock',
                      count:    outOfStock.length,
                      icon:     Icons.remove_shopping_cart_outlined,
                      color:    Colors.red,
                      fullWidth: true,
                      onTap:    () => _openProductList(context, outOfStock, 'Out of Stock'),
                    ),
                    const SizedBox(height: 12),
                    DashboardStatCard(
                      title:    'Low Stock (< 20)',
                      count:    lowStock.length,
                      icon:     Icons.warning_amber_rounded,
                      color:    Colors.orange,
                      fullWidth: true,
                      onTap:    () => _openProductList(context, lowStock, 'Low Stock'),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ])
    );
  }

  void _openFilteredOrders(
    BuildContext context,
    String status,
    OrderController orderController,
  ) {
    final filtered = orderController.allOrders
        .where((o) => o.orderStatus.toLowerCase() == status.toLowerCase())
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF8F6F3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize:     0.95,
        minChildSize:     0.4,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text('$status Orders',
              style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Expanded(
              child: filtered.isEmpty
                ? const Center(child: Text('No orders found'))
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => AdminOrderCard(orderDocumentId: filtered[i].documentId, index: i),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _openProductList(
    BuildContext context,
    List products,
    String title,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF8F6F3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize:     0.95,
        minChildSize:     0.4,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(title,
              style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Expanded(
              child: products.isEmpty
                ? const Center(child: Text('No products found'))
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: products.length,
                    itemBuilder: (_, i) => GestureDetector(
                      onTap: () {
                        final productController = Get.find<ProductController>();
                        productController.selectedProduct.value = products[i];

                        Get.back(); // close bottom sheet
                        Get.to(() => const ProductDetailPage());
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(products[i].itemName,
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text('Qty: ${products[i].quantity}',
                              style: const TextStyle(color: Colors.red,
                                  fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}