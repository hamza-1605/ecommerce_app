import 'package:ecommerce/core/network/api_services.dart';
import 'package:ecommerce/core/utils/helper_functions.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ManageAdminsController extends GetxController {
  final RxList<dynamic> searchResults  = <dynamic>[].obs;
  final RxBool          isSearching    = false.obs;
  final RxBool          isUpdating     = false.obs;
  final RxString        searchQuery    = ''.obs;

  final ApiServices _apiServices = Get.find<ApiServices>();



  // ── SEARCH ──────────────────────────────────────────
  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    try {
      final response = await _apiServices.searchUsers(query.trim());
      if (response.success) {
        final currentUserId = GetStorage().read('user_id');
        final filtered = (response.data as List)
            .where( (u) => u['id'] != currentUserId )     // Don't include current admin from results
            .toList();
        searchResults.assignAll(filtered);
      } 
      else {
        throw Exception(response.message);
      }
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title:   'Error',
        message: e.toString(),
        isError: true,
      );
    } 
    finally {
      isSearching.value = false;
    }
  }



  // ── TOGGLE ADMIN ────────────────────────────────────
  Future<void> toggleAdmin({
    required int  userId,
    required bool currentStatus,
  }) async {
    isUpdating.value = true;
    try {
      final newStatus = !currentStatus;

      await _apiServices.updateUserAdminStatus(
        userId:  userId,
        isAdmin: newStatus,
      );

      // Update locally
      final index = searchResults.indexWhere( (u) => u['id'] == userId );
      if (index != -1) {
        searchResults[index] = {
          ...searchResults[index],
          'isAdmin': newStatus,
        };
        searchResults.refresh();
      }

      HelperFunctions.showSnackbar(
        title:   'Success',
        message: newStatus
          ? 'User promoted to Admin'
          : 'User demoted to regular user',
      );
    } 
    catch (e) {
      HelperFunctions.showSnackbar(
        title:   'Error',
        message: e.toString(),
        isError: true,
      );
    } 
    finally {
      isUpdating.value = false;
    }
  }
}