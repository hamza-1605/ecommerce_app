import 'package:ecommerce/core/constants/app_constants.dart';
import 'package:ecommerce/core/widgets/custom_back_button.dart';
import 'package:ecommerce/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ecommerce/features/auth/presentation/widgets/build_label.dart';
import 'package:ecommerce/features/auth/presentation/widgets/build_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterationPage extends GetView<AuthController> {
  const RegisterationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final emailController    = TextEditingController();
    final passwordController = TextEditingController();
    final obscurePassword    = true.obs;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(),
              const SizedBox(height: 32),

              // ── Header ──────────────────────────────
              const Text(
                'Create Account.',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                signUpMessage,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF888888),
                ),
              ),

              const SizedBox(height: 48),

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
              )),

              const SizedBox(height: 40),

              // ── Register Button ──────────────────────
              Obx(() => SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.registerUser(
                            username: usernameController.text.trim(),
                            email:    emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF888888),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
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
                    style: TextStyle(color: Color(0xFF888888), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}