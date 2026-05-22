import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/core/widgets/branding/app_text.dart';
import 'package:ekart/features/auth/domain/entities/auth_user_entity.dart';
import 'package:ekart/features/auth/presentation/state/controllers/auth_controller.dart';
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
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(color: AppColors.appMainColor),
          ],
        ),
      ),
    );
  }
}