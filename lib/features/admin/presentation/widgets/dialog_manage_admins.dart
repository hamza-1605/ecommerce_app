import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/features/admin/presentation/controllers/manage_admins_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogManageAdmins extends StatelessWidget {
  const DialogManageAdmins({super.key, required this.controller, required this.userId, required this.username, required this.currentStatus});
  final ManageAdminsController controller;
  final int userId;
  final String username;
  final bool currentStatus;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      title: Text(
        currentStatus ? 'Demote User' : 'Promote User',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      content: Text(
        currentStatus
          ? 'Remove admin privileges from $username?'
          : 'Grant admin privileges to $username?',
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel',
              style: TextStyle(color: Color(0xFF888888))),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            controller.toggleAdmin(
              userId: userId,
              currentStatus: currentStatus,
            );
          },
          child: Text(
            currentStatus ? 'Demote' : 'Promote',
            style: TextStyle(
              color:      currentStatus ? Colors.red : AppColors.appMainColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}