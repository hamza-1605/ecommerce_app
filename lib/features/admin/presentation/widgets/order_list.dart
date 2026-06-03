import 'package:ekart/features/admin/presentation/widgets/admin_order_card.dart';
import 'package:ekart/features/orders/presentation/state/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderList extends GetView<OrderController> {
  final String tab;
  const OrderList({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final orders = tab == 'All'
          ? controller.allOrders
          : controller.allOrders
              .where((o) => o.orderStatus.toLowerCase() == tab.toLowerCase())
              .toList();

      if (orders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long_outlined, size: 60, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                'No ${tab == 'All' ? '' : tab.toLowerCase()} orders',
                style: const TextStyle(fontSize: 15, color: Color(0xFF888888), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchAllOrders,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: orders.length,
          itemBuilder: (_, i) => AdminOrderCard(
            orderDocumentId: orders[i].documentId,
            index: orders.length - i,
          ),
        ),
      );
    });
  }
}