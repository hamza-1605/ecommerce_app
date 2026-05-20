import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/features/cart/presentation/state/controller/cart_controller.dart';
import 'package:ekart/features/cart/presentation/widgets/clear_cart.dart';
import 'package:flutter/material.dart';

class ClearCartButton extends StatelessWidget {
  const ClearCartButton({super.key, required this.controller});
  final CartController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(15),
                  side: BorderSide(width: 1, color: AppColors.appMainColor)
                )
              ),
              onPressed: () { 
                showDialog(
                  context: context, 
                  builder: (context) => ClearCart(controller: controller),
                );
              },
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
              label: const Text(
                'Clear Cart',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              )
            )
        ])
    );
  }
}