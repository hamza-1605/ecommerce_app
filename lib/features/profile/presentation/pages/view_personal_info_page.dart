import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/core/widgets/background_svg.dart';
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/core/widgets/info_row.dart';
import 'package:ekart/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ekart/features/profile/presentation/state/controller/user_profile_controller.dart';
import 'package:ekart/features/profile/presentation/widgets/section_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class ViewPersonalInfoPage extends GetView<UserProfileController> {
  const ViewPersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70.0), 
        child: CustomizedAppbar( backButton: true, title: "View Profile"),
      ),
      
      body: Stack( 
        fit: StackFit.expand,
        alignment: AlignmentGeometry.center,
        children: [
          BackgroundSvg(),
          
          Padding(
            padding: EdgeInsets.all(24),
            child: Obx(() {
              final profile = controller.profile.value;
          
              if (profile == null) {
                return const Center(child: CircularProgressIndicator());
              }
          
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Info Cards ────────────────────────
                    SectionContainer(
                      title: 'Personal Info', 
                      rows: [
                        InfoRow( icon: Icons.person_outline,          label: 'Full Name',       value: profile.fullName ?? ''),
                        InfoRow( icon: Icons.mail_outline_rounded,    label: 'Email',           value: Get.find<AuthController>().currentUser.value?.email ?? '-'),
                        InfoRow( icon: Icons.phone_outlined,          label: 'Phone',           value: profile.phone  ?? ''),
                        InfoRow( icon: Icons.person_outline_rounded,  label: 'Gender',          value: profile.gender  ?? ''),
                        InfoRow( icon: Icons.cake_outlined,           label: 'Date Of Birth',   value: profile.dob != null
                            ? '${profile.dob?.day}/${profile.dob!.month}/${profile.dob!.year}'
                            : ''
                        ),
                      ]
                    ),
                
                    const SizedBox(height: 30),
                
                    SectionContainer(
                      title: 'Address',
                      rows: [
                        InfoRow(icon: Icons.location_on_outlined, label: 'Address',  value: profile.address ?? ''),
                        InfoRow(icon: Icons.location_city_outlined, label: 'City',  value: profile.city ?? ''),
                        InfoRow(icon: Icons.map_outlined, label: 'Country',  value: profile.country ?? ''),
                        InfoRow(icon: Icons.pin_outlined, label: 'Postal Code',  value: profile.postalCode ?? ''),
                      ]
                    ),
        
                    SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: GradientElevatedButton.icon(
                        icon: Icon(Icons.edit),
                        label: Text("Edit Profile"),
                        onPressed: () => Get.toNamed( AppRoutes.editProfile ), 
                      ),
                    )
                  ],
                ),
              );
            }), 
          ),
      ])
    );
  }
}