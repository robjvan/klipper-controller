import 'package:get/get.dart';

/// Holds state data for the user preferences

class UserSettingsController {
  static RxBool useDarkMode = true.obs;

  static void toggleDarkMode() => useDarkMode.value = !useDarkMode.value;
}
