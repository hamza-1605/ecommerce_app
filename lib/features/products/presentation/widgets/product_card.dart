import 'package:ekart/core/constants/api_constants.dart';
import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/features/products/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart; // optional — pass null to hide button

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imagesUrl != null && product.imagesUrl!.isNotEmpty
        ? ApiConstants.baseUrl + (product.imagesUrl!.first['url'] as String)
        : null;

    final hasSale = product.salePercent != null && product.salePercent! > 0;
    final discountedPrice = hasSale
        ? product.price * (1 - product.salePercent! / 100)
        : product.price.toDouble();

    final inStock = product.quantity > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Image ─────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const _ImagePlaceholder(),
                        )
                      : const _ImagePlaceholder(),
                  )
                ),
            
                // Sale badge
                if (hasSale)
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${product.salePercent}% off',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // ── Info ──────────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Category
                  Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.appMainColor,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Name
                  Text(
                    product.itemName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Stock indicator
                  Row(
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(
                          color: inStock ? const Color.fromARGB(255, 40, 168, 36) : const Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        inStock ? 'In stock' : 'Out of stock',
                        style: TextStyle(fontSize: 10, color: inStock ? AppColors.fadedIconColor : const Color(0xFFE53935)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Price row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rs. ${discountedPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      if (hasSale)
                        Text(
                          'Rs. ${product.price}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFAAAAAA),
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Color(0xFFAAAAAA),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F6F3),
      child: const Center(
        child: Icon(Icons.inventory_2_outlined, color: Color(0xFFBBBBBB), size: 40),
      ),
    );
  }
}