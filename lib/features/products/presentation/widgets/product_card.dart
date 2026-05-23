import 'package:ekart/core/constants/api_constants.dart';
import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/features/products/domain/entities/product_entity.dart';
import 'package:ekart/features/products/presentation/widgets/image_placeholder.dart';
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
        decoration: AppDecorations.containerDecoration,
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
                          errorBuilder: (context, error, stackTrace) => const ImagePlaceholder(),
                        )
                      : const ImagePlaceholder(),
                  )
                ),
            
                // Sale badge
                if (hasSale)
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: AppDecorations.saleTag,
                      child: Text(
                        '${product.salePercent}% off',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white
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
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.appMainColor
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Name
                  Text(
                    product.itemName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleSmall,
                  ),
                  const SizedBox(height: 4),

                  // Stock indicator
                  Row(
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(
                          color: inStock ? AppColors.success : AppColors.error ,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        inStock ? 'In stock' : 'Out of stock',
                        style: TextStyle(fontSize: 10, color: inStock ? AppColors.textSecondary : AppColors.error),
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
                        style: AppTextStyles.titleSmall,
                      ),
                      if (hasSale)
                        Text(
                          'Rs. ${product.price}',
                          style: AppTextStyles.oldPrice
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