import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/core/widgets/custom_back_button.dart';
import 'package:ekart/core/widgets/custom_outlined_button.dart';
import 'package:ekart/core/widgets/info_row.dart';
import 'package:ekart/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ekart/features/profile/presentation/state/controller/user_profile_controller.dart';
import 'package:ekart/features/profile/presentation/widgets/section_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewPersonalInfoPage extends GetView<UserProfileController> {
  const ViewPersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Obx(() {
            final profile = controller.profile.value;

            if (profile == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const CustomBackButton(),
                        const SizedBox(width: 10),
                        const Text(
                          'View Profile',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 36),
                
                    // ── Info Cards ────────────────────────
                    SectionContainer(
                      title: 'Personal Info', 
                      rows: [
                        InfoRow( icon: Icons.person_outline,    label: 'Full Name',       value: profile.fullName ?? ''),
                        InfoRow( icon: Icons.mail_outline_rounded,    label: 'Email',           value: Get.find<AuthController>().currentUser.value?.email ?? '-'),
                        InfoRow( icon: Icons.phone_outlined,          label: 'Phone',           value: profile.phone  ?? ''),
                        InfoRow( icon: Icons.person_outline_rounded,  label: 'Gender',          value: profile.gender  ?? ''),
                        InfoRow( icon: Icons.cake_outlined,           label: 'Date Of Birth',   value: profile.dob != null
                            ? '${profile.dob?.day}/${profile.dob!.month}/${profile.dob!.year}'
                            : ''
                        ),
                      ]
                    ),
                
                    const SizedBox(height: 24),
                
                    SectionContainer(
                      title: 'Address',
                      rows: [
                        InfoRow(icon: Icons.location_on_outlined, label: 'Address',  value: profile.address ?? ''),
                        InfoRow(icon: Icons.location_city_outlined, label: 'City',  value: profile.city ?? ''),
                        InfoRow(icon: Icons.map_outlined, label: 'Country',  value: profile.country ?? ''),
                        InfoRow(icon: Icons.pin_outlined, label: 'Postal Code',  value: profile.postalCode ?? ''),
                      ]
                    ),

                    SizedBox(height: 24,),

                    CustomOutlinedButton(
                      label: 'Edit Profile', 
                      function: () => Get.toNamed( AppRoutes.editProfile ), 
                      iconData: Icons.edit, 
                      color: Colors.blue
                    ),
                  ],
                ),
              ],
            );
          }), 
        ),
      ),
    );
  }
}