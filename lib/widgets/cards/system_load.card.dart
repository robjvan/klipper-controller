import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:klipper_controller/widgets/gauges/cpu_temp.gauge.dart';
import 'package:klipper_controller/widgets/gauges/cpu_usage.gauge.dart';
import 'package:klipper_controller/widgets/gauges/memory_usage.gauge.dart';
import 'package:klipper_controller/widgets/widgets.dart';

class SystemLoadCard extends StatefulWidget {
  const SystemLoadCard({super.key});

  @override
  State<SystemLoadCard> createState() => _SystemLoadCardState();
}

class _SystemLoadCardState extends State<SystemLoadCard> {
  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => Card(
        color: AppTheme.backgroundColor(),
        child: ExpansionTile(
          iconColor: AppColors.lightBlue,
          collapsedIconColor: AppColors.lightBlue,
          initiallyExpanded: true,
          title: CardHeader('system-load'.tr),
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CpuUsageGauge(),
                      SizedBox(width: 16.0),
                      CpuTempGauge(),
                      SizedBox(width: 16.0),
                      MemoryUsageGauge(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
