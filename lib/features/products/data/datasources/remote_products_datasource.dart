import 'package:ecommerce/core/constants/api_constants.dart';
import 'package:ecommerce/core/network/api_services.dart';
import 'package:ecommerce/features/products/data/models/product_model.dart';


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
          "imagesUrl" : product.imagesUrl
        }
      },
      (json) {},
    );
  }


  Future<void> updateProduct(ProductModel product) async {
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
          "imagesUrl" : product.imagesUrl
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

  Future<ProductModel> getProductById(String documentId) async {
    final apiResponse = await apiServices.getCall(
      '${ApiConstants.productsEndpoint}/$documentId', 
      (json) {
        final item = json['data'];        
        return ProductModel.fromJson(item);
      },
    );

    if(!apiResponse.success) throw Exception("Couldn't get Product");
    return apiResponse.data! ;
  }
}