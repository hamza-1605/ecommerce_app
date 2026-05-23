import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

// ── Payment Option Card Widget ─────────────────────────
class PaymentOptionCard extends StatelessWidget {
  final IconData icon;
  final String   title;
  final String   subtitle;
  final bool     isSelected;
  final VoidCallback onTap;

  const PaymentOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.containerDecoration.copyWith(
          border: Border.all(
            color: isSelected ? AppColors.appMainColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.appMainColor
                    : AppColors.bottomNavbar ,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isSelected
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.appMainColor,
              ),
          ],
        ),
      ),
    );
  }
}