import 'package:ekart/core/widgets/status_badge_widget.dart';
import 'package:ekart/features/orders/presentation/state/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminOrderCard extends StatelessWidget {
  final String orderDocumentId;
  const AdminOrderCard({super.key, required this.orderDocumentId});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final statuses = ['Pending', 'Processing', 'Delivered'];

    final order = orderController.allOrders
        .firstWhereOrNull((o) => o.documentId == orderDocumentId);

    if (order == null) return const SizedBox.shrink();

    final status = order.orderStatus.toLowerCase();

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
            child: Column(          // 👈 was Row before
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
                          'Order #${order.documentId.substring(0, 8).toUpperCase()}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
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
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFAAAAAA),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
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
                        : Icons.payment_outlined ,
                        size: 13,
                        color: const Color(0xFF555555),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        order.paymentMethod == 'cod'
                        ? "COD"
                        : "Card",
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

          const Divider(height: 1, color: Color(0xFFF0EEEB)),

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

          const Divider(height: 1, color: Color(0xFFF0EEEB)),

          // ── Footer ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Status dropdown (hidden when cancelled)
                if (status != 'cancelled')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F0ED),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: statuses.firstWhere(
                          (s) => s.toLowerCase() == status,
                          orElse: () => statuses.first,
                        ),
                        isDense: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                        items: statuses.map((s) =>
                          DropdownMenuItem(
                            value: s,
                            child: Text(
                              s,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                        ).toList(),
                        onChanged: (newStatus) {
                          if (newStatus != null &&
                              newStatus.toLowerCase() != status) {
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
                  // Cancelled label
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Cancelled',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ),

                // Total
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
}