import 'package:boozin_fitness/app/locales/locales.dart';
import 'package:boozin_fitness/app/modules/home/controllers/home_controller.dart';
import 'package:boozin_fitness/theme/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  /// Initialize the storage
  await GetStorage.init();

  /// Create the controller for global access on both splash and home screen
  Get.put(HomeController());
  runApp(
    GetMaterialApp(
      translations: AppLocales(),
      locale: const Locale("en", "US"),
      fallbackLocale: const Locale("en", "US"),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      title: "boozin_fitness".tr,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
