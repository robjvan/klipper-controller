import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/controllers/controllers.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:numberpicker/numberpicker.dart';

class TempTargetDialog extends StatefulWidget {
  final String type;
  const TempTargetDialog(this.type, {super.key});

  @override
  State<TempTargetDialog> createState() => _TempTargetDialogState();
}

class _TempTargetDialogState extends State<TempTargetDialog> {
  GlobalKey<FormState> formKey = GlobalKey();
  String type = '';
  int newTempTarget = 0;
  int maxTemp = 0;

  void setMaxTemps() {
    switch (widget.type) {
      case 'extruder0':
        maxTemp = AppStateController.printer!.value.maxExtruder0Temp;
        type = 'extruder';
        break;
      case 'extruder1':
        maxTemp = AppStateController.printer!.value.maxExtruder1Temp;
        type = 'extruder';
        break;
      case 'printerbed':
        maxTemp = AppStateController.printer!.value.maxBedTemp;
        type = 'bed';
        break;
      default:
        maxTemp = 240;
        break;
    }
  }

  Widget buildSaveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: UserSettingsController.useDarkMode.value
            ? AppColors.lightBlue
            : AppColors.primaryColor,
      ),
      onPressed: () => Get.back(result: newTempTarget),
      child: Text(
        'save'.tr,
        style: TextStyle(color: AppTheme.textColor()),
      ), // TODO(Rob): Add translation strings
    );
  }

  @override
  Widget build(final BuildContext context) {
    setMaxTemps();

    return SimpleDialog(
      backgroundColor: AppTheme.backgroundColor(),
      title: Text(
        'set-temp'.trParams(<String, String>{'type': type}),
        style: TextStyle(color: AppTheme.textColor()),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 140,
                  child: NumberPicker(
                    textStyle: TextStyle(color: AppTheme.textColor()),
                    selectedTextStyle:
                        TextStyle(color: AppTheme.textColor(), fontSize: 32.0),
                    value: newTempTarget,
                    step: 5,
                    minValue: 0,
                    maxValue: maxTemp,
                    onChanged: (final int? value) {
                      setState(() {
                        newTempTarget = value!;
                      });
                    },
                  ),
                ),
                buildSaveButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
