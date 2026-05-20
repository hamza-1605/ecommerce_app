import 'package:ekart/core/widgets/blur_button.dart';
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/features/orders/presentation/state/controller/order_controller.dart';
import 'package:ekart/features/orders/presentation/widgets/order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OrdersPage extends GetView<OrderController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70.0), 
        child: CustomizedAppbar( 
          title: "My Orders",
          anyWidget: BlurButton(
            buttonIconData: Icons.refresh_outlined, 
            onPressed: () => controller.fetchOrders(),
          ),
        ),
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
          
          SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Orders List ─────────────────────────
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
        
                  if (controller.orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          const Text(
                            'No orders yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF888888),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your order history will appear here',
                            style: TextStyle(color: Color(0xFFBBBBBB)),
                          ),
                        ],
                      ),
                    );
                  }
        
                  return RefreshIndicator(
                    onRefresh: controller.fetchOrders,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      itemCount: controller.orders.length,
                      itemBuilder: (_, index) {
                        final order = controller.orders[index];
                        return OrderCard(order: order, index: index+1);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}