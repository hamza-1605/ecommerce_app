import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/core/themes/app_decorations.dart';
import 'package:flutter/material.dart';

class AdminActionsMenu extends StatelessWidget {
  const AdminActionsMenu({super.key, required this.onEdit, required this.onDelete, required this.isDeleting});
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: AppDecorations.containerDecoration,
        child: const Icon(Icons.more_vert, color: Color(0xFF1A1A1A)),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      itemBuilder: (_) => [

        // ── Edit ──────────────────────────────
        PopupMenuItem(
          onTap: onEdit,
          child: const Row(
            children: [
              Icon(Icons.edit_outlined, size: 18, color: Color(0xFF1A1A1A)),
              SizedBox(width: 10),
              Text('Edit', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),

        // ── Delete ────────────────────────────
        PopupMenuItem(
          onTap: isDeleting ? null : onDelete,
          child: Row(
            children: [
              isDeleting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.error),
                  )
                : const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
              const SizedBox(width: 10),
              const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.error)),
            ],
          ),
        ),
      ],
    );
  }
}