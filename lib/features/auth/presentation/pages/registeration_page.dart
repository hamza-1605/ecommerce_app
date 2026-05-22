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

class RegisterationPage extends GetView<AuthController> {
  const RegisterationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final emailController    = TextEditingController();
    final passwordController = TextEditingController();
    final obscurePassword    = true.obs;

    return AuthLayout(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLogo(width: 44),
                AppText(fontSize: 24, fontWeight: FontWeight.w700),
              ],
            ),
              
            const SizedBox(height: 50),
              
            // ── Header ──────────────────────────────
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Create Account',
                    style: AppTextStyles.displayLarge
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    signUpMessage,
                    style: AppTextStyles.bodyMedium,
                  ),
                ]
              ),
            ),
              
            const SizedBox(height: 30),
              
            // ── Username ─────────────────────────────
            LabelText(text: 'Username'),
            const SizedBox(height: 8),
            BuildTextfield(
              controller: usernameController,
              hint: 'johndoe',
              prefixIconData: Icons.person_outline_rounded,
            ),
              
            const SizedBox(height: 24),
              
            // ── Email ────────────────────────────────
            LabelText(text: 'Email'),
            const SizedBox(height: 8),
            BuildTextfield(
              controller: emailController,
              hint: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              prefixIconData: Icons.mail_outline_rounded,
            ),
              
            const SizedBox(height: 24),
              
            // ── Password ─────────────────────────────
            LabelText(text: 'Password'),
            const SizedBox(height: 8),
            Obx(() => BuildTextfield(
              controller: passwordController,
              hint: '••••••',
              obscure: obscurePassword.value,
              prefixIconData: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                ),
                onPressed: () => obscurePassword.value = !obscurePassword.value,
              ),
            )),
              
            const SizedBox(height: 40),
              
            // ── Register Button ──────────────────────
            Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: GradientElevatedButton(
                onPressed: controller.isLoading.value
                  ? null
                  : () => controller.registerUser(
                        username: usernameController.text,
                        email:    emailController.text,
                        password: passwordController.text,
                      ),
                child: controller.isLoading.value
                  ? const ButtonLoader()
                  : const Text(
                      'Create Account',
                      style: AppTextStyles.labelLarge
                    ),
              ),
            )),
              
            const SizedBox(height: 32),
              
            // ── Login Link ───────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  haveAccount,
                  style: AppTextStyles.bodyMedium,
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    'Sign In',
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