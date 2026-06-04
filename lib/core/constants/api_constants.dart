class ApiConstants {
  // URLs
  static final String baseUrl = "http://192.168.153.6:1337";

  // API Endpoints
  static final String productsEndpoint = "/api/products";
  static final String loginEndpoint = "/api/auth/local";
  static final String registerEndpoint = "/api/auth/local/register";
  static final String profileEndpoint = "/api/profiles";
  static final String cartEndpoint = "/api/carts";
  static final String ordersEndpoint = "/api/orders";
  static const String paymentIntentEndpoint = '/api/payment/create-intent';
  static const String notificationsEndpoint = '/api/notifications';
  

  // Headers
  static final String contentType = 'application/json';

}