// pages/create_product_page.dart

import 'package:ecommerce/features/products/presentation/state/controller/product_controller.dart';
import 'package:ecommerce/features/products/presentation/widgets/product_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateProductPage extends GetView<ProductController> {
  const CreateProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Product')),
      body: ProductForm(
        onSubmit: (product) => controller.createProduct(product),
        isSubmitting: controller.isSubmitting,
      ),
    );
  }
}