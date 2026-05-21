// pages/edit_product_page.dart
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/features/products/presentation/state/controller/product_controller.dart';
import 'package:ekart/features/products/presentation/widgets/product_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProductPage extends GetView<ProductController> {
  const EditProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70), 
        child: CustomizedAppbar(title: "Edit Product", backButton: true),
      ),
      body: ProductForm(
        existingProduct: controller.selectedProduct.value,
        onSubmit: (product) => controller.updateProduct(product),
        isSubmitting: controller.isSubmitting,
      ),
    );
  }
}