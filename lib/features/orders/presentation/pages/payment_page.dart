import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/core/widgets/background_svg.dart';
import 'package:ekart/core/widgets/button_loader.dart';
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ekart/features/orders/presentation/state/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

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

      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70.0), 
        child: CustomizedAppbar(title: "Payment", backButton: true),
      ),
      
      body: Stack( 
        fit: StackFit.expand,
        alignment: AlignmentGeometry.center,
        children: [
          BackgroundSvg(),
          
          SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Amount Summary ──────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: AppDecorations.containerDecoration.copyWith(
                  border: Border.all(
                    color: AppColors.appMainColor,
                    width: 2
                  )
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Amount',
                      style: AppTextStyles.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rs. $total',
                      style: AppTextStyles.displayLargeBlack,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Payment Method Selection ────────────
              const Text(
                'Select Payment Method',
                style: AppTextStyles.titleMedium,
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
                child: GradientElevatedButton(
                  onPressed: controller.isSubmitting.value
                    ? null
                    : () => _handlePayment(
                          context:         context,
                          selectedMethod:  selectedMethod.value,
                          cartItems:       cartItems,
                          deliveryAddress: deliveryAddress,
                          total:           total,
                        ),
                  child: controller.isSubmitting.value
                    ? const ButtonLoader()
                    : Text( selectedMethod.value == 'cod'
                        ? 'Place Order'
                        : 'Pay & Place Order',
                      ),
                ),
              )),
            ],
          ),
        ),
      ])
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
        decoration: AppDecorations.containerDecoration.copyWith(
          border: Border.all(
            color: isSelected ? AppColors.appMainColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.appMainColor
                    : AppColors.bottomNavbar ,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
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
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isSelected
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.appMainColor,
              ),
          ],
        ),
      ),
    );
  }
}