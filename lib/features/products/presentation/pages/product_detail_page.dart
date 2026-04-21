import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/core/constants/api_constants.dart';
import 'package:ecommerce/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce/features/cart/presentation/state/controller/cart_controller.dart';
import 'package:ecommerce/features/products/presentation/state/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailPage extends GetView<ProductController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Obx( ()  {
      final product = controller.selectedProduct.value!;
      
      return Scaffold(
        appBar: AppBar(
          title: Text(product.itemName),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Get.toNamed(AppRoutes.editProduct),
            ),
            Obx(() => IconButton(
                  icon: controller.isSubmitting.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete),
                  onPressed: () =>
                      controller.deleteProduct(product.documentId!),
                )),
          ],
        ),


        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //  IMAGE SLIDER
              SizedBox(
                height: 400,
                child: PageView.builder(
                  itemCount: product.imagesUrl?.length ?? 1,
                  itemBuilder: (context, index) {
                    final imagePath = product.imagesUrl != null &&
                            product.imagesUrl!.isNotEmpty
                        ? product.imagesUrl![index]['url']
                        : "https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png?v=1530129081";

                    return Image.network(
                      '${ApiConstants.baseUrl}$imagePath',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),


              const SizedBox(height: 16),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //  Category
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Name
                    Text(
                      product.itemName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Price + Sale
                    Row(
                      children: [
                        Text(
                          "Rs. ${product.price}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(width: 10),

                        if (product.salePercent != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "-${product.salePercent}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Quantity
                    Text(
                      "Stock: ${product.quantity}",
                      style: TextStyle(color: Colors.grey[700]),
                    ),

                    const SizedBox(height: 20),

                    // Description
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      (product.description == null || product.description!.isEmpty)
                          ? "No description available."
                          : product.description!,
                      style: TextStyle(color: Colors.grey[800]),
                    ),

                    const SizedBox(height: 80), // space for bottom bar
                  ],
                ),
              ),
            ],
          ),
        ),


        // Bottom Buttons
        bottomNavigationBar: SafeArea(
          bottom: true,
          top: false,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black12,
                )
              ],
            ),
            child: Row(
              children: [
                // Favorite
                Obx(() => IconButton(
                      onPressed: controller.toggleFavorite,
                      icon: Icon(
                        controller.isFavorite.value
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    )),
          
                const SizedBox(width: 10),
          

                // Add to Cart
                Expanded(
                  child: Obx( () => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: Get.find<CartController>().isSubmitting.value
                          ? null
                          : () => Get.find<CartController>().addToCart(
                                item: CartItemEntity(
                                  documentId:        '',
                                  productDocumentId: product.documentId!,
                                  productName:       product.itemName,
                                  price:             product.price.toInt(),
                                  quantity:          1,
                                ),
                              ),
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.limeAccent,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}