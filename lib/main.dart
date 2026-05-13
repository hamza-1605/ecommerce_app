import 'package:ekart/app/global_binding/app_binding.dart';
import 'package:ekart/app/routes/app_pages.dart';
import 'package:ekart/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  Stripe.publishableKey = 'pk_test_51TKCd2CIWnQKZpyN6k01aTwqyRhyerKkhU1SWhlx7YUph5hgNoQRwLOpIhpn9MW5KzIujdaQtz3CQV0mQL0mhKpv009wGxjGtz';
  await Stripe.instance.applySettings();
  
  AppBinding.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'ekart',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blueGrey),
        appBarTheme: AppBarThemeData(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent
        )
      ),

      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}