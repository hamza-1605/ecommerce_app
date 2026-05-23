import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/core/utils/custom_divider.dart';
import 'package:ekart/core/utils/helper_functions.dart';
import 'package:ekart/core/widgets/background_svg.dart';
import 'package:ekart/core/widgets/button_loader.dart';
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/features/cart/presentation/state/controller/cart_controller.dart';
import 'package:ekart/features/orders/presentation/state/controller/order_controller.dart';
import 'package:ekart/features/profile/presentation/state/controller/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class CheckoutPage extends GetView<OrderController> {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final cartController = Get.find<CartController>();
    final profileController = Get.find<UserProfileController>();

    // Pre-fill address from profile
    final addressController = TextEditingController();

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
    } 
    else {
      addressController.text = HelperFunctions().buildAddressFromProfile(
        profileController.profile.value,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70), 
        child: CustomizedAppbar(title: "Checkout", backButton: true)
      ),
      
      body: Stack( 
        fit: StackFit.expand,
        alignment: AlignmentGeometry.center,
        children: [
          BackgroundSvg(),
          
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomInset),
                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                
                    // ── Order Summary ───────────────────────
                    HelperFunctions().buildSectionTitle('Order Summary'),
                    Container(
                      decoration: AppDecorations.containerDecoration,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartController.cart.value!.cartItems.length,
                        separatorBuilder: (context, index) => const CustomDivider(),
                        itemBuilder: (_, i) {
                          final item = cartController.cart.value!.cartItems[i];
                          
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName,
                                        style: AppTextStyles.titleSmall,
                                      ),
                                      Text(
                                        'Qty: ${item.quantity}  ×  Rs. ${item.price}',
                                        style: AppTextStyles.labelMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Rs. ${item.subtotal}',
                                  style: AppTextStyles.titleMedium,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                
                    const SizedBox(height: 36),
                
                    // ── Delivery Address ────────────────────
                    HelperFunctions().buildSectionTitle('Delivery Address'),
                    Container(
                      decoration: AppDecorations.containerDecoration,
                      
                      child: TextField(
                        controller: addressController,
                        maxLines: 3,
                        style: AppTextStyles.titleSmall,
                        decoration: InputDecoration(
                          hintText: 'Enter your delivery address',
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 40),
                            child: Icon(Icons.location_on_outlined),
                          ),
                        ),
                      ),
                    ),
                
                    const SizedBox(height: 36),
                
                    // ── Price Breakdown ─────────────────────
                    HelperFunctions().buildSectionTitle('Price Breakdown'),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppDecorations.containerDecoration,
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
                
                    const SizedBox(height: 50),
                
                    // ── Place Order Button ──────────────────
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: GradientElevatedButton(
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
                        child: controller.isSubmitting.value
                            ? const ButtonLoader()
                            : const Text( 'Continue to Payment' ),
                      ),
                    )),
                
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
      ])
    );
  }
}