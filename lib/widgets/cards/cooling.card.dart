import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/controllers/controllers.dart';
import 'package:klipper_controller/services/klipper.service.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:klipper_controller/widgets/widgets.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

@immutable
class CoolingCard extends StatefulWidget {
  const CoolingCard({super.key});

  @override
  State<CoolingCard> createState() => _CoolingCardState();
}

class _CoolingCardState extends State<CoolingCard> {
  @override
  void initState() {
    super.initState();
    if (PrinterStateController.fanSpeed > 0) {
      //
    }
  }

  Widget buildHeader() {
    return Text(
      'fan-speed'.tr,
      style: TextStyle(
        color: AppTheme.textColor(),
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    );
  }

  Widget buildFanSpeedGauge() {
    return SizedBox(
      height: 80,
      width: 80,
      child: Center(
        child: Obx(
          () => Text(
            '${PrinterStateController.fanSpeed.value}%',
            style: TextStyle(
              color: AppTheme.textColor(),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFanLinearGauge() {
    return SizedBox(
      height: 50,
      child: Obx(
        () => SfLinearGauge(
          showLabels: true,
          axisLabelStyle: TextStyle(
            color: AppTheme.textColor().withOpacity(0.50),
          ),
          axisTrackStyle: LinearAxisTrackStyle(
            color: AppTheme.textColor().withOpacity(0.25),
          ),
          markerPointers: <LinearShapePointer>[
            LinearShapePointer(
              elevation: 10,
              onChanged: (final double value) => setState(() {
                PrinterStateController.fanSpeed.value = value.round();
              }),
              position: LinearElementPosition.cross,
              onChangeEnd: KlipperService.setFanSpeed,
              value: PrinterStateController.fanSpeed.value.toDouble(),
              color: AppColors.lightBlue,
            ),
          ],
          barPointers: <LinearBarPointer>[
            LinearBarPointer(
              value: PrinterStateController.fanSpeed.value.toDouble(),
              color: AppTheme.textColor(),
            ),
          ],
          interval: 20,
          showTicks: true,
          majorTickStyle: LinearTickStyle(
            color: AppTheme.textColor().withOpacity(0.25),
          ),
        ),
      ),
    );
  }

  Widget buildFanSlider() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          buildHeader(),
          const SizedBox(height: 8.0),
          buildFanLinearGauge(),
        ],
      ),
    );
  }

  /// Builds a reusable button for setting fan speed
  ///
  /// [label] specifies the fan speed percentage and must be an int between 0 and 100
  Widget reusableButton(int label) {
    /// Fix input if out of range
    if (label < 0) {
      label = 0;
    } else if (label > 100) {
      label = 100;
    }

    return OutlinedButton(
      onPressed: () {
        PrinterStateController.fanSpeed.value = label;
        KlipperService.setFanSpeed(label.toDouble());
      },
      child: Text(
        '$label%',
        style: TextStyle(
          color: AppTheme.textColor(),
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        reusableButton(0),
        reusableButton(25),
        reusableButton(50),
        reusableButton(75),
        reusableButton(101),
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => Card(
        color: AppTheme.backgroundColor(),
        child: ExpansionTile(
          iconColor: AppColors.lightBlue,
          collapsedIconColor: AppColors.lightBlue,
          initiallyExpanded: true,
          title: CardHeader('cooling'.tr),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      buildFanSpeedGauge(),
                      const SizedBox(width: 16.0),
                      buildFanSlider(),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  buildButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
