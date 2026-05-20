import 'package:ekart/features/admin/presentation/widgets/admin_orders/dashed_divider.dart';
import 'package:ekart/features/admin/presentation/widgets/admin_orders/receipt_row.dart';
import 'package:ekart/features/admin/presentation/widgets/admin_orders/zigzag_painter.dart';
import 'package:ekart/features/orders/domain/entities/order_entity.dart';
import 'package:ekart/features/orders/presentation/state/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceiptSheet extends StatelessWidget {
  final OrderEntity order;
  final List<String> statuses;
  final String status;
  final OrderController orderController;

  const ReceiptSheet({
    super.key,
    required this.order,
    required this.statuses,
    required this.status,
    required this.orderController,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = ['Pending', 'Processing', 'Delivered'];
    final status = order.orderStatus.toLowerCase();

    return Stack(
      clipBehavior: Clip.none,
      children: [

        // ── Receipt ──────────────────────────────
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            ZigzagEdge(flip: false),

            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // space for X button
                  const SizedBox(height: 20),

                  const Center(
                    child: Text('Order receipt', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                  ),
                  const SizedBox(height: 2),
                  Center(
                    child: Text(
                      '${order.user?['username'] ?? 'Unknown'} · #${order.user?['id'] ?? '—'}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  ReceiptRow(label: 'Order ID', value: '#${order.documentId.substring(0, 8).toUpperCase()}'),
                  ReceiptRow(label: 'Date', value: '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}'),
                  ReceiptRow(label: 'Payment', value: order.paymentMethod == 'cod' ? 'Cash on Delivery' : 'Card'),
                  ReceiptRow(label: 'Status', value: order.orderStatus, valueColor: const Color(0xFFB45309)),
                  ReceiptRow(label: 'Address', value: order.deliveryAddress, valueSize: 12),

                  const DashedDivider(),

                  const Text('ITEMS', style: TextStyle(fontSize: 11, color: Color(0xFF888888), letterSpacing: 0.8)),
                  const SizedBox(height: 6),

                  ...order.orderItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 20, height: 20,
                          decoration: BoxDecoration(color: const Color(0xFFF2F0ED), borderRadius: BorderRadius.circular(5)),
                          alignment: Alignment.center,
                          child: Text('${item.quantity}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item.productName, style: const TextStyle(fontSize: 13, color: Color(0xFF444444)))),
                        Text('Rs. ${item.subtotal}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                      ],
                    ),
                  )),

                  const DashedDivider(),

                  ReceiptRow(label: 'Shipping', value: 'Free', valueColor: const Color(0xFF16A34A)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                      Text('Rs. ${order.total}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                    ],
                  ),

                  if (status != 'cancelled') ...[
                    const DashedDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Update status', style: TextStyle(fontSize: 13, color: Color(0xFF888888))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFF2F0ED), borderRadius: BorderRadius.circular(10)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: statuses.firstWhere((s) => s.toLowerCase() == status, orElse: () => statuses.first),
                              isDense: true,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                              items: statuses.map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                              )).toList(),
                              onChanged: (newStatus) {
                                if (newStatus != null && newStatus.toLowerCase() != status) {
                                  orderController.updateOrder(documentId: order.documentId, orderStatus: newStatus);
                                  Get.back();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  const SizedBox(height: 8),
                ],
              ),
            ),

            ZigzagEdge(flip: true),
          ],
        ),

        // ── X button ─────────────────────────────
        Positioned(
          top: 20,    // sits inside the receipt body just below the top zigzag
          right: 12,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F0ED),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF1A1A1A)),
            ),
          ),
        ),
      ],
    );
  }
}