import 'dart:io';

import 'package:ekart/core/network/api_services.dart';
import 'package:ekart/core/utils/helper_functions.dart';
import 'package:ekart/features/profile/domain/entities/user_profile_entity.dart';
import 'package:ekart/features/profile/domain/usecases/create_user_profile_usecase.dart';
import 'package:ekart/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:ekart/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserProfileController extends GetxController{
  final GetUserProfileUsecase getUserProfileUsecase;
  final UpdateUserProfileUsecase updateUserProfileUsecase;
  final CreateUserProfileUsecase createUserProfileUsecase; 
  UserProfileController(this.getUserProfileUsecase, this.updateUserProfileUsecase, this.createUserProfileUsecase);

  final Rx<UserProfileEntity?> profile = Rx<UserProfileEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    final userId = GetStorage().read('user_id');
    if (userId != null) {
      fetchProfile(userId: userId);
    }
  }


  Future<void> fetchProfile({required int userId}) async {
    isLoading.value = true;
    try {
      final result = await getUserProfileUsecase.call(userId: userId);
      profile.value = result;
    } 
    catch (e) {
       if (e.toString().contains('Profile not found')) {
        await _createEmptyProfile(userId: userId);           // ✅ auto-create
      } else {
        HelperFunctions.showSnackbar(
          title: 'Error',
          message: e.toString(),
          isError: true,
        );
      }
    }
    finally{
      isLoading.value = false;
    }
  }


  Future<void> updateProfile({required UserProfileEntity updatedProfile}) async {
    isSubmitting.value = true;

    try {
      final result = await updateUserProfileUsecase.call(profile: updatedProfile);
      profile.value = null;
      profile.value = result;
      Get.back();
      HelperFunctions.showSnackbar(
        title: 'Success', 
        message: 'Profile updated successfully'
      );
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error', 
        message: e.toString(),
        isError: true
      );
    }
    finally{
      isSubmitting.value = false;
    }
  }

  Future<void> _createEmptyProfile({required int userId}) async {
    try {
      final result = await createUserProfileUsecase.call(userId: userId);
      profile.value = result;
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: 'Could not create profile: $e',
        isError: true,
      );
    }
  }


  Future<void> uploadProfileImage(File imageFile) async {
    isSubmitting.value = true;
    try {
      // 1. Upload to Strapi media library
      final mediaId = await ApiServices().uploadImage(imageFile);
      
      // 1.1 Guard against null profile
      final currentProfile = profile.value;
      if (currentProfile == null) return;

      // 2. Update profile with new image id
      final updatedProfile = UserProfileEntity(
        documentId:   profile.value?.documentId,
        fullName:     profile.value?.fullName,
        phone:        profile.value?.phone,
        address:      profile.value?.address,
        city:         profile.value?.city,
        country:      profile.value?.country,
        postalCode:   profile.value?.postalCode,
        dob:          profile.value?.dob,
        gender:       profile.value?.gender,
        profileImage: mediaId.toString(),     // pass media id
      );

      final result = await updateUserProfileUsecase.call(profile: updatedProfile);
      profile.value = null;       
      profile.value = result;       // refresh profile
      
      // 3. Refetch to get full image URL
      final userId = GetStorage().read('user_id');
      await fetchProfile(userId: userId);

      HelperFunctions.showSnackbar(
        title:   'Success',
        message: 'Profile photo updated',
      );
    } catch (e) {
      HelperFunctions.showSnackbar(
        title:   'Error',
        message: e.toString(),
        isError: true,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> removeProfileImage() async {
    isSubmitting.value = true;
    try {
      final updatedProfile = UserProfileEntity(
        documentId:   profile.value?.documentId,
        fullName:     profile.value?.fullName,
        phone:        profile.value?.phone,
        address:      profile.value?.address,
        city:         profile.value?.city,
        country:      profile.value?.country,
        postalCode:   profile.value?.postalCode,
        dob:          profile.value?.dob,
        gender:       profile.value?.gender,
        profileImage: null,                   // ✅ clear image
      );

      await updateUserProfileUsecase.call(profile: updatedProfile);

      profile.value = null;
      profile.value = updatedProfile;

      HelperFunctions.showSnackbar(
        title:   'Removed',
        message: 'Profile photo removed',
      );
    } catch (e) {
      HelperFunctions.showSnackbar(
        title:   'Error',
        message: e.toString(),
        isError: true,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}