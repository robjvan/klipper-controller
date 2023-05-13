import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/controllers/controllers.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MemoryUsageGauge extends StatefulWidget {
  const MemoryUsageGauge({super.key});

  @override
  State<MemoryUsageGauge> createState() => _MemoryUsageGaugeState();
}

class _MemoryUsageGaugeState extends State<MemoryUsageGauge> {
  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => Column(
        children: <Widget>[
          SizedBox(
            child: Text(
              'Memory', // TODO: Add translation strings
              style: TextStyle(
                color: AppTheme.textColor(),
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
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
                            value: (PrinterStateController.memUsed.value /
                                    PrinterStateController.memTotal.value) *
                                100,
                            color: AppColors.lightBlue,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    '${((PrinterStateController.memUsed.value / PrinterStateController.memTotal.value) * 100).toStringAsFixed(1)}%',
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
