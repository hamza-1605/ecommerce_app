import 'package:ekart/core/utils/custom_divider.dart';
import 'package:ekart/features/orders/domain/entities/order_entity.dart';
import 'package:ekart/features/orders/presentation/state/controller/order_controller.dart';
import 'package:ekart/core/widgets/status_badge_widget.dart';
import 'package:ekart/features/orders/presentation/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final int index;
  const OrderCard({super.key, required this.order, required this.index});

  @override
  Widget build(BuildContext context) {
    final status = order.orderStatus.toLowerCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: BoxBorder.all(color: Colors.black26, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [

          // ── Header ─────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 235, 235, 235),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt_long_outlined, color: Colors.black, size: 16),
                    const SizedBox(width: 7),
                    Text(
                      '$index) Order #${order.documentId.substring(0, 8).toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                StatusBadge(status: order.orderStatus),
              ],
            ),
          ),

          // ── Date + Payment Method ───────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                // Date
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 13, color: Color(0xFF888888)),
                      const SizedBox(width: 5),
                      Text(
                        '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF888888),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Payment Method
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F0ED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        order.paymentMethod == 'cod'
                        ? Icons.payments_outlined
                        : Icons.credit_card_outlined,
                        size: 13,
                        color: const Color(0xFF555555),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        order.paymentMethod == 'cod' 
                        ? 'COD'
                        : 'CARD',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const CustomDivider(),

          // ── Order Items ─────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: order.orderItems.map((item) =>
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quantity badge
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F0ED),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.productName,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF444444),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        'Rs. ${item.subtotal}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              ).toList(),
            ),
          ),

          const CustomDivider(),

          // ── Footer ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Cancel / Delete button
                if (status == 'pending')
                  ActionButton(
                    label: 'Cancel',
                    icon: Icons.cancel_outlined,
                    color: const Color(0xFFE53935),
                    bgColor: const Color(0xFFFFEBEE),
                    onTap: () => _confirmCancel(context, order),
                  )
                else if (status == 'cancelled')
                  ActionButton(
                    label: 'Delete',
                    icon: Icons.delete_outline,
                    color: Colors.white,
                    bgColor: const Color(0xFFE53935),
                    onTap: () => _confirmDelete(context, order),
                  )
                else
                  const SizedBox.shrink(),

                // Totals
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.local_shipping_outlined, size: 13, color: Color(0xFF888888)),
                        SizedBox(width: 4),
                        Text(
                          'Free Shipping',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF888888),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. ${order.total}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
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
        title: const Text('Cancel Order', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No', style: TextStyle(color: Color(0xFF888888))),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.find<OrderController>().updateOrder(
                documentId: order.documentId,
                orderStatus: 'cancelled',
              );
            },
            child: const Text('Yes, Cancel',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
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
        title: const Text('Delete Order', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Remove this cancelled order from your history?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No', style: TextStyle(color: Color(0xFF888888))),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.find<OrderController>().deleteOrder(documentId: order.documentId);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

}