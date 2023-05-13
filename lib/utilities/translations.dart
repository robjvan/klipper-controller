import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/utilities/i18n/i18n_strings.dart';

@immutable
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => <String, Map<String, String>>{
        'en': englishStrings,
        'fr': frenchStrings,
        'es': spanishStrings,
      };
}
