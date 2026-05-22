import 'dart:io';
import 'package:ekart/core/constants/api_constants.dart';
import 'package:ekart/core/widgets/background_svg.dart';
import 'package:ekart/core/widgets/button_loader.dart';
import 'package:ekart/features/products/domain/entities/product_entity.dart';
import 'package:ekart/features/products/presentation/state/controller/product_controller.dart';
import 'package:ekart/features/products/presentation/widgets/product-form/add_image_button.dart';
import 'package:ekart/features/products/presentation/widgets/product-form/image_uploading_progress.dart';
import 'package:ekart/features/products/presentation/widgets/product-form/new_images_preview.dart';
import 'package:ekart/features/products/presentation/widgets/product-form/product_editing_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:image_picker/image_picker.dart';

class ProductForm extends StatefulWidget {
  final ProductEntity? existingProduct; // null = create, non-null = edit
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
  final List<String> _categories = [
    'Bakery',
    'Beverages',
    'Dairy',
    'Fruits',
    'Snacks',
    'Spices',
    'Vegetables',
  ];

  late String _selectedCategory;

  late final TextEditingController itemNameController;
  late final TextEditingController priceController;
  late final TextEditingController quantityController;
  late final TextEditingController descriptionController;
  late final TextEditingController salePercentController;
  late final ProductController _productController;

  final List<File> _newImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  bool _isSubmitting = false;

  // ── Pick Images ──────────────────────────────────
  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      setState(() {
        _newImages.addAll(picked.map((img) => File(img.path)));
      });
    }
  }

  void _removeNewImage(int index) {
    setState(() => _newImages.removeAt(index));
  }


  @override
  void initState() {
    super.initState();
    _productController = Get.find<ProductController>();
    ever(widget.isSubmitting, (val) {
      if (mounted) setState(() => _isSubmitting = val);
    });

    // prefill if editing
    final p = widget.existingProduct;

    _selectedCategory =
        (p?.category != null && _categories.contains(p!.category))
        ? p.category
        : _categories.first;

    itemNameController = TextEditingController(text: p?.itemName ?? '');
    priceController = TextEditingController(text: p?.price.toString() ?? '');
    quantityController = TextEditingController(
      text: p?.quantity.toString() ?? '',
    );
    descriptionController = TextEditingController(text: p?.description ?? '');
    salePercentController = TextEditingController(
      text: p?.salePercent?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    itemNameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    salePercentController.dispose();
    super.dispose();
  }

  void _submit() async {
    final validationError = _productController.validateProduct(
      itemNameController.text.trim(), 
      int.tryParse(priceController.text.trim()), 
      int.tryParse(quantityController.text.trim()),
      int.tryParse(salePercentController.text.trim()),
    );

    if(validationError) return;

    List<int>? uploadedIds;

    if (_newImages.isNotEmpty) {
      setState(() => _isUploading = true );
      uploadedIds = await _productController.uploadProductImages(
        _newImages,
      );
      setState(() => _isUploading = false );

      if (uploadedIds == null) return; // upload failed
    }
    

    final product = ProductEntity(
      documentId: widget.existingProduct?.documentId,
      itemName: itemNameController.text.trim(),
      category: _selectedCategory,
      price: int.parse(priceController.text.trim()),
      quantity: int.parse(quantityController.text.trim()),
      description: descriptionController.text.trim(),
      salePercent: salePercentController.text.isEmpty
          ? null
          : int.parse(salePercentController.text.trim()),
      imagesUrl: widget.existingProduct?.imagesUrl ?? [],
      uploadedImageIds: uploadedIds,
    );

    widget.onSubmit(product);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack( 
        // alignment: AlignmentGeometry.center,
        children: [
          Positioned.fill(
            child: BackgroundSvg(),
          ),
          
          SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                ProductTextfield(
                  controller: itemNameController,
                  label: 'Item Name*',
                ),

                // DropDown
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Category*',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      items: _categories
                          .map(
                            (cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(
                                cat,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _selectedCategory = value;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                ProductTextfield(
                  controller: priceController,
                  label: 'Price*',
                  keyboard: TextInputType.number,
                ),

                ProductTextfield(
                  controller: quantityController,
                  label: 'Stock*',
                  keyboard: TextInputType.number,
                ),

                ProductTextfield(
                  controller: descriptionController,
                  label: 'Description (Optional)',
                ),

                ProductTextfield(
                  controller: salePercentController,
                  label: 'Sale % (optional)',
                  keyboard: TextInputType.number,
                ),

                const SizedBox(height: 20),

                // ── Image Section ───────────────────────
                const Text(
                  'Product Images',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),

                // ── Existing Images (edit mode) ─────────
                if (widget.existingProduct != null)
                  Obx(() {
                    final currentProduct = widget.existingProduct?.documentId != null
                        ? _productController.products.firstWhereOrNull(
                            (p) => p.documentId == widget.existingProduct!.documentId
                          )
                        : null;

                    final images = currentProduct?.imagesUrl ?? widget.existingProduct?.imagesUrl ?? [];

                    if (images.isEmpty) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Current Images',
                          style: TextStyle(fontSize: 12, color: Color(0xFF888888))),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (_, i) {
                              final img     = images[i] as Map;
                              final url     = ApiConstants.baseUrl + (img['url'] as String);
                              final mediaId = img['id'] as int;

                              return Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFFE0E0E0)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(url, fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => 
                                            const Icon(Icons.broken_image_outlined)),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4, right: 12,
                                    child: GestureDetector(
                                      onTap: () => _confirmDeleteImage(
                                        mediaId:  mediaId,
                                        mediaUrl: url,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close,
                                            color: Colors.white, size: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }),

                // ── New Images Preview ──────────────────
                if (_newImages.isNotEmpty) 
                  NewImagesPreview(onTap: _removeNewImage, newImages: _newImages),

                // ── Add Images Button ───────────────────
                AddImageButton(onTap: _pickImages),

                // ── Upload progress ─────────────────────
                if(_isUploading == true)
                  ImageUploadingProgress(),

                const SizedBox(height: 24),

                GradientElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const ButtonLoader()
                      : Text( widget.existingProduct == null ? 'Create' : 'Update' ),
                ),
              ],
            ),
          ),
      ])
    );
  }

  void _confirmDeleteImage({required int mediaId, required String mediaUrl}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Image',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text('Remove this image from the product?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF888888)),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _productController.deleteProductImage(
                product: widget.existingProduct!,
                mediaId: mediaId,
                mediaUrl: mediaUrl,
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

}
