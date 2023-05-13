import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/models/models.dart';
import 'package:klipper_controller/utilities/utilities.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final Printer printerConnection;
  const ConfirmDeleteDialog({
    required this.printerConnection,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return SimpleDialog(
      title: Text(
        'Remove ${printerConnection.name}?', // TODO(Rob): Add translation strings
        style: TextStyle(color: AppTheme.textColor()),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text(
                'cancel'.tr,
                style: TextStyle(
                  color: AppTheme.textColor(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              child: Text(
                'confirm_delete'.tr,
                style: TextStyle(
                  color: AppTheme.textColor(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
