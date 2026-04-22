import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/features/auth/domain/entities/auth_user_entity.dart';
import 'package:ecommerce/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    _navigate();
  }


  void _navigate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = GetStorage().read('jwt_token');
      
      if (token != null && token.toString().isNotEmpty) {
        final authController = Get.find<AuthController>();      // getting logged in user
        final isAdmin = GetStorage().read('user_is_admin') ?? false;
        print('/***********************************************\\');
        print('TOKEN: $token');
        print('IS_ADMIN: $isAdmin');
        print('IS_ADMIN TYPE: ${isAdmin.runtimeType}');
        print('\\***********************************************/');

        authController.currentUser.value = AuthUserEntity(
          id:       GetStorage().read('user_id'),
          email:    GetStorage().read('user_email'),
          username: GetStorage().read('user_username'),
          isAdmin:  isAdmin,
          token:    token,
        );

        if(authController.currentUser.value!.isAdmin){
          Get.offAllNamed(AppRoutes.adminHome);
        }
        else{
          Get.offAllNamed(AppRoutes.home);
        }
      } 
      else {
        GetStorage().erase();
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Icon(
          Icons.shopping_cart,
          color: Colors.black,
          size: 100,
        ),
      ),
    );
  }
}