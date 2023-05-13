import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/utilities/utilities.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(final BuildContext context) {
    return TextButton(
      onPressed: Get.back,
      child: Text(
        'cancel'.tr,
        style: TextStyle(
          color: AppTheme.textColor(),
        ),
      ),
    );
  }
}
