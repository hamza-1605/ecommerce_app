import 'package:ekart/core/constants/app_constants.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/core/widgets/button_loader.dart';
import 'package:ekart/core/widgets/custom_back_button.dart';
import 'package:ekart/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ekart/features/auth/presentation/widgets/auth_layout.dart';
import 'package:ekart/features/auth/presentation/widgets/build_textfield.dart';
import 'package:ekart/features/profile/presentation/widgets/label_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class ForgotPasswordPage extends GetView<AuthController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return AuthLayout(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(),
              SizedBox(height: 20),
            
              // ── Header ──────────────────────────
              const Text(
                forgotPasswordTitle ,
                style: AppTextStyles.authPageHeading
              ),
              
              const SizedBox(height: 12),
              const Text(
                forgotPasswordMessage,
                style: AppTextStyles.authPageMessage
              ),
        
              const SizedBox(height: 30),
        
              // ── Email Field ─────────────────────
              LabelText(
                text: 'Email',
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: BuildTextfield(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  hint: 'you@example.com',
                  prefixIconData: Icons.mail_outline_rounded,
                ),
              ),
        
              const SizedBox(height: 32),
        
              // ── Submit Button ───────────────────
              Obx(() => SizedBox(
                width: double.infinity,
                height: 56,
                child: GradientElevatedButton(
                  onPressed: controller.isLoading.value
                    ? null
                    : () => controller.forgotPassword(email: emailController.text),
                  child: controller.isLoading.value
                    ? const ButtonLoader()
                    : const Text(
                        'Send Reset Link',
                        style: AppTextStyles.authButtonText,
                      ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}