import 'package:ekart/core/widgets/blur_button.dart';
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/features/admin/presentation/widgets/admin_order_card.dart';
import 'package:ekart/features/orders/presentation/state/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AdminOrdersPage extends GetView<OrderController> {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70), 
        child: CustomizedAppbar(
          title: "All Orders", 
          anyWidget: BlurButton( 
            buttonIconData: Icons.refresh_rounded, 
            onPressed: () => controller.fetchAllOrders() 
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
          
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.allOrders.isEmpty) {
                    return const Center(child: Text('No orders yet'));
                  }
                  return RefreshIndicator(
                    onRefresh: controller.fetchAllOrders,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(height: 10),
                      itemCount: controller.allOrders.length,
                      itemBuilder: (_, i) =>
                          AdminOrderCard(orderDocumentId: controller.allOrders[i].documentId, index: i+1),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ])
    );
  }
}