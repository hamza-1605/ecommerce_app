import 'package:ekart/core/widgets/status_badge_widget.dart';
import 'package:ekart/features/admin/presentation/widgets/admin_orders/receipt_sheet.dart';
import 'package:ekart/features/orders/domain/entities/order_entity.dart';
import 'package:ekart/features/orders/presentation/state/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminOrderCard extends StatelessWidget {
  final String orderDocumentId;
  final int index;
  const AdminOrderCard({super.key, required this.orderDocumentId, required this.index});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final order = orderController.allOrders
        .firstWhereOrNull((o) => o.documentId == orderDocumentId);

    if (order == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.receipt_long_outlined, color: Colors.white, size: 16),
                        const SizedBox(width: 7),
                        Text(
                          '$index) Order #${order.documentId.substring(0, 8).toUpperCase()}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.3),
                        ),
                      ],
                    ),
                    StatusBadge(status: order.orderStatus),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.person_outline_rounded, color: Color(0xFFAAAAAA), size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '${order.user?['username'] ?? 'Unknown'} · #${order.user?['id'] ?? '—'}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Date + Payment ──────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 13, color: Color(0xFF888888)),
                      const SizedBox(width: 5),
                      Text(
                        '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF888888), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFF2F0ED), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(order.paymentMethod == 'cod' ? Icons.payments_outlined : Icons.payment_outlined, size: 13, color: const Color(0xFF555555)),
                      const SizedBox(width: 5),
                      Text(order.paymentMethod == 'cod' ? 'COD' : 'Card',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF555555))),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF0EEEB)),

          // ── Footer ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // View Order button
                GestureDetector(
                  onTap: () => _showReceiptSheet(context, order, orderController),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.receipt_outlined, color: Colors.white, size: 15),
                        SizedBox(width: 6),
                        Text('View order', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),

                // Total
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.local_shipping_outlined, size: 13, color: Color(0xFF888888)),
                        SizedBox(width: 4),
                        Text('Free Shipping', style: TextStyle(fontSize: 12, color: Color(0xFF888888), fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Rs. ${order.total}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A), letterSpacing: -0.5)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReceiptSheet(BuildContext context, OrderEntity order, OrderController orderController) {
    final statuses = ['Pending', 'Processing', 'Delivered'];
    final status = order.orderStatus.toLowerCase();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: ReceiptSheet(order: order, statuses: statuses, status: status, orderController: orderController),
      ),
    );
  }
}








