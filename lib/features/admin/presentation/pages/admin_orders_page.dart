import 'package:ecommerce/features/admin/presentation/widgets/admin_order_card.dart';
import 'package:ecommerce/features/admin/presentation/widgets/refresh_button.dart';
import 'package:ecommerce/features/orders/presentation/state/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminOrdersPage extends GetView<OrderController> {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('All Orders',
                    style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w800,
                      letterSpacing: -1, color: Color(0xFF1A1A1A),
                    )),
                  
                  RefreshButton(onTap: () => controller.fetchAllOrders()),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.allOrders.isEmpty) {
                  return const Center(child: Text('No orders yet'));
                }
                return RefreshIndicator(
                  onRefresh: controller.fetchAllOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: controller.allOrders.length,
                    itemBuilder: (_, i) =>
                        AdminOrderCard(orderDocumentId: controller.allOrders[i].documentId),
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