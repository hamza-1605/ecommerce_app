import 'package:ekart/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:ekart/features/admin/presentation/pages/admin_orders_page.dart';
import 'package:ekart/features/admin/presentation/pages/admin_products_page.dart';
import 'package:ekart/features/admin/presentation/pages/admin_profile_page.dart';
import 'package:ekart/features/home/presentation/state/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put( HomeController() );

    final pages = [
      const AdminDashboardPage(),
      const AdminProductsPage(),
      const AdminOrdersPage(),
      const AdminProfilePage(),
    ];

    return Obx(() => Scaffold(
      body: pages[homeController.currentIndex.value],
      bottomNavigationBar: NavigationBar(
        selectedIndex: homeController.currentIndex.value,
        onDestinationSelected: homeController.navigateTo,
        backgroundColor: const Color(0xFFF8F6F3),
        indicatorColor: const Color(0xFF1A1A1A),
        destinations: const [
          NavigationDestination(
            icon:         Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Colors.white),
            label:        'Dashboard',
          ),
          NavigationDestination(
            icon:         Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2, color: Colors.white),
            label:        'Products',
          ),
          NavigationDestination(
            icon:         Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: Colors.white),
            label:        'Orders',
          ),
          NavigationDestination(
            icon:         Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: Colors.white),
            label:        'Profile',
          ),
        ],
      ),
    ));
  }
}