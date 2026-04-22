import 'package:ecommerce/core/constants/api_constants.dart';
import 'package:ecommerce/core/network/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentService {
  final ApiServices apiServices;
  PaymentService({required this.apiServices});

  Future<String> createPaymentIntent({required int amount}) async {
    print("******** Creating payment intent ********");
    final apiResponse = await apiServices.postCall<String>(
      ApiConstants.paymentIntentEndpoint,
      { 
        "amount": amount, 
        "currency": "pkr" 
      },
      (json) => json['clientSecret'] as String,
    );

    print("******** Processing Finished ********");
    print('Api Response ======> ${apiResponse.errors}');
    if (apiResponse.success) {
      return apiResponse.data!;
    } 
    else {
      throw Exception(apiResponse.message);
    }
  }

  Future<void> initPaymentSheet({ required String clientSecret }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName:       'Your Store Name',
        style:                     ThemeMode.light,
      ),
    );
  }

  Future<void> presentPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }
}