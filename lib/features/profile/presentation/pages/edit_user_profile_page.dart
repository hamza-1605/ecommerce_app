import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/core/widgets/button_loader.dart';
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/features/auth/presentation/widgets/label_text.dart';
import 'package:ekart/features/profile/domain/entities/user_profile_entity.dart';
import 'package:ekart/features/profile/presentation/widgets/edit_profile_field.dart';
import 'package:ekart/features/profile/presentation/widgets/title_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ekart/features/profile/presentation/state/controller/user_profile_controller.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class EditUserProfilePage extends GetView<UserProfileController> {
  const EditUserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = controller.profile.value;

    // Pre-fill controllers
    final fullNameController   = TextEditingController(text: profile?.fullName   ?? '');
    final phoneController      = TextEditingController(text: profile?.phone      ?? '');
    final addressController    = TextEditingController(text: profile?.address    ?? '');
    final cityController       = TextEditingController(text: profile?.city       ?? '');
    final countryController    = TextEditingController(text: profile?.country    ?? '');
    final postalCodeController = TextEditingController(text: profile?.postalCode ?? '');
    final RxnString selectedGender = RxnString(profile?.gender);
    final selectedDob          = Rx<DateTime?>(profile?.dob);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 85.0), 
        child: CustomizedAppbar(
          title: "Edit Profile", 
          actionsNeeded: false,
          backButton: true,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Personal Info ──────────────────────────────────────────────────
            TitleSection( title: 'Personal Info'),
            EditProfileField(label: 'Full Name',  hintText: "Your Name",  controller:  fullNameController,  icon: Icons.person_outline_rounded),
            EditProfileField(label: 'Phone',  hintText: "Phone No.",  controller:  phoneController,     icon: Icons.phone_outlined, keyboard: TextInputType.phone),
      
            // ── Gender ─────────────────────────────
            const SizedBox(height: 16),
            LabelText(text: 'Gender'),
            const SizedBox(height: 8),
      
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
      
                // ── Gender Options ─────────────────────
                Wrap(
                  runSpacing: 10,
                  children: ['Male', 'Female', 'Rather Not Say']
                      .map(
                        (gender) => GestureDetector(
                          onTap: () => selectedGender.value = gender,
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: selectedGender.value == gender
                                  ? AppColors.appMainColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: Text(
                              gender,
                              style: TextStyle(
                                color: selectedGender.value == gender
                                    ? Colors.white
                                    : const Color(0xFF1A1A1A),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
      
                // ── Clear Selection Button ─────────────
                if (selectedGender.value != null) ...[
                  const SizedBox(height: 8),
      
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => selectedGender.value = null,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Clear Selection',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            )),
      
      
            // ── Date of Birth ──────────────────────
            const SizedBox(height: 24),
            LabelText(text: 'Date of Birth'),
            const SizedBox(height: 8),
            
            Obx(() => GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDob.value ?? DateTime(2000),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
      
                if (picked != null) {
                  selectedDob.value = picked;
                }
              },
      
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
      
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
      
                child: Row(
                  children: [
      
                    const Icon(
                      Icons.cake_outlined,
                      color: Color(0xFF888888),
                      size: 20,
                    ),
      
                    const SizedBox(width: 12),
      
                    Expanded(
                      child: Text(
                        selectedDob.value != null
                            ? '${selectedDob.value!.day}/${selectedDob.value!.month}/${selectedDob.value!.year}'
                            : 'Select date of birth',
      
                        style: TextStyle(
                          color: selectedDob.value != null
                              ? const Color(0xFF1A1A1A)
                              : const Color(0xFFBBBBBB),
                          fontSize: 15,
                        ),
                      ),
                    ),
      
                    // ── Clear Button ─────────────────────
                    if (selectedDob.value != null)
                      GestureDetector(
                        onTap: () {
                          selectedDob.value = null;
                        },
      
                        child: Container(
                          padding: const EdgeInsets.all(4),
      
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
      
                          child: Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )),
      
            const SizedBox(height: 40),
      
      
            // ── Address ────────────────────────────────────────────────────────
            TitleSection(title: 'Address'),
            EditProfileField(label: 'Street Address',  hintText: "House 46, Street 3",  controller: addressController,    icon: Icons.location_on_outlined),
            EditProfileField(label: 'City',  hintText: "Lahore",  controller: cityController,       icon: Icons.location_city_outlined),
            EditProfileField(label: 'Country',  hintText: "Pakistan",  controller: countryController,    icon: Icons.map_outlined),
            EditProfileField(label: 'Postal Code',   hintText: "54000",    controller: postalCodeController, icon: Icons.pin_outlined, keyboard: TextInputType.number),
      
      
            const SizedBox(height: 28),
      
      
            // ── Save Button ────────────────────────
            Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: GradientElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () => controller.updateProfile(
                          updatedProfile: UserProfileEntity(
                            documentId:   profile?.documentId,
                            fullName:     fullNameController.text.trim(),
                            phone:        phoneController.text.trim(),
                            address:      addressController.text.trim(),
                            city:         cityController.text.trim(),
                            country:      countryController.text.trim(),
                            postalCode:   postalCodeController.text.trim(),
                            gender:       selectedGender.value,
                            dob:          selectedDob.value,
                            profileImage: profile?.profileImage,
                          ),
                        ),
                
                child: controller.isSubmitting.value
                    ? const ButtonLoader()
                    : const Text('Save Changes'),
              ),
            )),
          ],
        ),
      ),
    );
  }
}