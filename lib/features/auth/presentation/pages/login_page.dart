import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/core/constants/app_constants.dart';
import 'package:ecommerce/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ecommerce/features/auth/presentation/widgets/build_label.dart';
import 'package:ecommerce/features/auth/presentation/widgets/build_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController    = TextEditingController();
    final passwordController = TextEditingController();
    final obscurePassword    = true.obs;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Welcome\nBack.',
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
                loginMessage,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF888888),
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 52),

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
                    style: TextStyle(
                      color: Color.fromARGB(157, 26, 26, 26),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // ── Login Button ────────────────────────
              Obx(() => SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.loginUser(
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
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                ),
              )),

              const SizedBox(height: 32),

              // ── Register Link ───────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    noAccount,
                    style: TextStyle(color: Color(0xFF888888), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.register),
                    child: const Text(
                      'Register',
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