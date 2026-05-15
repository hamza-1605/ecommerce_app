import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/core/constants/app_constants.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/core/widgets/branding/app_logo.dart';
import 'package:ekart/core/widgets/branding/app_text.dart';
import 'package:ekart/core/widgets/button_loader.dart';
import 'package:ekart/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ekart/features/auth/presentation/widgets/auth_layout.dart';
import 'package:ekart/features/auth/presentation/widgets/label_text.dart';
import 'package:ekart/features/auth/presentation/widgets/build_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController    = TextEditingController();
    final passwordController = TextEditingController();
    final obscurePassword    = true.obs;

    return AuthLayout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            // Header ----- Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppLogo(),
                    AppText(),
                    // const SizedBox(height: 15),
                    const Text(
                      loginMessage,
                      style: AppTextStyles.authPageMessage,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            
      
            const SizedBox(height: 30),
      
            // ── Email Field ─────────────────────────
            LabelText(text: 'Email'),
            const SizedBox(height: 8),
            BuildTextfield(
              controller: emailController,
              hint: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              prefixIconData: Icons.mail_outline_rounded,
            ),
      
            const SizedBox(height: 24),
      
            // ── Password Field ──────────────────────
            LabelText(text: 'Password'),
            const SizedBox(height: 8),
            Obx(() => GestureDetector(
              child: BuildTextfield(
                controller: passwordController,
                hint: '••••••••',
                obscure: obscurePassword.value,
                prefixIconData: Icons.lock_outline_rounded,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF888888),
                    size: 20,
                  ),
                  onPressed: () => obscurePassword.value = !obscurePassword.value,
                ),
              ),
            )),
      
            const SizedBox(height: 20),
            // Forgot Password
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.forgotPassword),
              child: const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot Password?',
                  style: AppTextStyles.authForgotPassword
                ),
              ),
            ),
      
            const SizedBox(height: 35),
      
            // ── Login Button ────────────────────────
            Obx(() => SizedBox(
              width: double.infinity,
              height: 60,
              child: GradientElevatedButton(
                onPressed: controller.isLoading.value
                  ? null
                  : () => controller.loginUser(
                      email:    emailController.text.trim(),
                      password: passwordController.text.trim(),
                    ), 
                child: controller.isLoading.value
                  ? const ButtonLoader()
                  : const Text('Sign In'),
              ),
            )),
      
            const SizedBox(height: 32),
      
            // ── Register Link ───────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  noAccount,
                  style: AppTextStyles.authBottomText,
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(
                    AppRoutes.register,
                  ),
                  child: const Text(
                    'Register',
                    style: AppTextStyles.authBottomLink
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}