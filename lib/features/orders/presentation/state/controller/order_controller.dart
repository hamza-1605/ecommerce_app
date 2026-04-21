import 'package:ecommerce/core/network/payment_service.dart';
import 'package:ecommerce/core/utils/helper_functions.dart';
import 'package:ecommerce/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce/features/cart/presentation/state/controller/cart_controller.dart';
import 'package:ecommerce/features/home/presentation/state/controller/home_controller.dart';
import 'package:ecommerce/features/orders/domain/entities/order_entity.dart';
import 'package:ecommerce/features/orders/domain/entities/order_item_entity.dart';
import 'package:ecommerce/features/orders/domain/usecases/delete_order_usecase.dart';
import 'package:ecommerce/features/orders/domain/usecases/update_order_usecase.dart';
import 'package:ecommerce/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:ecommerce/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OrderController extends GetxController {
  final GetOrdersUsecase    getOrdersUsecase;
  final CreateOrderUsecase  createOrderUsecase;
  final UpdateOrderUsecase  updateOrderUsecase;
  final DeleteOrderUsecase deleteOrderUsecase;
  final PaymentService paymentService;

  OrderController({
    required this.getOrdersUsecase,
    required this.createOrderUsecase,
    required this.updateOrderUsecase,
    required this.deleteOrderUsecase,
    required this.paymentService,
  });

  // ── State ───────────────────────────────────────────
  final RxList<OrderEntity> orders       = <OrderEntity>[].obs;
  final RxBool              isLoading    = false.obs;
  final RxBool              isSubmitting = false.obs;

  int get userId => GetStorage().read('user_id');

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  // ── FETCH ORDERS ────────────────────────────────────
  Future<void> fetchOrders() async {
    isLoading.value = true;
    try {
      final result = await getOrdersUsecase.call(userId: userId);
      orders.assignAll(result);
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Fetching Error',
        message: e.toString(),
        isError: true,
      );
    } 
    finally {
      isLoading.value = false;
    }
  }


  // ── CREATE ORDER ────────────────────────────────────
  Future<void> createOrder({
    required List<CartItemEntity> cartItems,
    required String deliveryAddress,
    required int total,
    required String paymentMethod,
  }) async {
    isSubmitting.value = true;
    try {
      final order = OrderEntity(
        documentId:      '',
        orderItems:      cartItems.map( (item) => OrderItemEntity(
                                          productDocumentId: item.productDocumentId,
                                          productName:       item.productName,
                                          price:             item.price,
                                          quantity:          item.quantity,
                                      )).toList(),
        deliveryAddress: deliveryAddress,
        total:           total,
        orderStatus:     'pending',
        paymentMethod:   paymentMethod, 
        createdAt:       DateTime.now(),
      );

      await createOrderUsecase.call(userId: userId, order: order);

      // Clear cart after successful order
      await Get.find<CartController>().clearCart();
      Get.back();                                   // Hide the clear cart snackbar
      await fetchOrders();
      Get.back();
      Get.back();
      Get.find<HomeController>().navigateTo(2);

      HelperFunctions.showSnackbar(
        title:   'Order Placed!',
        message: 'Your order has been placed successfully',
      );
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title:   'Error',
        message: e.toString(),
        isError: true,
      );
    } 
    finally {
      isSubmitting.value = false;
    }
  }


  // ── Stripe Payment ──────────────────────────────────
Future<void> processStripePayment({
  required List<CartItemEntity> cartItems,
  required String               deliveryAddress,
  required int                  total,
}) async {
  isSubmitting.value = true;
  try {
    // 1. Create payment intent on backend
    final clientSecret = await paymentService.createPaymentIntent(
      amount: total,
    );
    // 2. Initialize payment sheet
    await paymentService.initPaymentSheet( clientSecret: clientSecret );
    // 3. Present payment sheet to user
    await paymentService.presentPaymentSheet();
    // 4. Payment successful — place order
    await createOrder(
      cartItems:       cartItems,
      deliveryAddress: deliveryAddress,
      total:           total,
      paymentMethod:   'card',
    );
  } 
  catch (e) {
    // User cancelled payment sheet — don't show error
    if (e is StripeException && e.error.code == FailureCode.Canceled) return;

    HelperFunctions.showSnackbar(
      title:   'Payment Failed',
      message: e.toString(),
      isError: true,
    );
  } 
  finally {
    isSubmitting.value = false;
  }
}


  // ── UPDATE ORDER ────────────────────────────────────
  Future<void> updateOrder({required String documentId, required String orderStatus}) async {
    isSubmitting.value = true;
    try {
      await updateOrderUsecase.call( orderId: documentId, orderStatus: orderStatus );

      final index = orders.indexWhere( (o) => o.documentId == documentId );
      if (index != -1) {
        final existingOrder = orders[index];

        orders[index] = OrderEntity(
          documentId:      existingOrder.documentId,
          orderItems:      existingOrder.orderItems,     
          deliveryAddress: existingOrder.deliveryAddress,
          total:           existingOrder.total,
          paymentMethod:   existingOrder.paymentMethod,
          orderStatus:     'cancelled',
          createdAt:       existingOrder.createdAt,
        );
        orders.refresh();
      }
      HelperFunctions.showSnackbar(
        title:   'Cancelled',
        message: 'Order has been cancelled',
      );
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title:   'Error',
        message: e.toString(),
        isError: true,
      );
    } 
    finally {
      isSubmitting.value = false;
    }
  }


  // ── DELETE ORDER ──────────────────────────────────
  Future<void> deleteOrder({ required String documentId }) async {
    isSubmitting.value = true;
    try {
      await deleteOrderUsecase.call(documentId: documentId);
      Get.back();
      orders.removeWhere((o) => o.documentId == documentId);
      HelperFunctions.showSnackbar(
        title:   'Deleted',
        message: 'Order removed from history',
      );
    } 
    catch (e) {
      print(e);
      HelperFunctions.showSnackbar(
        title:   'Error',
        message: e.toString(),
        isError: true,
      );
    } 
    finally {
      isSubmitting.value = false;
    }
  }

}