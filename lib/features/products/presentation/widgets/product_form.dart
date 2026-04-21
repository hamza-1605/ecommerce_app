// widgets/product_form.dart

import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductForm extends StatefulWidget {
  final ProductEntity? existingProduct;       // null = create, non-null = edit
  final Function(ProductEntity) onSubmit;
  final RxBool isSubmitting;

  const ProductForm({
    super.key,
    this.existingProduct,
    required this.onSubmit,
    required this.isSubmitting,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {

  late final TextEditingController itemNameController;
  late final TextEditingController categoryController;
  late final TextEditingController priceController;
  late final TextEditingController quantityController;
  late final TextEditingController descriptionController;
  late final TextEditingController salePercentController;

  @override
  void initState() {
    super.initState();
    // prefill if editing
    final p = widget.existingProduct;
    itemNameController    = TextEditingController(text: p?.itemName ?? '');
    categoryController    = TextEditingController(text: p?.category ?? '');
    priceController       = TextEditingController(text: p?.price.toString() ?? '');
    quantityController    = TextEditingController(text: p?.quantity.toString() ?? '');
    descriptionController = TextEditingController(text: p?.description ?? '');
    salePercentController = TextEditingController(text: p?.salePercent?.toString() ?? '');
  }

  @override
  void dispose() {
    itemNameController.dispose();
    categoryController.dispose();
    priceController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    salePercentController.dispose();
    super.dispose();
  }

  void _submit() {
    final product = ProductEntity(
      documentId: widget.existingProduct?.documentId,
      itemName: itemNameController.text.trim(),
      category: categoryController.text.trim(),
      price: int.parse(priceController.text.trim()),
      quantity: int.parse(quantityController.text.trim()),
      description: descriptionController.text.trim(),
      salePercent: salePercentController.text.isEmpty
          ? null
          : int.parse(salePercentController.text.trim()),
      imagesUrl: widget.existingProduct?.imagesUrl ?? [],
    );
    
    widget.onSubmit(product);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(controller: itemNameController,    decoration: const InputDecoration(labelText: 'Item Name*')),
          TextField(controller: categoryController,    decoration: const InputDecoration(labelText: 'Category*')),
          TextField(controller: priceController,       decoration: const InputDecoration(labelText: 'Price*'),    keyboardType: TextInputType.number),
          TextField(controller: quantityController,    decoration: const InputDecoration(labelText: 'Quantity*'), keyboardType: TextInputType.number),
          TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description (Optional)')),
          TextField(controller: salePercentController, decoration: const InputDecoration(labelText: 'Sale % (optional)'), keyboardType: TextInputType.number),
          
          const SizedBox(height: 24),
          
          Obx(() => ElevatedButton(
            onPressed: widget.isSubmitting.value ? null : _submit,
            child: widget.isSubmitting.value
                ? const CircularProgressIndicator()
                : Text(widget.existingProduct == null ? 'Create' : 'Update'),
          )),
        ],
      ),
    );
  }
}