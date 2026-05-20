import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/core/widgets/button_loader.dart';
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/features/cart/presentation/state/controller/cart_controller.dart';
import 'package:ekart/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:ekart/features/cart/presentation/widgets/clear_cart_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70.0), 
        child: CustomizedAppbar(title: "My Cart"),
      ), 
      
      body: Stack( 
        fit: StackFit.expand,
        alignment: AlignmentGeometry.center,
        children: [
          Opacity(
            opacity: 0.4,
            child: SvgPicture.asset(
              'assets/svg/ecommerce_wallpaper.svg',
              fit: BoxFit.cover,
              alignment: AlignmentGeometry.center,
            ),
          ),
          Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
        
          if (controller.cart.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
        
          return Column(
            children: [
              if (!controller.isEmpty)
              ClearCartButton(controller: controller),
        
              // ── Empty State ─────────────────────────
              if (controller.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF888888),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add items from the shop',
                          style: TextStyle(color: Color(0xFFBBBBBB)),
                        ),
                      ],
                    ),
                  ),
                )
        
              // ── Cart Items ──────────────────────────
              else ...[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    itemCount: controller.cart.value!.cartItems.length,
                    itemBuilder: (_, i) {
                      final item = controller.cart.value!.cartItems[i];
                      return CartItemCard(item: item);
                    },
                  ),
                ),
        
        
                // ── Summary & Checkout ──────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF888888),
                            ),
                          ),
                          Text(
                            'Rs. ${controller.cartTotal}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      Obx(() => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: GradientElevatedButton(
                          onPressed: controller.isSubmitting.value 
                            ? null 
                            : () {
                              Get.toNamed(AppRoutes.checkout);
                            }, 
                          child: controller.isSubmitting.value
                            ? const ButtonLoader()
                            : const Text(
                                'Proceed to Checkout',
                            ),
                        )
                      )),
                    ],
                  ),
                ),
              ],
            ],
          );
        }),
      ])
    );
  }
}