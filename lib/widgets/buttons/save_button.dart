import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/utilities/utilities.dart';

class SaveButton extends StatelessWidget {
  final Function()? onPressed;
  const SaveButton({required this.onPressed, super.key});

  @override
  Widget build(final BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.lightBlue),
      onPressed: onPressed,
      child: Text(
        'save'.tr,
        style: TextStyle(
          color: AppTheme.textColor(),
        ),
      ),
    );
  }
}
