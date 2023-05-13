import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/controllers/controllers.dart';
import 'package:klipper_controller/models/models.dart';
import 'package:klipper_controller/services/klipper.service.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:klipper_controller/widgets/card_header.dart';

class ToolheadCard extends StatefulWidget {
  const ToolheadCard({super.key});

  @override
  State<ToolheadCard> createState() => _ToolheadCardState();
}

class _ToolheadCardState extends State<ToolheadCard> {
  Widget buildHomingButton([final PrinterAxis? axis]) {
    late String label;
    switch (axis) {
      case PrinterAxis.x:
        label = 'X';
        break;
      case PrinterAxis.y:
        label = 'Y';
        break;
      case PrinterAxis.z:
        label = 'Z';
        break;
      default:
        label = 'All';
        break;
    }
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        foregroundColor: UserSettingsController.useDarkMode.value
            ? AppColors.white
            : AppColors.darkGrey,
      ),
      onPressed: () => KlipperService.home(axis),
      child: Text(label),
    );
  }

  // Widget buildDpad() {
  //   return Column(
  //     children: <Widget>[
  //       IconButton(
  //         onPressed: () {},
  //         icon: Icon(
  //           Icons.arrow_circle_up,
  //           size: 40.0,
  //           color: AppTheme.textColor().withOpacity(0.6),
  //         ),
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           IconButton(
  //             onPressed: () {},
  //             icon: Icon(
  //               Icons.arrow_circle_left_outlined,
  //               size: 40.0,
  //               color: AppTheme.textColor().withOpacity(0.6),
  //             ),
  //           ),
  //           IconButton(
  //             onPressed: () {},
  //             icon: Icon(
  //               Icons.arrow_circle_down_outlined,
  //               size: 40.0,
  //               color: AppTheme.textColor().withOpacity(0.6),
  //             ),
  //           ),
  //           IconButton(
  //             onPressed: () {},
  //             icon: Icon(
  //               Icons.arrow_circle_right_outlined,
  //               size: 40.0,
  //               color: AppTheme.textColor().withOpacity(0.6),
  //             ),
  //           ),
  //         ],
  //       ),
  //       // IconButton(onPressed: () {}, icon: Icon(Icons.arrow_upward)),
  //     ],
  //   );
  // }

  Widget buildPositioningControls() {
    return Row(
      children: <Widget>[
        Obx(
          () => IconButton(
            icon: Icon(
              PrinterStateController.absoluteCoordinates.isTrue
                  ? Icons.gps_fixed
                  : Icons.gps_not_fixed,
              color: PrinterStateController.absoluteCoordinates.isTrue
                  ? AppColors.lightBlue
                  : AppColors.grey,
            ),
            onPressed: KlipperService.toggleAbsoluteCoordinates,
          ),
        ),
        Text(
          'position'.tr,
          style: TextStyle(color: AppTheme.textColor()),
        ),
        const SizedBox(width: 8),
        Obx(
          () => Text(
            // useAbsolutePositioning
            PrinterStateController.absoluteCoordinates.isTrue
                ? 'absolute'.tr
                : 'relative'.tr,
            style: TextStyle(
              color: AppTheme.textColor(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHomingButtons() {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: null,
          icon: Icon(
            Icons.home,
            color: AppTheme.textColor(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildHomingButton(),
                buildHomingButton(PrinterAxis.x),
                buildHomingButton(PrinterAxis.y),
                buildHomingButton(PrinterAxis.z),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => Card(
        color: AppTheme.backgroundColor(),
        child: ExpansionTile(
          textColor: AppColors.lightBlue,
          iconColor: AppColors.lightBlue,
          collapsedIconColor: AppColors.lightBlue,
          initiallyExpanded: true,
          title: CardHeader('toolhead'.tr),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  buildPositioningControls(),
                  Center(
                    child: ToggleButtons(
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 40,
                      ),
                      textStyle: TextStyle(
                        fontSize: 12.0,
                        color: AppTheme.textColor(),
                      ),
                      isSelected: const <bool>[
                        false,
                        false,
                        false,
                        true,
                        false,
                        false,
                        false,
                      ],
                      onPressed: (final int i) {},
                      children: const <Widget>[
                        Text('-100'),
                        Text('-10'),
                        Text('-1'),
                        Text('X'),
                        Text('+1'),
                        Text('+10'),
                        Text('+100'),
                      ],
                    ),
                  ),
                  Center(
                    child: ToggleButtons(
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 40,
                      ),
                      textStyle: TextStyle(
                        fontSize: 12.0,
                        color: AppTheme.textColor(),
                      ),
                      isSelected: const <bool>[
                        false,
                        false,
                        false,
                        true,
                        false,
                        false,
                        false,
                      ],
                      onPressed: (final int i) {},
                      children: const <Widget>[
                        Text('-100'),
                        Text('-10'),
                        Text('-1'),
                        Text('Y'),
                        Text('+1'),
                        Text('+10'),
                        Text('+100'),
                      ],
                    ),
                  ),
                  Center(
                    child: ToggleButtons(
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 40,
                      ),
                      textStyle: TextStyle(
                        fontSize: 12.0,
                        color: AppTheme.textColor(),
                      ),
                      isSelected: const <bool>[
                        false,
                        false,
                        false,
                        true,
                        false,
                        false,
                        false,
                      ],
                      onPressed: (final int i) {},
                      children: const <Widget>[
                        Text('-100'),
                        Text('-10'),
                        Text('-1'),
                        Text('Z'),
                        Text('+1'),
                        Text('+10'),
                        Text('+100'),
                      ],
                    ),
                  ),
                  // buildDpad(),
                  buildHomingButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
