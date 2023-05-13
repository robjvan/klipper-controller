import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/controllers/controllers.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CpuTempGauge extends StatefulWidget {
  const CpuTempGauge({super.key});

  @override
  State<CpuTempGauge> createState() => _CpuTempGaugeState();
}

class _CpuTempGaugeState extends State<CpuTempGauge> {
  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => Column(
        children: <Widget>[
          Text(
            'Temp', // TODO: Add translation strings
            style: TextStyle(
              color: AppTheme.textColor(),
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: (Get.width / 3) - 64,
            height: (Get.width / 3) - 64,
            child: Stack(
              children: <Widget>[
                Obx(
                  () => SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        showTicks: false,
                        axisLineStyle: AxisLineStyle(
                          color: AppTheme.textColor().withOpacity(0.25),
                          thickness: 3,
                        ),
                        minimum: 0,
                        maximum: 105,
                        showLabels: false,
                        pointers: <GaugePointer>[
                          MarkerPointer(
                            value: PrinterStateController.cpuTemp.value,
                            color: AppColors.lightBlue,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    '${PrinterStateController.cpuTemp.value.toStringAsFixed(1)}c',
                    style: TextStyle(
                      color: AppTheme.textColor(),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
