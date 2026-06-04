import 'package:get/get.dart';

class SettingsController extends GetxController{
  RxBool isDarkMode = false.obs;
  RxBool enableNotifications = false.obs;


  void toggleThemeMode() => isDarkMode.value = !isDarkMode.value;
  void toggleNotifications() => enableNotifications.value = !enableNotifications.value;
}