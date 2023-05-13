import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/utilities/utilities.dart';

class PrinterErrorDialog extends StatelessWidget {
  const PrinterErrorDialog({super.key});

  @override
  Widget build(final BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.backgroundColor(),
      title: Text(
        'Error', // TODO: Add translation strings
        style: TextStyle(
          color: AppTheme.textColor(),
        ),
      ),
      content: Text(
        // TODO: Add translation strings
        'Could not connect to the printer.  Is it powered on?',
        style: TextStyle(
          color: AppTheme.textColor(),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.backgroundColor(),
          ),
          onPressed: Get.back,
          child: Text(
            'OK', // TODO: Add translation strings
            style: TextStyle(
              color: AppTheme.textColor(),
            ),
          ),
        ),
      ],
    );
  }
}
