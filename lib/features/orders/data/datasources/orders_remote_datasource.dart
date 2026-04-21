import 'dart:convert';
import 'package:ecommerce/core/constants/api_constants.dart';
import 'package:ecommerce/core/network/api_services.dart';
import 'package:ecommerce/features/orders/data/models/order_item_model.dart';
import 'package:ecommerce/features/orders/data/models/order_model.dart';

class OrderRemoteDatasource {
  final ApiServices apiServices;
  OrderRemoteDatasource({required this.apiServices});

  // ── GET ORDERS ─────────────────────────────────────
  Future<List<OrderModel>> getOrders({required int userId}) async {
    final apiResponse = await apiServices.getCall<List<OrderModel>>(
      '${ApiConstants.ordersEndpoint}?filters[user][id][\$eq]=$userId&populate[orderItems][populate]=product&sort=createdAt:desc',
      (json) {
        final List<dynamic> items = json['data'];
        // print('ORDERS RAWWWWWWW: $items');
        return items.map((item) { 
          // print('PARSING ORDER: $item'); 
          return OrderModel.fromJson(item); 
        }).toList();
      },
    );

    if (apiResponse.success) {
      return apiResponse.data!;
    } 
    else {
      throw Exception(apiResponse.message);
    }
  }


  // ── CREATE ORDER ───────────────────────────────────
  Future<OrderModel> createOrder({
    required int userId,
    required OrderModel order,
  }) async {
      final body = {
        "data": {
          "user":             userId,
          "orderItems":       order.orderItems
                                .map((item) => (item as OrderItemModel).toJson())
                                .toList(),
          "deliveryAddress":  order.deliveryAddress,
          "total":            order.total,
          "paymentMethod":    order.paymentMethod,
          "orderStatus":      "pending",
        }
      };

    print('CREATE ORDER BODY: ${jsonEncode(body)}');

    final apiResponse = await apiServices.postCall<OrderModel>(
      ApiConstants.ordersEndpoint,
      body,
      (json) => OrderModel.fromJson(json['data']),
    );

    if (apiResponse.success) {
      return apiResponse.data!;
    } 
    else {
      throw Exception(apiResponse.message);
    }
  }


  // ── UPDATE ORDER ───────────────────────────────────
  Future<OrderModel> updateOrder({required String documentId, required String orderStatus}) async {
    final status = orderStatus.toString().toLowerCase();
    final apiResponse = await apiServices.putCall<OrderModel>(
      '${ApiConstants.ordersEndpoint}/$documentId',
      {
        "data": {
          "orderStatus" : status,
        }
      },
      (json) => OrderModel.fromJson(json['data']),
    );

    if (apiResponse.success) {
      return apiResponse.data!;
    } 
    else {
      throw Exception(apiResponse.message);
    }
  }

  Future<void> deleteOrder({ required String documentId }) async {
    final apiResponse = await apiServices.deleteCall<void>(
      '${ApiConstants.ordersEndpoint}/$documentId',
      (json) {},
    );

    if (!apiResponse.success) {
      throw Exception(apiResponse.message);
    }
  }
}