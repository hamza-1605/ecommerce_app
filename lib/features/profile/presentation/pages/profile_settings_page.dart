import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/core/widgets/background_svg.dart';
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/features/profile/presentation/state/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSettingsPage extends GetView<SettingsController> {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 70),
        child: const CustomizedAppbar(
          title: "Settings",
          backButton: true,
        ),
      ),

      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          const BackgroundSvg(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Set your Preferences", style: AppTextStyles.titleLarge,),
                SizedBox(height: 10),
                Obx(
                  () => SwitchListTile(
                    title: Text("Dark Mode"),
                    secondary: Icon(Icons.dark_mode),
                    value: controller.isDarkMode.value,
                    onChanged: (value) => controller.toggleThemeMode(),
                  ),
                ),

                Obx(
                  () => SwitchListTile(
                    title: Text("Enable Notifications"),
                    secondary: Icon(Icons.notifications),
                    value: controller.enableNotifications.value,
                    onChanged: (value) => controller.toggleNotifications(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}