import 'package:ekart/features/products/presentation/state/controller/product_controller.dart';
import 'package:flutter/material.dart';

class FilterPopupMenu extends StatelessWidget {
  const FilterPopupMenu({super.key, required this.controller});
  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.sort),
      onSelected: controller.sortProducts,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'price_low_high',
          child: Text('Price: Low to High'),
        ),
        const PopupMenuItem(
          value: 'price_high_low',
          child: Text('Price: High to Low'),
        ),
        const PopupMenuItem(
          value: 'name_az',
          child: Text('Name: A-Z'),
        ),
      ],
    );
  }
}