import 'package:ecommerce/core/widgets/custom_back_button.dart';
import 'package:ecommerce/features/auth/presentation/widgets/build_label.dart';
import 'package:ecommerce/features/profile/domain/entities/user_profile_entity.dart';
import 'package:ecommerce/features/profile/presentation/widgets/edit_profile_field.dart';
import 'package:ecommerce/features/profile/presentation/widgets/title_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/features/profile/presentation/state/controller/user_profile_controller.dart';

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
    final selectedGender       = (profile?.gender ?? '').obs;
    final selectedDob          = Rx<DateTime?>(profile?.dob);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F6F3),
        elevation: 0,
        leading: CustomBackButton(),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Personal Info ──────────────────────
            TitleSection( title: 'Personal Info'),
            EditProfileField(label: 'Full Name',  hintText: "Your Name",  controller:  fullNameController,  icon: Icons.person_outline_rounded),
            EditProfileField(label: 'Phone',  hintText: "Phone No.",  controller:  phoneController,     icon: Icons.phone_outlined, keyboard: TextInputType.phone),

            // ── Gender ─────────────────────────────
            const SizedBox(height: 16),
            LabelText(text: 'Gender'),
            const SizedBox(height: 8),
            
            Obx(() => Wrap(
              runSpacing: 10,
              children: ['Male', 'Female', 'Rather Not Say'].map((gender) =>
                GestureDetector(
                  onTap: () => selectedGender.value = gender,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedGender.value == gender
                          ? const Color(0xFF1A1A1A)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Text(
                      gender,
                      style: TextStyle(
                        color: selectedGender.value == gender ? Colors.white : const Color(0xFF1A1A1A),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ).toList(),
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
                if (picked != null) selectedDob.value = picked;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cake_outlined, color: Color(0xFF888888), size: 20),
                    const SizedBox(width: 12),
                    Text(
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
                  ],
                ),
              ),
            )),

            const SizedBox(height: 40),


            // ── Address ────────────────────────────
            TitleSection(title: 'Address'),
            EditProfileField(label: 'Street Address',  hintText: "House 46, Street 3",  controller: addressController,    icon: Icons.location_on_outlined),
            EditProfileField(label: 'City',  hintText: "Lahore",  controller: cityController,       icon: Icons.location_city_outlined),
            EditProfileField(label: 'Country',  hintText: "Pakistan",  controller: countryController,    icon: Icons.map_outlined),
            EditProfileField(label: 'Postal Code',   hintText: "54000",    controller: postalCodeController, icon: Icons.pin_outlined, keyboard: TextInputType.number),


            const SizedBox(height: 36),


            // ── Save Button ────────────────────────
            Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
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
                            gender:       selectedGender.value.isEmpty ? null : selectedGender.value,
                            dob:          selectedDob.value,
                            profileImage: profile?.profileImage,
                          ),
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}