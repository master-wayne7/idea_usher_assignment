import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health/health.dart';

class HomeController extends GetxController {
  /// Init method invoked on controller creation
  @override
  void onInit() {
    super.onInit();
    textEditingController = TextEditingController();
    authorize();
    _loadGoalsFromStorage();
  }

  /// Dispose method for controller deletion
  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }

  /// Will store the list of data regarding the calories
  List<HealthDataPoint> _energy = [];

  /// Whether user is authorized or not
  final RxBool _authorized = false.obs;

  /// No of steps fetched from health package
  final RxInt _nofSteps = 0.obs;

  /// Total number of Kcal burned
  final RxInt _calories = 0.obs;

  /// Steps goal which can be set by user default 2500 steps
  final RxInt _stepsGoal = 2500.obs;

  /// Calories goal which can be set by user default 2000 Kcal
  final RxInt _caloriesGoal = 2000.obs;

  /// temporary goal which will be used to set the final value of goal
  /// will prevent unnecessary exceptions faced by directly changing the values of goal
  final RxInt _tempStepsGoal = 2500.obs;
  final RxInt _tempCaloriesGoal = 2000.obs;

  // getters
  List<HealthDataPoint> get energy => _energy;
  RxBool get isAuthorized => _authorized;
  RxInt get nofSteps => _nofSteps;
  RxInt get calories => _calories;
  RxInt get stepsGoal => _stepsGoal;
  RxInt get caloriesGoal => _caloriesGoal;
  RxInt get tempStepsGoal => _tempStepsGoal;
  RxInt get tempCaloriesGoal => _tempCaloriesGoal;

  /// Text editing controller for setting goals
  late TextEditingController textEditingController;

  /// Permission types required to fetch data
  static final types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  /// the final permissions in read mode
  final permissions = types.map((e) => HealthDataAccess.READ).toList();

  /// health package instance
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  /// storage instance for local storage
  final storage = GetStorage();

  /// Function to load goals from storage
  void _loadGoalsFromStorage() {
    if (storage.hasData('stepsGoal')) {
      _stepsGoal.value = storage.read('stepsGoal');
    }
    if (storage.hasData('caloriesGoal')) {
      _caloriesGoal.value = storage.read('caloriesGoal');
    }
  }

  /// Auth function to authorize user and fetch data
  Future<void> authorize() async {
    /// to check whether user was already authorized or not using local storage
    if (storage.hasData('auth')) {
      _authorized.value = await storage.read('auth');
      // If authorized fetch data
      if (_authorized.value) {
        await fetchStepData();
        await fetchEnergyData();
        return;
      }
    }
    // Not authorized
    /// to request permission for data reading
    bool hasPermissions = await health.hasPermissions(types, permissions: permissions) ?? false;

    // if permitted and not authorized
    if (!hasPermissions || !_authorized.value) {
      try {
        // request auth
        _authorized.value = await health.requestAuthorization(types, permissions: permissions);
        // will record that user is authorized or not
        storage.write("auth", _authorized.value);
      } catch (error) {
        storage.write("auth", false);
        Get.snackbar("error".tr, "error_in_auth".tr);
      }
    }
    // fetch data on successful auth
    if (_authorized.value) {
      await fetchStepData();
      await fetchEnergyData();
    }
  }

  /// Will fetch the step count from Google Fit
  Future fetchStepData() async {
    int? steps;

    // today and now
    final now = DateTime.now();
    // today and 00:00 (midnight)
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      // fetch the step count
      steps = await health.getTotalStepsInInterval(midnight, now);
    } catch (error) {
      Get.snackbar("error".tr, "error_in_step".tr);
    }

    _nofSteps.value = (steps == null) ? 0 : steps;
  }

  ///  Will fetch the total calories burned from Google Fit
  Future fetchEnergyData() async {
    List<HealthDataPoint> energy = [];

    // today and now
    final now = DateTime.now();
    // today and 00:00 (midnight)
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      // fetch calories
      energy = await health.getHealthDataFromTypes(midnight, now, [
        HealthDataType.ACTIVE_ENERGY_BURNED
      ]);
    } catch (error) {
      Get.snackbar("error".tr, "error_in_energy".tr);
    }

    // will map calories value to double from the HealthDataPoint type list
    _energy = (energy.isEmpty) ? [] : energy;
    for (var i in _energy) {
      _calories.value += double.parse(i.value.toString()).round();
    }
  }

  /// To set the original calories goal
  updateCaloriesGoal(int value) {
    _caloriesGoal.value = value;
  }

  /// To set the original steps goal
  updateStepsGoal(int value) {
    _stepsGoal.value = value;
  }

  /// To set the temporaries cal goal and will update the text editing controller's value also
  updateTempCaloriesGoal(int value) {
    textEditingController.text = value.toString();
    _tempCaloriesGoal.value = value;
  }

  /// To set the temporaries steps goal and will update the text editing controller's value also
  updateTempStepsGoal(int value) {
    textEditingController.text = value.toString();

    _tempStepsGoal.value = value;
  }
}
