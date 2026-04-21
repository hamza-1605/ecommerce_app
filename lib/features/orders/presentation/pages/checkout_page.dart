import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/core/utils/custom_divider.dart';
import 'package:ecommerce/core/utils/helper_functions.dart';
import 'package:ecommerce/features/cart/presentation/state/controller/cart_controller.dart';
import 'package:ecommerce/features/orders/presentation/state/controller/order_controller.dart';
import 'package:ecommerce/features/profile/presentation/state/controller/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CheckoutPage extends GetView<OrderController> {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final profileController = Get.find<UserProfileController>();

    // Pre-fill address from profile
    final addressController = TextEditingController();
    // text: HelperFunctions().buildAddressFromProfile(profileController.profile.value),

    // Getting Address from profile
    if (profileController.profile.value == null) {
      final userId = GetStorage().read('user_id');
      if (userId != null) {
        profileController.fetchProfile(userId: userId).then( (_) {
          addressController.text = HelperFunctions().buildAddressFromProfile(
            profileController.profile.value,
          );
        });
      }
    } else {
      addressController.text = HelperFunctions().buildAddressFromProfile(
        profileController.profile.value,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F6F3),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
          ),
        ),
        title: const Text(
          'Checkout',
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

            // ── Order Summary ───────────────────────
            HelperFunctions().buildSectionTitle('Order Summary'),
            Container(
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
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartController.cart.value!.cartItems.length,
                separatorBuilder: (context, index) => const CustomDivider(),
                itemBuilder: (_, i) {
                  final item = cartController.cart.value!.cartItems[i];
                  
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Qty: ${item.quantity}  ×  Rs. ${item.price}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Rs. ${item.subtotal}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ── Delivery Address ────────────────────
            HelperFunctions().buildSectionTitle('Delivery Address'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              
              child: TextField(
                controller: addressController,
                maxLines: 3,
                style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
                decoration: InputDecoration(
                  hintText: 'Enter your delivery address',
                  hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.location_on_outlined,
                        color: Color(0xFF888888), size: 20),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Price Breakdown ─────────────────────
            HelperFunctions().buildSectionTitle('Price Breakdown'),
            Container(
              padding: const EdgeInsets.all(16),
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
                  HelperFunctions().buildPriceRow('Subtotal',  'Rs. ${cartController.cartTotal}'),
                  const SizedBox(height: 8),
                  HelperFunctions().buildPriceRow('Delivery',  'Free'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: CustomDivider(),
                  ),
                  HelperFunctions().buildPriceRow(
                    'Total',
                    'Rs. ${cartController.cartTotal}',
                    bold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // ── Place Order Button ──────────────────
            Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () {
                        if (addressController.text.trim().isEmpty) {
                          HelperFunctions.showSnackbar(
                            title:   'Address Required',
                            message: 'Please enter a delivery address',
                            isError: true,
                          );
                          return;
                        }
                        Get.toNamed(
                          AppRoutes.payment,
                          arguments: {
                            'cartItems':       cartController.cart.value!.cartItems,
                            'deliveryAddress': addressController.text.trim(),
                            'total':           cartController.cartTotal,
                          },
                        );
                        
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
                        'Continue to Payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            )),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}