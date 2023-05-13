import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/controllers/controllers.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

@immutable
class Extruder0TempGauge extends StatelessWidget {
  const Extruder0TempGauge({super.key});

  List<GaugeRange> buildRanges() {
    return <GaugeRange>[
      GaugeRange(
        startValue: 0,
        endValue: AppStateController.printer!.value.maxExtruder0Temp * 0.5,
        color: Colors.blue,
        startWidth: 2,
        endWidth: 3,
      ),
      GaugeRange(
        startValue: AppStateController.printer!.value.maxExtruder0Temp * 0.5,
        endValue: AppStateController.printer!.value.maxExtruder0Temp * 0.7,
        color: Colors.teal,
        startWidth: 3,
        endWidth: 4,
      ),
      GaugeRange(
        startValue: AppStateController.printer!.value.maxExtruder0Temp * 0.7,
        endValue: AppStateController.printer!.value.maxExtruder0Temp * 0.9,
        color: Colors.green,
        startWidth: 4,
        endWidth: 5,
      ),
      GaugeRange(
        startValue: AppStateController.printer!.value.maxExtruder0Temp * 0.9,
        endValue: AppStateController.printer!.value.maxExtruder0Temp * 0.97,
        color: Colors.orange,
        startWidth: 5,
        endWidth: 6,
      ),
      GaugeRange(
        startValue: AppStateController.printer!.value.maxExtruder0Temp * 0.97,
        endValue: AppStateController.printer!.value.maxExtruder0Temp.toDouble(),
        color: Colors.red,
        startWidth: 6,
        endWidth: 7,
      )
    ];
  }

  List<GaugePointer> buildPointers() {
    return <GaugePointer>[
      NeedlePointer(
        value: PrinterStateController.extruder0Target.value,
        needleEndWidth: 3,
        needleStartWidth: 1,
        needleColor: Colors.red.withAlpha(200),
      ),
      NeedlePointer(
        value: PrinterStateController.extruder0Temp.value,
        needleEndWidth: 3,
        needleStartWidth: 1,
        needleColor: UserSettingsController.useDarkMode.value
            ? Colors.white70
            : Colors.black87,
      ),
    ];
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SizedBox(
        height: 80,
        width: 80,
        child: Center(
          child: Obx(
            () {
              return SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    showAxisLine: false,
                    showLabels: false,
                    minimum: 0,
                    maximum: AppStateController.printer!.value.maxExtruder0Temp
                        .toDouble(),
                    ranges: buildRanges(),
                    pointers: buildPointers(),
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          PrinterStateController.extruder0Temp.value == 0.0
                              ? 'Waiting...'
                              : '${PrinterStateController.extruder0Temp.value.toStringAsFixed(1)}c',
                          style: TextStyle(color: AppTheme.textColor()),
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
