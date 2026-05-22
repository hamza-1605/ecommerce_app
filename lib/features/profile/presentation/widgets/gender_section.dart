import 'package:ekart/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenderSection extends StatelessWidget {
  const GenderSection({super.key, required this.selectedGender, required this.onTap});
  final RxnString selectedGender;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Obx( () =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            
          // ── Gender Options ─────────────────────
          Wrap(
            runSpacing: 10,
            children: ['Male', 'Female', 'Rather Not Say']
                .map(
                  (gender) => GestureDetector(
                    onTap: () => onTap(gender),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 10),
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
      ),
    );
  }
}