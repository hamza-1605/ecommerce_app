import 'package:ecommerce/features/home/presentation/state/controller/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.put( HomeController(), permanent: true );
  }
}