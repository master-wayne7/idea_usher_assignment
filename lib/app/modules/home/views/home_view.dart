import 'package:boozin_fitness/app/modules/home/views/widgets/data_card.dart';
import 'package:boozin_fitness/app/services/app_services.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  /// Home screen of the app
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          'hi'.tr,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, fontFamily: "Nunito"),
        ),
        actions: [
          /// Button to change the language
          TextButton(
            onPressed: () => Get.updateLocale(
              Get.locale == const Locale("en", "US") ? const Locale("hi", "IN") : const Locale("en", "US"),
            ),
            child: Text(
              Get.locale == const Locale("en", "US") ? "Hindi" : "English",
              style: TextStyle(fontFamily: "Nunito", color: Get.theme.focusColor),
            ),
          )
        ],
      ),
      body: Center(
        /// Observer to show the data only when the user is authorized
        child: Obx(() {
          switch (controller.isAuthorized.value) {
            case false:

              /// auth button to authorize manually
              return ElevatedButton(
                onPressed: () async => await controller.authorize(),
                child: Text(
                  'authorize'.tr,
                  style: TextStyle(fontFamily: "Nunito", color: Get.theme.focusColor),
                ),
              );
            case true:

              /// Will show the data
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  GestureDetector(
                    /// Will open the goal setting bottom sheet for steps
                    onTap: () => openBottomSheet(BottomSheetType.steps),
                    child: DataCard(
                      goal: controller.stepsGoal.value,
                      icon: "footsteps",
                      title: "steps".tr,
                      value: controller.nofSteps.value,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    /// Will open bottom shett for setting cal goals
                    onTap: () => openBottomSheet(BottomSheetType.calories),
                    child: DataCard(
                      goal: controller.caloriesGoal.value,
                      icon: "kcal",
                      title: "calories_burned".tr,
                      value: controller.calories.value,
                    ),
                  ),
                ],
              );

            default:

              /// Defualt error text
              return Text('error_fetching_data'.tr);
          }
        }),
      ),
    );
  }
}
