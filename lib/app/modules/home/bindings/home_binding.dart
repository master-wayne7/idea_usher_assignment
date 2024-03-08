import 'package:get/get.dart';

import '../controllers/home_controller.dart';

/// Will bind the HomeController to the home page
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<HomeController>();
  }
}
