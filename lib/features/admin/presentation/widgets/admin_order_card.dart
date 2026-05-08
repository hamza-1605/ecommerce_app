import 'package:ecommerce/core/utils/custom_divider.dart';
import 'package:ecommerce/core/widgets/status_badge_widget.dart';
import 'package:ecommerce/features/orders/presentation/state/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminOrderCard extends StatelessWidget {
 final String orderDocumentId;
  const AdminOrderCard({super.key, required this.orderDocumentId});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final statuses = ['Pending', 'Processing', 'Delivered'];

    return Obx(() {
      // Always read fresh from allOrders
      final order = orderController.allOrders
          .firstWhereOrNull((o) => o.documentId == orderDocumentId);

      if (order == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [

            // ── Header ─────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.documentId.substring(0, 8)}',
                        style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                        style: const TextStyle(
                          fontSize: 12, color: Color(0xFF888888)),
                      ),
                    ],
                  ),
                  StatusBadge(status: order.orderStatus),
                ],
              ),
            ),

            const CustomDivider(),

            // ── Items ──────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: order.orderItems.map((item) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item.productName} × ${item.quantity}',
                          style: const TextStyle(
                            fontSize: 13, color: Color(0xFF555555))),
                        Text('Rs. ${item.subtotal}',
                          style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ).toList(),
              ),
            ),

            const CustomDivider(),

            // ── Status Changer & Total ──────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status dropdown
                  if (order.orderStatus.toLowerCase() != 'cancelled')
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F6F3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: statuses.firstWhere(
                          (s) => s.toLowerCase() ==
                              order.orderStatus.toLowerCase(),
                          orElse: () => statuses.first,
                        ),
                        isDense: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                        items: statuses.map((status) =>
                          DropdownMenuItem(
                            value: status,
                            child: Text(status,
                              style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                          ),
                        ).toList(),
                        onChanged: (newStatus) {
                          if (newStatus != null &&
                              newStatus.toLowerCase() !=
                                  order.orderStatus.toLowerCase()) {
                            orderController.updateOrder(
                              documentId: order.documentId,
                              orderStatus: newStatus,
                            );
                          }
                        },
                      ),
                    ),
                  )
                  else
                  const SizedBox(),

                  Text('Rs. ${order.total}',
                    style: const TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w800
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}