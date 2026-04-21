// features/profile/presentation/pages/user_profile_page.dart

import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ecommerce/features/profile/presentation/state/controller/user_profile_controller.dart';
import 'package:ecommerce/features/profile/presentation/widgets/info_row.dart';
import 'package:ecommerce/features/profile/presentation/widgets/section_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfilePage extends GetView<UserProfileController> {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final profile = controller.profile.value;

      return Scaffold(
        backgroundColor: const Color(0xFFF8F6F3),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Header ────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.toNamed(AppRoutes.editProfile),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: const Icon(Icons.edit_outlined, size: 18),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ── Avatar ────────────────────────────
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: const Color(0xFFE0E0E0),
                        backgroundImage: profile?.profileImage != null
                            ? NetworkImage(profile!.profileImage!)
                            : null,
                        child: profile?.profileImage == null
                            ? const Icon(Icons.person_rounded, size: 48, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile?.fullName ?? 'No name set',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // ── Info Cards ────────────────────────
                SectionContainer(
                  title: 'Personal Info', 
                  rows: [
                    InfoRow( icon: Icons.person_outline_rounded,  label: 'Gender',          value: profile?.gender  ?? '-'),
                    InfoRow( icon: Icons.mail_outline_rounded,    label: 'Email',           value: Get.find<AuthController>().currentUser.value?.email ?? '-'),
                    InfoRow( icon: Icons.phone_outlined,          label: 'Phone',           value: profile?.phone   ?? '-'),
                    InfoRow( icon: Icons.cake_outlined,           label: 'Date Of Birth',   value: profile?.dob != null
                        ? '${profile!.dob!.day}/${profile.dob!.month}/${profile.dob!.year}'
                        : '-'
                    ),
                  ]
                ),

                const SizedBox(height: 24),

                SectionContainer(
                  title: 'Address',
                  rows: [
                    InfoRow(icon: Icons.location_on_outlined, label: 'Address',  value: profile?.address ?? '-'),
                    InfoRow(icon: Icons.location_city_outlined, label: 'City',  value: profile?.city ?? '-'),
                    InfoRow(icon: Icons.map_outlined, label: 'Country',  value: profile?.country ?? '-'),
                    InfoRow(icon: Icons.pin_outlined, label: 'Postal Code',  value: profile?.postalCode ?? '-'),
                  ]
                ),

                const SizedBox(height: 36),

                // ── Logout Button ─────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => Get.find<AuthController>().logout(),
                    icon: const Icon(Icons.logout_rounded, color: Colors.red),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}