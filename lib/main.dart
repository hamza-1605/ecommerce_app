import 'package:ekart/app/global_binding/app_binding.dart';
import 'package:ekart/app/routes/app_pages.dart';
import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/core/services/notification_service.dart';
import 'package:ekart/core/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// 👇 must be top-level, handles background notifications
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // no need to show notification here — FCM handles it automatically in background
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(); // 👈 initialize Firebase  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); // 👈 register background handler
  await NotificationService.init();

  await GetStorage.init();
  
  Stripe.publishableKey = 'pk_test_51TKCd2CIWnQKZpyN6k01aTwqyRhyerKkhU1SWhlx7YUph5hgNoQRwLOpIhpn9MW5KzIujdaQtz3CQV0mQL0mhKpv009wGxjGtz';
  await Stripe.instance.applySettings();
  
  AppBinding.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'E-Kart',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightMode,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 1000),
    );
  }
}