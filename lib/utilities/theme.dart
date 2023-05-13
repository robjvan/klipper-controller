import 'package:flutter/material.dart';
import 'package:klipper_controller/controllers/user_settings.controller.dart';

@immutable
class AppTheme {
  static ThemeData themeData = ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    fontFamily: 'Inter',
  );

  static Color backgroundColor() {
    return UserSettingsController.useDarkMode.value == true
        ? AppColors.bgColorDarkMode
        : AppColors.bgColorLightMode;
  }

  static Color textColor() {
    return UserSettingsController.useDarkMode.value == true
        ? AppColors.textColorDarkMode
        : AppColors.textColorLightMode;
  }

  static Color scaffoldColor() {
    return UserSettingsController.useDarkMode.value == true
        ? AppColors.black
        : AppColors.white;
  }
}

@immutable
class AppStyles {
  static TextStyle cardHeaderStyle = const TextStyle(
    color: AppColors.lightBlue,
    fontWeight: FontWeight.bold,
  );

  static TextStyle cardSubheaderStyle = const TextStyle();

  static TextStyle consoleTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 12.0,
    fontFamily: 'UbuntuMono',
  );
}

@immutable
class AppColors {
  static const Color textColorLightMode = darkGrey;
  static const Color textColorDarkMode = white;
  static const Color bgColorLightMode = white;
  static const Color bgColorDarkMode = darkGrey;

  static const Color primaryColor = Color.fromARGB(255, 203, 227, 247);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color green = Color(0xFF00FF00);
  static const Color lightBlue = Color(0xFF3299F1);
  static const Color blue = Color(0xFF0000FF);
  static const Color red = Color(0xFFFF0000);
  static const Color grey = Color(0xFF808080);
  static const Color lightGrey = Color(0xFFDDDDDD);
  static const Color locationTileDarkGrey = Color(0xFF303030);
  static const Color darkGrey = Color(0xFF202020);
  static const Color lavender = Color(0xFFD0BCFF);
}
