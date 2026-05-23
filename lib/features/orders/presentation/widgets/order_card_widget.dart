import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/core/utils/custom_divider.dart';
import 'package:ekart/features/orders/domain/entities/order_entity.dart';
import 'package:ekart/core/widgets/status_badge_widget.dart';
import 'package:ekart/features/orders/presentation/widgets/action_button.dart';
import 'package:ekart/features/orders/presentation/widgets/dialog_cancel_order.dart';
import 'package:ekart/features/orders/presentation/widgets/dialog_delete_order.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final int index;
  const OrderCard({super.key, required this.order, required this.index});

  @override
  Widget build(BuildContext context) {
    final status = order.orderStatus.toLowerCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: AppDecorations.orderCardDecoration,
      child: Column(
        children: [
          // ── Header ─────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: AppDecorations.orderHeader,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt_long_outlined, color: Colors.black, size: 16),
                    const SizedBox(width: 7),
                    Text(
                      '$index) Order #${order.documentId.substring(0, 8).toUpperCase()}',
                      style: AppTextStyles.titleMedium.copyWith( letterSpacing: -0.3),
                    ),
                  ],
                ),
                StatusBadge(status: order.orderStatus),
              ],
            ),
          ),

          // ── Date + Payment Method ───────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),

                // Payment Method
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: AppDecorations.orderCardDecoration,
                  child: Row(
                    children: [
                      Icon(
                        order.paymentMethod == 'cod'
                          ? Icons.payments_outlined
                          : Icons.credit_card_outlined,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        order.paymentMethod == 'cod' 
                          ? 'COD'
                          : 'CARD',
                        style: AppTextStyles.labelSmall,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        decoration: AppDecorations.cardItems,
                        alignment: Alignment.center,
                        child: Text(
                          '${item.quantity}',
                          style: AppTextStyles.labelSmallBlack,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.productName,
                          style: AppTextStyles.labelMedium,
                        ),
                      ),
                      Text(
                        'Rs. ${item.subtotal}',
                        style: AppTextStyles.titleSmall,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Cancel / Delete button
                if (status == 'pending')
                  ActionButton(
                    label: 'Cancel',
                    isDelete: false,
                    icon: Icons.cancel_outlined,
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => DialogCancelOrder(order: order),
                    ),
                  )
                else if (status == 'cancelled')
                  ActionButton(
                    label: 'Delete',
                    icon: Icons.delete_outline,
                    isDelete: true,
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => DialogDeleteOrder(order: order),
                    ),
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
                          style: AppTextStyles.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. ${order.total}',
                      style: AppTextStyles.titleLarge,
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