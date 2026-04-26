// features/profile/presentation/pages/user_profile_page.dart

import 'dart:io';

import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ecommerce/features/profile/presentation/state/controller/user_profile_controller.dart';
import 'package:ecommerce/features/profile/presentation/widgets/info_row.dart';
import 'package:ecommerce/features/profile/presentation/widgets/section_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
                // Replace the existing avatar section in UserProfilePage
                Center(
                  child: Column(
                    children: [
                      Obx(() {
                        final profile = controller.profile.value;
                        return Stack(
                          children: [
                            // ── Avatar ──────────────────────────
                            CircleAvatar(
                              radius: 52,
                              backgroundColor: const Color(0xFFE0E0E0),
                              backgroundImage: profile?.profileImage != null
                                  ? NetworkImage(profile!.profileImage!)
                                  : null,
                              child: profile?.profileImage == null
                                  ? const Icon(
                                      Icons.person_rounded,
                                      size: 52,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),

                            // ── Edit button ──────────────────────
                            Positioned(
                              bottom: 0, right: 0,
                              child: GestureDetector(
                                onTap: () => _showImageOptions(context),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A1A1A),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 12),

                      Obx(() => Text(
                        controller.profile.value?.fullName ?? 'No name set',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      )),
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


  void _showImageOptions(BuildContext context) {
    final controller = Get.find<UserProfileController>();
    final picker     = ImagePicker();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Handle bar
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 16),

              const Text('Profile Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                )),

              const SizedBox(height: 8),

              // ── Upload from gallery ──────────────
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F6F3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.photo_library_outlined,
                      color: Color(0xFF1A1A1A)),
                ),
                title: const Text('Choose from Gallery',
                  style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () async {
                  Get.back();
                  final picked = await picker.pickImage(
                    source:       ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    await controller.uploadProfileImage(File(picked.path));
                  }
                },
              ),

              // ── Take photo ───────────────────────
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F6F3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt_outlined,
                      color: Color(0xFF1A1A1A)),
                ),
                title: const Text('Take a Photo',
                  style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () async {
                  Get.back();
                  final picked = await picker.pickImage(
                    source:       ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    await controller.uploadProfileImage(File(picked.path));
                  }
                },
              ),

              // ── Remove photo — only if exists ────
              if (controller.profile.value?.profileImage != null)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.delete_outline,
                        color: Colors.red.shade400),
                  ),
                  title: Text('Remove Photo',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade400,
                    )),
                  onTap: () {
                    Get.back();
                    controller.removeProfileImage();
                  },
                ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

}