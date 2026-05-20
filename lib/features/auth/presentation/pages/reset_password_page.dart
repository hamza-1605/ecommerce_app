import 'package:ekart/core/constants/app_constants.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/core/widgets/button_loader.dart';
import 'package:ekart/core/widgets/custom_back_button.dart';
import 'package:ekart/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ekart/features/auth/presentation/widgets/auth_layout.dart';
import 'package:ekart/features/auth/presentation/widgets/label_text.dart';
import 'package:ekart/features/auth/presentation/widgets/build_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class ResetPasswordPage extends GetView<AuthController> {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final codeController            = TextEditingController();
    final passwordController        = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final obscurePassword           = true.obs;
    final obscureConfirm            = true.obs;

    return AuthLayout(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomBackButton(),
            SizedBox(height: 20),
              
            // ── Header ──────────────────────────
            const Text(
              resetPasswordTitle,
              style: AppTextStyles.authPageHeading
            ),
              
            const SizedBox(height: 12),
            const Text(
              resetPasswordMessage,
              style: AppTextStyles.authPageMessage
            ),
              
            const SizedBox(height: 40),
              
            // ── Code Field ──────────────────────
            LabelText(text: 'Reset Code'),
            const SizedBox(height: 8),
            BuildTextfield(
              controller: codeController,
              hint: 'Paste code from email',
              prefixIconData: Icons.key_outlined,
            ),
              
            const SizedBox(height: 24),
              
            // ── New Password ────────────────────
            LabelText(text: 'New Password'),
            const SizedBox(height: 8),
            Obx(() => BuildTextfield(
              controller: passwordController,
              hint: '••••••••',
              prefixIconData: Icons.lock_outline_rounded,
              obscure: obscurePassword.value,
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
            )),
              
            const SizedBox(height: 24),
              
            // ── Confirm Password ────────────────
            LabelText(text: 'Confirm Password'),
            const SizedBox(height: 8),
            Obx(() => BuildTextfield(
              controller: confirmPasswordController,
              hint: '••••••••',
              prefixIconData: Icons.lock_outline_rounded,
              obscure: obscureConfirm.value,
              suffixIcon: IconButton(
                icon: Icon(
                  obscureConfirm.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF888888),
                  size: 20,
                ),
                onPressed: () => obscureConfirm.value = !obscureConfirm.value,
              ),
            )),
              
            const SizedBox(height: 40),
              
            // ── Submit Button ───────────────────
            Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: GradientElevatedButton(
                onPressed: controller.isLoading.value
                  ? null
                  : () => controller.resetPassword(
                    code: codeController.text,
                    password: passwordController.text,
                    passwordConfirmation: confirmPasswordController.text,
                  ),
                child: controller.isLoading.value
                  ? const ButtonLoader()
                  : const Text('Reset Password'),
              ),
            )),
          ],
        ),
      ),
    );
  }
}