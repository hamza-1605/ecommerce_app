import 'package:ekart/core/constants/api_constants.dart';
import 'package:ekart/features/products/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback  onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imagesUrl != null && product.imagesUrl!.isNotEmpty
                    ? ApiConstants.baseUrl + (product.imagesUrl!.first['url'] as String)
                    : null;

    final hasSale =  product.salePercent != null && product.salePercent! > 0;
    final discountedPrice = hasSale
        ? product.price * (1 - product.salePercent! / 100)
        : product.price;

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

            // ── Image placeholder ─────────────────
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F6F3),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: imageUrl != null
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.image_not_supported_outlined,
                              color: Color(0xFFBBBBBB),
                              size: 40,
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: Color(0xFFBBBBBB),
                            size: 40,
                          ),
                        ),
                  ),
                  if (product.salePercent != null)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${product.salePercent}% off',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Info ──────────────────────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.itemName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
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
                      if (product.salePercent != null)
                      Text(
                        'Rs. ${product.price.toInt()}',
                        style: const TextStyle(
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 128, 128, 128),
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