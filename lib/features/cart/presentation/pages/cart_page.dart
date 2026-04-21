import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/features/cart/presentation/state/controller/cart_controller.dart';
import 'package:ecommerce/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:ecommerce/features/cart/presentation/widgets/clear_cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.cart.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [

              // ── Header ──────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Cart',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    if (!controller.isEmpty)
                      TextButton.icon(
                        onPressed: () { 
                          showDialog(
                            context: context, 
                            builder: (context) => ClearCart(controller: controller),
                          );
                        },
                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                        label: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
              ),

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
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: controller.cart.value!.cartItems.length,
                    itemBuilder: (_, i) {
                      final item = controller.cart.value!.cartItems[i];
                      return CartItemCard(item: item);
                    },
                  ),
                ),


                // ── Summary & Checkout ──────────────
                Container(
                  padding: const EdgeInsets.all(24),
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
                              fontSize: 22,
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
                        child: ElevatedButton(
                          onPressed: controller.isSubmitting.value ? null : () {
                            Get.toNamed(AppRoutes.checkout);
                          },
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
                            : const Text(
                                'Proceed to Checkout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }
}