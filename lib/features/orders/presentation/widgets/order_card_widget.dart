// ── Order Card Widget ──────────────────────────────────
import 'package:ecommerce/core/utils/custom_divider.dart';
import 'package:ecommerce/features/orders/domain/entities/order_entity.dart';
import 'package:ecommerce/features/orders/presentation/state/controller/order_controller.dart';
import 'package:ecommerce/core/widgets/status_badge_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
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

          // ── Order Header ───────────────────────
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
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
                StatusBadge(status: order.orderStatus),
              ],
            ),
          ),

          const CustomDivider(),

          // ── Order Items ──────────────────────── (List of items)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: order.orderItems.map((item) =>
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.productName} × ${item.quantity}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555555),
                        ),
                      ),
                      Text(
                        'Rs. ${item.subtotal}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ).toList(),
            ),
          ),

          const CustomDivider(),

          // ── Order Footer ─────────────────────── (Cancel/Delete button with Total)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel only when pending
                if (order.orderStatus.toLowerCase() == 'pending')
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red
                    ),
                    onPressed: () => _confirmCancel(context, order),
                    icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 16),
                    label: const Text( 'Cancel',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)
                    ),
                  )

                // Delete only when cancelled
                else if (order.orderStatus.toLowerCase() == 'cancelled')
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white
                    ),
                    onPressed: () => _confirmDelete(context, order),
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text( 'Delete',
                      style: TextStyle(fontWeight: FontWeight.w600)
                    ),
                  )

                else
                  const SizedBox.shrink(),

                // Total
                Text(
                  'Total: Rs. ${order.total}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  void _confirmCancel(BuildContext context, OrderEntity order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Order',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No',
                style: TextStyle(color: Color(0xFF888888))),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.find<OrderController>().updateOrder(documentId: order.documentId, orderStatus: "cancelled");
            },
            child: const Text('Yes, Cancel',
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }


  void _confirmDelete(BuildContext context, OrderEntity order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Order',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            'Remove this cancelled order from your history?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No',
                style: TextStyle(color: Color(0xFF888888))),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.find<OrderController>().deleteOrder(documentId: order.documentId);
            },
            child: const Text('Delete',
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    }
}