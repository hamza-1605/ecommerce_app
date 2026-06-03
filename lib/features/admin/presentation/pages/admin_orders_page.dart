import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/core/utils/custom_divider.dart';
import 'package:ekart/core/widgets/background_svg.dart';
import 'package:ekart/core/widgets/blur_button.dart';
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/features/admin/presentation/widgets/order_list.dart';
import 'package:ekart/features/orders/presentation/state/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminOrdersPage extends GetView<OrderController> {
  const AdminOrdersPage({super.key});

  static const _tabs = ['All', 'Pending', 'Processing', 'Delivered', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = 0.obs; // 👈 local reactive index

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 70),
        child: CustomizedAppbar(
          title: "All Orders",
          anyWidget: BlurButton(
            buttonIconData: Icons.refresh_rounded,
            onPressed: () => controller.fetchAllOrders(),
          ),
        ),
      ),

      body: Stack(
        children: [
          const BackgroundSvg(),
          Column(
            children: [
              // ── Pill Tabs ───────────────────────────
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_tabs.length, (i) {
                      final isSelected = selectedIndex.value == i;
                      return GestureDetector(
                        onTap: () => selectedIndex.value = i,
                        child: AnimatedContainer(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          duration: const Duration(milliseconds: 200),
                          decoration: AppDecorations.pillContainer.copyWith(
                            color: isSelected
                              ? AppColors.appMainColor
                              : AppColors.cardBackground,
                          ),
                          child: Text(
                            _tabs[i],
                            style: AppTextStyles.titleSmall.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              )),

              const CustomDivider(indent: 20),
              // ── Order List ─────────────────────────
              Expanded(
                child: Obx(() => OrderList(
                  tab: _tabs[selectedIndex.value],
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}