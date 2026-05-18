import 'package:ekart/features/cart/presentation/pages/cart_page.dart';
import 'package:ekart/features/home/presentation/state/controller/home_controller.dart';
import 'package:ekart/features/orders/presentation/pages/orders_page.dart';
import 'package:ekart/features/products/presentation/pages/product_list_page.dart';
import 'package:ekart/features/profile/presentation/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final pages = [
      const ProductListPage(),
      const CartPage(),             
      const OrdersPage(),
      const UserProfilePage(),
    ];

    return Obx(() => Scaffold(
      body: pages[controller.currentIndex.value],
      
      bottomNavigationBar: NavigationBar(
        selectedIndex: controller.currentIndex.value,
        onDestinationSelected: (value) =>  controller.navigateTo( value ),

        destinations: const [
          NavigationDestination(
            icon:          Icon(Icons.storefront_outlined),
            selectedIcon:  Icon(Icons.storefront),
            label:         'Shop',
          ),
          NavigationDestination(
            icon:          Icon(Icons.shopping_cart_outlined),
            selectedIcon:  Icon(Icons.shopping_cart),
            label:         'Cart',
          ),
          NavigationDestination(
            icon:          Icon(Icons.receipt_long_outlined),
            selectedIcon:  Icon(Icons.receipt_long),
            label:         'Orders',
          ),
          NavigationDestination(
            icon:          Icon(Icons.person_outline_rounded),
            selectedIcon:  Icon(Icons.person_rounded),
            label:         'Profile',
          ),
        ],
      ),
    ));
  }
}