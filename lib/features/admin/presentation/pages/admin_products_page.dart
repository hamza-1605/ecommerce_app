import 'package:ecommerce/features/products/presentation/pages/product_list_page.dart';
import 'package:flutter/material.dart';

class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProductListPage();   // ✅ fully reuse
  }
}