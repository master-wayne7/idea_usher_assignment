import 'package:boozin_fitness/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// To format the numbers in the indian number system by inserting commas
String formatUnit(int number) {
  final unitFormatter = NumberFormat(
    "##,##,###",
    "en_IN",
  );
  return unitFormatter.format(number);
}

enum BottomSheetType {
  steps,
  calories
}

/// Bottom shett for setting goals based on the type
void openBottomSheet(BottomSheetType type) {
  HomeController controller = Get.find();

  /// To set the initial text for textediting controller
  controller.textEditingController.text = type == BottomSheetType.calories ? controller.caloriesGoal.toString() : controller.stepsGoal.toString();
  Get.bottomSheet(
    ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        color: Get.theme.primaryColor,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              type == BottomSheetType.calories ? 'set_calories_goal'.tr : 'set_steps_goal'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Nunito"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.textEditingController,
              keyboardType: TextInputType.number,
              cursorColor: Get.theme.focusColor,
              decoration: InputDecoration(
                focusColor: Get.theme.focusColor,
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Get.theme.focusColor), borderRadius: BorderRadius.circular(10)),
                labelText: type == BottomSheetType.calories ? 'calories_goal'.tr : 'steps_goal'.tr,
                labelStyle: TextStyle(color: Get.theme.focusColor, fontFamily: "Nunito"),
                border: OutlineInputBorder(borderSide: BorderSide(color: Get.theme.focusColor), borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (val) {
                int value = int.tryParse(val) ?? 0;

                /// To set the values iff they are within the desired range
                if (type == BottomSheetType.calories) {
                  if (value > 99 && value < 4001) {
                    controller.updateTempCaloriesGoal(value.toInt());
                  }
                } else {
                  if (value > 999 && value < 20001) {
                    controller.updateTempStepsGoal(value.toInt());
                  }
                }
              },
            ),
            const SizedBox(height: 20),

            /// slider widget
            Obx(() {
              return Slider(
                activeColor: Get.theme.focusColor,
                inactiveColor: Get.theme.disabledColor,
                value: type == BottomSheetType.calories ? controller.tempCaloriesGoal.toDouble() : controller.tempStepsGoal.toDouble(),
                min: type == BottomSheetType.calories ? 100 : 1000,
                max: type == BottomSheetType.calories ? 4000 : 20000,
                label: type == BottomSheetType.calories ? formatUnit(controller.tempCaloriesGoal.value) : formatUnit(controller.tempStepsGoal.value),
                onChanged: (value) => type == BottomSheetType.calories ? controller.updateTempCaloriesGoal(value.toInt()) : controller.updateTempStepsGoal(value.toInt()),
              );
            }),
            const SizedBox(height: 20),

            /// Save button
            TextButton(
              onPressed: () async {
                try {
                  /// will write the goals to local storage to persist the data
                  type == BottomSheetType.calories ? await controller.storage.write('caloriesGoal', controller.tempCaloriesGoal.value) : await controller.storage.write('stepsGoal', controller.tempStepsGoal.value);

                  /// update the original goals
                  if (type == BottomSheetType.steps) {
                    controller.updateStepsGoal(controller.tempStepsGoal.value);
                  } else {
                    controller.updateCaloriesGoal(controller.tempCaloriesGoal.value);
                  }
                  Get.back();
                  Get.snackbar("success".tr, "goal_was_set_sccuessfully".tr);
                } catch (e) {
                  Get.back();
                  Get.snackbar("error".tr, "goal_was_not_set".tr);
                }
              },
              child: Text(
                'save'.tr,
                style: TextStyle(fontFamily: "Nunito", color: Get.theme.focusColor),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
