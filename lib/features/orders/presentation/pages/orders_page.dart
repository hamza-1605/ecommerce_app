import 'package:ecommerce/features/orders/presentation/state/controller/order_controller.dart';
import 'package:ecommerce/features/orders/presentation/widgets/order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersPage extends GetView<OrderController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchOrders();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ──────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Orders',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.fetchOrders,
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
            ),

            // ── Orders List ─────────────────────────
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text(
                          'No orders yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF888888),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your order history will appear here',
                          style: TextStyle(color: Color(0xFFBBBBBB)),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: controller.orders.length,
                    itemBuilder: (_, i) {
                      final order = controller.orders[i];
                      return OrderCard(order: order);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}