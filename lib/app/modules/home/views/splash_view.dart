import 'dart:async';

import 'package:boozin_fitness/app/modules/home/controllers/home_controller.dart';
import 'package:boozin_fitness/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class SplashView extends GetView<HomeController> {
  /// Splash view to show animation while fetching data in background
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    /// will navigate to home after 4 seconds
    Timer(const Duration(seconds: 4), () {
      Get.offNamed(AppPages.HOME);
    });
    return Scaffold(
      body: Center(
        /// Lottie animation
        child: Lottie.asset("assets/lottie/fit.json"),
      ),
    );
  }
}
