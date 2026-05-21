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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.more_vert, color: Color(0xFF1A1A1A), size: 18),
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
          onTap: isDeleting ? null : onDelete, // 👈 disabled while deleting
          child: Row(
            children: [
              isDeleting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFE53935)),
                    )
                  : const Icon(Icons.delete_outline, size: 18, color: Color(0xFFE53935)),
              const SizedBox(width: 10),
              const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE53935))),
            ],
          ),
        ),
      ],
    );
  }
}