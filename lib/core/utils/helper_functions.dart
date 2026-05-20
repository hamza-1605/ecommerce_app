import 'package:ekart/features/profile/domain/entities/user_profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelperFunctions {
  static void showSnackbar({
    required String title,
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }){
    Get.snackbar(
      title, 
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.red[100] : Colors.green[100],
      icon: Icon(
        isError ? Icons.error : Icons.check_circle,
        color: isError ? Colors.red[700] : Colors.green[700],
      ),
      dismissDirection: DismissDirection.vertical,
      margin: EdgeInsets.all(15.0),
      borderRadius: 15,
      duration: duration,
    );
  }


  static void showLoadingDialog({String message = "Loading..."}){
    Get.dialog( 
      AlertDialog(
        content: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 15),
            Text(message),
          ],
        ),
      ),  
      barrierDismissible: false
    );
  }
  


// ------------------------------ CheckOut Builders -----------------------------------
  String buildAddressFromProfile(UserProfileEntity? profile) {
    if (profile == null) return '';
    
    final parts = [
      profile.address,
      profile.city,
      profile.country,
      profile.postalCode,
    ].where( (p) => p != null && p.isNotEmpty ).toList();
    
    return parts.join(', ');
  }


   Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }


  Widget buildPriceRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 15 : 14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: bold ? const Color(0xFF1A1A1A) : const Color(0xFF888888),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 18 : 14,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
  

  // Display Error Messages in Snackbars
  String msg(Object e) => e.toString().replaceFirst('Exception: ', '');
}