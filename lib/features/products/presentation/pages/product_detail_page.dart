import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/core/constants/api_constants.dart';
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ekart/features/cart/presentation/state/controller/cart_controller.dart';
import 'package:ekart/features/products/presentation/state/controller/product_controller.dart';
import 'package:ekart/features/products/presentation/widgets/product-form/edit_delete_product_button.dart';
import 'package:ekart/features/wishlist/presentation/state/controller/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProductDetailPage extends GetView<ProductController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = GetStorage().read('user_is_admin') ?? false;
    final wishlistController = Get.find<WishlistController>();
    final pageController = PageController();
    final currentPage = 0.obs;

    return Obx(() {
      final product = controller.selectedProduct.value!;

      final hasSale =  product.salePercent != null && product.salePercent! > 0;
      final originalPrice = product.price;
      final discountedPrice = hasSale
          ? originalPrice * (1 - product.salePercent! / 100)
          : originalPrice;

      return Scaffold(
        backgroundColor: const Color(0xFFF8F6F3),

        // ── AppBar ────────────────────────────────────────────────
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 70.0), 
          child: CustomizedAppbar(
            title: product.itemName,
            backButton: true,
            anyWidget: isAdmin
              ? Obx(() => AdminActionsMenu(
                  onEdit: () => Get.toNamed(AppRoutes.editProduct),
                  onDelete: () => controller.deleteProduct(product.documentId!),
                  isDeleting: controller.isSubmitting.value,
                ))
              : null,
          )
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                // ── Image Slider ───────────────────────────────────
                Stack(
                  children: [
                    Container(
                      height: 360,
                      color: Colors.white,
                      child: (product.imagesUrl != null && product.imagesUrl!.isNotEmpty)
                          ? PageView.builder(
                              controller: pageController,
                              itemCount: product.imagesUrl!.length,
                              onPageChanged: (i) => currentPage.value = i,
                              itemBuilder: (context, index) {
                                final imagePath = product.imagesUrl![index]['url'];
                                return Image.network(
                                  '${ApiConstants.baseUrl}$imagePath',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 72,
                                      color: Color(0xFFBBBBBB),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Icon(
                                Icons.inventory_2_outlined,
                                size: 90,
                                color: Color(0xFFBBBBBB),
                              ),
                            ),
                    ),
          
                    // Sale badge on image
                    if (hasSale)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${product.salePercent!.toInt()}% OFF',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
          
                    // Page dots indicator
                    if (product.imagesUrl != null && product.imagesUrl!.length > 1)
                      Positioned(
                        bottom: 14,
                        left: 0,
                        right: 0,
                        child: Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                product.imagesUrl!.length,
                                (i) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  width: currentPage.value == i ? 20 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: currentPage.value == i
                                        ? const Color(0xFF1A1A1A)
                                        : const Color(0xFFCCCCCC),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            )),
                      ),
                  ],
                ),
          
                // ── Content Card ───────────────────────────────────
                Stack(
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.2,
                        child: SvgPicture.asset(
                          'assets/svg/ecommerce_wallpaper.svg',
                          fit: BoxFit.cover,
                          alignment: AlignmentGeometry.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
              
                            // Category chip
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A1A).withValues(alpha: 0.07),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                product.category.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF555555),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
              
                            const SizedBox(height: 10),
              
                            // Product name
                            Text(
                              product.itemName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A1A),
                                letterSpacing: -0.5,
                                height: 1.2,
                              ),
                            ),
              
                            const SizedBox(height: 14),
              
                            // Price section
                            if (hasSale) ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Rs. ${discountedPrice.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    child: Text(
                                      'Rs. ${originalPrice.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFFAAAAAA),
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Color(0xFFAAAAAA),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'You save Rs. ${(originalPrice - discountedPrice).toInt()}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFE53935),
                                ),
                              ),
                            ] else ...[
                              Text(
                                'Rs. ${originalPrice.toInt()}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
              
                            const SizedBox(height: 16),
              
                            // Stock status
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: product.quantity > 0
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFFE53935),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isAdmin
                                      ? 'Stock: ${product.quantity} units'
                                      : product.quantity > 0
                                          ? 'In Stock'
                                          : 'Out of Stock',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
              
                            const SizedBox(height: 24),
              
                            // Divider
                            const Divider(color: Color(0xFFEAE8E5), thickness: 1),
              
                            const SizedBox(height: 20),
              
                            // Description
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A1A),
                                letterSpacing: -0.3,
                              ),
                            ),
              
                            const SizedBox(height: 8),
              
                            Text(
                              (product.description == null || product.description!.isEmpty)
                                  ? 'No description available.'
                                  : product.description!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ])
              ],
            ),
          ),
        ),

        // ── Bottom Bar ────────────────────────────────────────────
        bottomNavigationBar: !isAdmin
            ? SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Wishlist button
                      Obx(() {
                        final isWishlisted =
                            wishlistController.isWishlisted(product.documentId ?? '');
                        return GestureDetector(
                          onTap: () => wishlistController.toggleWishlist(product),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isWishlisted
                                  ? const Color(0xFFFFEBEE)
                                  : const Color(0xFFF2F0ED),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              isWishlisted
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isWishlisted
                                  ? const Color(0xFFE53935)
                                  : const Color(0xFF888888),
                              size: 22,
                            ),
                          ),
                        );
                      }),

                      const SizedBox(width: 12),

                      // Add to Cart button
                      Expanded(
                        child: Obx(() => SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: Get.find<CartController>().isSubmitting.value
                                    ? null
                                    : () => Get.find<CartController>().addToCart(
                                          item: CartItemEntity(
                                            documentId: '',
                                            productDocumentId: product.documentId!,
                                            productName: product.itemName,
                                            price: discountedPrice.toInt(),
                                            quantity: 1,
                                          ),
                                        ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1A1A1A),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  disabledBackgroundColor:
                                      const Color(0xFF1A1A1A).withValues(alpha: 0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Get.find<CartController>().isSubmitting.value
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.shopping_bag_outlined, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            'Add to Cart',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      );
    });
  }
}