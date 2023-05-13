import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/controllers/controllers.dart';
import 'package:klipper_controller/services/klipper.service.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:klipper_controller/widgets/widgets.dart';

class TempDataRow extends StatefulWidget {
  final String type;
  const TempDataRow(this.type, {super.key});

  @override
  State<TempDataRow> createState() => _TempDataRowState();
}

class _TempDataRowState extends State<TempDataRow> {
  String title = '';
  late Widget tempGauge;
  late Widget targetChild;
  late Widget powerChild;
  late double targetValue;
  late int powerValue;
  late double tempValue;
  late String gaugeTitle;
  late double maxTempValue;
  late double indent;

  @override
  void initState() {
    super.initState();
    buildDataStrings();
    indent = Get.width * 0.1;
  }

  /// Populates the child strings using dynamic data
  void buildDataStrings() {
    switch (widget.type) {
      case 'extruder0':
        title = AppStateController.printer!.value.hasSecondExtruder
            ? 'extruder0'.tr // TODO(Rob): Add translation strings
            : 'extruder'.tr; // TODO(Rob): Add translation strings
        targetValue = PrinterStateController.extruder0Target.value;
        powerValue = PrinterStateController.extruder0Power.value;
        tempGauge = const Extruder0TempGauge();
        targetChild = Obx(
          () => Text(
            'target'.trParams(<String, String>{
              'value': PrinterStateController.extruder0Target.value
                  .toStringAsFixed(0),
            }),
            style: TextStyle(color: AppTheme.textColor()),
          ),
        );
        powerChild = Obx(
          () => Text(
            'power'.trParams(<String, String>{
              'value': PrinterStateController.extruder0Power.value
                  .toStringAsFixed(0),
            }),
            style: TextStyle(color: AppTheme.textColor()),
          ),
        );
        gaugeTitle = '';
        break;

      case 'extruder1':
        title = 'extruder1'.tr; // TODO(Rob): Add translation strings
        targetValue = PrinterStateController.extruder1Target.value;
        powerValue = PrinterStateController.extruder1Power.value;
        tempGauge = const Extruder1TempGauge();
        targetChild = Obx(
          () => Text(
            'Target = ${PrinterStateController.extruder1Target.value}c', // TODO(Rob): Add translation strings
            style: TextStyle(color: AppTheme.textColor()),
          ),
        );
        powerChild = Obx(
          () => Text(
            'Power = ${PrinterStateController.extruder1Power.value}%', // TODO(Rob): Add translation strings
            style: TextStyle(
              color: AppTheme.textColor(),
            ),
          ),
        );
        gaugeTitle = '';
        break;

      case 'printerbed':
        title = 'heatedbed'.tr; // TODO(Rob): Add translation strings
        targetValue = PrinterStateController.bedTarget.value;
        powerValue = PrinterStateController.bedPower.value;
        tempGauge = const PrinterBedGauge();
        targetChild = Obx(
          () => Text(
            'Target = ${PrinterStateController.bedTarget.value}c', // TODO(Rob): Add translation strings
            style: TextStyle(color: AppTheme.textColor()),
          ),
        );
        powerChild = Obx(
          () => Text(
            'Power = ${PrinterStateController.bedPower.value}%', // TODO(Rob): Add translation strings
            style: TextStyle(color: AppTheme.textColor()),
          ),
        );
        gaugeTitle = '';
        break;
      default:
        title = widget.type;
        break;
    }
  }

  /// Builds the title widget for the data row
  Widget buildTitle() {
    return Text(
      title,
      style: TextStyle(
        color: AppTheme.textColor(),
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    );
  }

  /// Builds the "Set target" button
  Widget buildTargetButton() {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: UserSettingsController.useDarkMode.value
              ? AppColors.lightBlue
              : AppColors.primaryColor,
          foregroundColor: UserSettingsController.useDarkMode.value
              ? AppColors.white
              : AppColors.darkGrey,
        ),
        onPressed: KlipperService.isConnected() ? setTargetBtnAction : null,
        child: const Text(
          'Set target', // TODO(Rob): Add translation strings
        ),
      ),
    );
  }

  /// Build printer commands to be sent by the 'target' button
  Future<void> setTargetBtnAction() async {
    final int? newTargetTemp = await Get.dialog(TempTargetDialog(widget.type));

    if (newTargetTemp != null) {
      // send command to set target temp
      String script = '';

      switch (widget.type) {
        case 'extruder0':
          script = 'M104 T0 S$newTargetTemp';
          break;
        case 'extruder1':
          script = 'M104 T1 S$newTargetTemp';
          break;
        case 'printerbed':
          script = 'M140 S$newTargetTemp';
          break;
        default:
          break;
      }

      KlipperService.sendGcodeScript(script);
    }
  }

  /// Builds a text widget for the heater power level
  Widget buildPowerBox() {
    return powerValue > -1
        ? SizedBox(width: 112, child: powerChild)
        : Container();
  }

  /// Builds a text widget for the heater target temperature
  Widget buildTargetBox() {
    return targetValue > -1 ? targetChild : Container();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                tempGauge,
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            buildTitle(),
                            const SizedBox(width: 16),
                            buildTargetButton(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: <Widget>[
                            buildPowerBox(),
                            buildTargetBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              indent: indent,
              endIndent: indent,
            ),
          ],
        ),
      ),
    );
  }
}
