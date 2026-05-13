import 'dart:io';
import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/core/widgets/custom_outlined_button.dart';
import 'package:ekart/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ekart/features/profile/presentation/state/controller/user_profile_controller.dart';
import 'package:ekart/features/wishlist/presentation/state/controller/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends GetView<UserProfileController> {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
      
        final profile = controller.profile.value;
      
        return Scaffold(
          backgroundColor: const Color(0xFFF8F6F3),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ────────────────────────────
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
      
                  const SizedBox(height: 32),
      
                  // ── Avatar ────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Obx(() {
                          final profile = controller.profile.value;
                          return Stack(
                            alignment: AlignmentGeometry.center,
                            children: [
                              // ── Avatar ──────────────────────────
                              CircleAvatar(
                                radius: 54,
                                backgroundColor: Colors.black,
                              ),
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
      
                  GestureDetector(
                    onTap: () => Get.toNamed(
                      AppRoutes.viewProfileDetails,
                      arguments: profile
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Personal Info',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1A1A),
                                  )),
                                SizedBox(height: 2),
                                // Show count
                                Text(
                                  'View or Edit your info',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF888888),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              size: 14, color: Color(0xFF888888)),
                        ],
                      ),
                    ),
                  ),
      
                  
                  const SizedBox(height: 24),
      
                  // ── My Favourites ──────────────────────────
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.wishlist),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Colors.red.shade400,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('My Favourites',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1A1A),
                                  )),
                                SizedBox(height: 2),
                                // ✅ Show count
                                Obx( () => Text(
                                  '${Get.find<WishlistController>().items.length} items',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF888888),
                                  ),
                                )),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              size: 14, color: Color(0xFF888888)),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 42),
      
                  // ── Logout Button ─────────────────────
                  CustomOutlinedButton(
                    label: "Log Out", 
                    function: () => Get.find<AuthController>().logout(), 
                    iconData: Icons.logout, 
                    color: Colors.red
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
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