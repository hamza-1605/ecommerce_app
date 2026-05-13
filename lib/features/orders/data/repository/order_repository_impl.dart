import 'package:ekart/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:ekart/features/orders/data/models/order_item_model.dart';
import 'package:ekart/features/orders/data/models/order_model.dart';
import 'package:ekart/features/orders/domain/entities/order_entity.dart';
import 'package:ekart/features/orders/domain/repository/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDatasource remoteDatasource;
  OrderRepositoryImpl({required this.remoteDatasource});


  @override
  Future<List<OrderEntity>> getOrders({required int userId}) async {
    return await remoteDatasource.getOrders(userId: userId);
  }


  @override
  Future<OrderEntity> updateOrder({required String documentId, required String orderStatus}) async {
    return await remoteDatasource.updateOrder(documentId: documentId, orderStatus: orderStatus);
  }


  @override
  Future<void> deleteOrder({required String documentId}) async {
    await remoteDatasource.deleteOrder(documentId: documentId);
  }


  @override
  Future<OrderEntity> createOrder({
    required int userId,
    required OrderEntity order,
  }) async {                                                // Converting OrderEntity & OrderItemEntity ===> OrderModel & OrderModelEntity
    final orderModel = OrderModel(
      documentId:      order.documentId,
      orderItems:      order.orderItems.map( (item) => OrderItemModel(
                                              productDocumentId: item.productDocumentId,
                                              productName:       item.productName,
                                              price:             item.price,
                                              quantity:          item.quantity,
                                            )).toList(),

      deliveryAddress:  order.deliveryAddress,
      total:            order.total,
      paymentMethod:    order.paymentMethod,
      orderStatus:      order.orderStatus,
      createdAt:        order.createdAt,
    );


    return await remoteDatasource.createOrder(
      userId: userId,
      order:  orderModel,
    );
  }


  @override
  Future<List<OrderEntity>> getAllOrders() async {
    return await remoteDatasource.getAllOrders();
  }
} 