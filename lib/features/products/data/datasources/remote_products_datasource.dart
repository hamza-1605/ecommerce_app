import 'package:ekart/core/constants/api_constants.dart';
import 'package:ekart/core/network/api_services.dart';
import 'package:ekart/features/products/data/models/product_model.dart';


class RemoteProductsDatasource {
  final ApiServices apiServices;
  RemoteProductsDatasource({ required this.apiServices });
  
  Future<List<ProductModel>> readProducts() async {
    final apiResponse = await apiServices.getCall(
      '${ApiConstants.productsEndpoint}?populate=imagesUrl', 
      (json) {
        final List<dynamic> items = json['data'];        
        return items.map((item) => ProductModel.fromJson(item)).toList();
      },
    );
    
    if (apiResponse.success) {
      return apiResponse.data!;
    } 
    else {
      throw Exception(apiResponse.message);
    } 
  }


  Future<void> createProduct(ProductModel product) async {
    await apiServices.postCall( 
      ApiConstants.productsEndpoint, 
      {
        "data" : {
          "itemName" : product.itemName,
          "category" : product.category,
          "price" : product.price,
          "quantity" : product.quantity,
          "description" : product.description,
          "salePercent" : product.salePercent,
          if (product.uploadedImageIds != null && product.uploadedImageIds!.isNotEmpty)
          "imagesUrl":   product.uploadedImageIds,
        }
      },
      (json) {},
    );
  }


  Future<void> updateProduct(ProductModel product) async {
    //  Collect existing image ids from current imagesUrl
    final existingImageIds = product.imagesUrl != null
        ? product.imagesUrl!
            .map((img) => (img as Map)['id'] as int)
            .toList()
        : <int>[];

    // ✅ Merge existing + newly uploaded ids
    final allImageIds = [
      ...existingImageIds,
      ...?product.uploadedImageIds,
    ];
    await apiServices.putCall( 
      '${ApiConstants.productsEndpoint}/${product.documentId}', 
      {
        "data" : {
          "itemName" : product.itemName,
          "category" : product.category,
          "price" : product.price,
          "quantity" : product.quantity,
          "description" : product.description ?? "",
          "salePercent" : product.salePercent,
          if (allImageIds.isNotEmpty)
          "imagesUrl": allImageIds,
        }
      },
      (json) {},
    );
  }


  Future<void> deleteProduct(String documentId) async {
    await apiServices.deleteCall(
      '${ApiConstants.productsEndpoint}/$documentId',
      (json) {},
    );
  }

  // remote_products_datasource.dart
  Future<void> updateStock({
    required String documentId,
    required int    newQuantity,
  }) async {
    final apiResponse = await apiServices.putCall<void>(
      '${ApiConstants.productsEndpoint}/$documentId',
      {
        "data": {
          "quantity": newQuantity,
        }
      },
      (json) {},
    );

    if (!apiResponse.success) {
      throw Exception(apiResponse.message);
    }
  }
}