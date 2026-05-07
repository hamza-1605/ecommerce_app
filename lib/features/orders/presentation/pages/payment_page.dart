import 'package:ecommerce/core/widgets/custom_back_button.dart';
import 'package:ecommerce/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce/features/orders/presentation/state/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentPage extends GetView<OrderController> {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve args passed from CheckoutPage
    final args            = Get.arguments as Map<String, dynamic>;

    final cartItems       = args['cartItems']       as List<CartItemEntity>;
    final deliveryAddress = args['deliveryAddress'] as String;
    final total           = args['total']           as int;

    final selectedMethod  = 'cod'.obs;              // default to COD

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F6F3),
        elevation: 0,
        leading: CustomBackButton(),
        title: const Text(
          'Payment',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Amount Summary ──────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rs. $total',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Payment Method Selection ────────────
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),

            const SizedBox(height: 16),

            // COD Option
            Obx(() => _PaymentOptionCard(
              icon:       Icons.money_rounded,
              title:      'Cash on Delivery',
              subtitle:   'Pay when your order arrives',
              isSelected: selectedMethod.value == 'cod',
              onTap:      () => selectedMethod.value = 'cod',
            )),

            const SizedBox(height: 12),

            // Card Option
            Obx(() => _PaymentOptionCard(
              icon:       Icons.credit_card_rounded,
              title:      'Card Payment',
              subtitle:   'Pay securely via Stripe',
              isSelected: selectedMethod.value == 'card',
              onTap:      () => selectedMethod.value = 'card',
            )),

            const SizedBox(height: 36),

            // ── Confirm Button ──────────────────────
            Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () => _handlePayment(
                          context:         context,
                          selectedMethod:  selectedMethod.value,
                          cartItems:       cartItems,
                          deliveryAddress: deliveryAddress,
                          total:           total,
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        selectedMethod.value == 'cod'
                            ? 'Place Order'
                            : 'Pay & Place Order',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            )),
          ],
        ),
      ),
    );
  }


  Future<void> _handlePayment({
    required BuildContext        context,
    required String              selectedMethod,
    required List<CartItemEntity> cartItems,
    required String              deliveryAddress,
    required int                 total,
  }) async {
    if (selectedMethod == 'cod') {
      // ── Cash on Delivery — place order directly ──
      await controller.createOrder(
        cartItems:       cartItems,
        deliveryAddress: deliveryAddress,
        total:           total,
        paymentMethod:   'cod',
      );
    } else {
      // ── Card — Stripe payment first ──────────────
      
      await controller.processStripePayment(
        cartItems:       cartItems,
        deliveryAddress: deliveryAddress,
        total:           total,
      );
    }
  }
}


// ── Payment Option Card Widget ─────────────────────────
class _PaymentOptionCard extends StatelessWidget {
  final IconData icon;
  final String   title;
  final String   subtitle;
  final bool     isSelected;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFF8F6F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF888888),
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF1A1A1A),
              ),
          ],
        ),
      ),
    );
  }
}