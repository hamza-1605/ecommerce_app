import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white ,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 0.5, blurRadius: 1)
          ]
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.black),
      ),
    );
  }
}