import 'package:ecommerce/core/utils/helper_functions.dart';
import 'package:ecommerce/core/widgets/custom_back_button.dart';
import 'package:ecommerce/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ecommerce/features/auth/presentation/widgets/build_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordPage extends GetView<AuthController> {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final codeController            = TextEditingController();
    final passwordController        = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final obscurePassword           = true.obs;
    final obscureConfirm            = true.obs;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBackButton(),
                SizedBox(height: 20),
          
                // ── Header ──────────────────────────
                const Text(
                  'Reset\nPassword.',
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
                  'Enter the code from your email and your new password.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF888888),
                  ),
                ),
          
                const SizedBox(height: 40),
          
                // ── Code Field ──────────────────────
                LabelText(text: 'Reset Code'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller:  codeController,
                  hint:        'Paste code from email',
                  prefixIcon:  Icons.key_outlined,
                ),
          
                const SizedBox(height: 24),
          
                // ── New Password ────────────────────
                LabelText(text: 'New Password'),
                const SizedBox(height: 8),
                Obx(() => _buildTextField(
                  controller: passwordController,
                  hint:       '••••••••',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscure:    obscurePassword.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF888888),
                      size: 20,
                    ),
                    onPressed: () =>
                        obscurePassword.value = !obscurePassword.value,
                  ),
                )),
          
                const SizedBox(height: 24),
          
                // ── Confirm Password ────────────────
                LabelText(text: 'Confirm Password'),
                const SizedBox(height: 8),
                Obx(() => _buildTextField(
                  controller: confirmPasswordController,
                  hint:       '••••••••',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscure:    obscureConfirm.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirm.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF888888),
                      size: 20,
                    ),
                    onPressed: () =>
                        obscureConfirm.value = !obscureConfirm.value,
                  ),
                )),
          
                const SizedBox(height: 40),
          
                // ── Submit Button ───────────────────
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            // Validate fields
                            if (codeController.text.trim().isEmpty) {
                              HelperFunctions.showSnackbar(
                                title:   'Code Required',
                                message: 'Please enter the reset code from your email',
                                isError: true,
                              );
                              return;
                            }
                            if (passwordController.text.trim().length < 6) {
                              HelperFunctions.showSnackbar(
                                title:   'Weak Password',
                                message: 'Password must be at least 6 characters',
                                isError: true,
                              );
                              return;
                            }
                            if (passwordController.text.trim() !=
                                confirmPasswordController.text.trim()) {
                              HelperFunctions.showSnackbar(
                                title:   'Passwords Mismatch',
                                message: 'Passwords do not match',
                                isError: true,
                              );
                              return;
                            }
                            controller.resetPassword(
                              code:                 codeController.text.trim(),
                              password:             passwordController.text.trim(),
                              passwordConfirmation: confirmPasswordController.text.trim(),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 22, height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String                hint,
    required IconData              prefixIcon,
    bool                           obscure    = false,
    Widget?                        suffixIcon,
  }) {
    return Container(
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
      child: TextField(
        controller:  controller,
        obscureText: obscure,
        style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
        decoration: InputDecoration(
          hintText:   hint,
          hintStyle:  const TextStyle(
            color: Color(0xFFBBBBBB), fontSize: 15),
          prefixIcon: Icon(prefixIcon,
              color: const Color(0xFF888888), size: 20),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:   BorderSide.none,
          ),
          filled:         true,
          fillColor:      Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 18),
        ),
      ),
    );
  }
}