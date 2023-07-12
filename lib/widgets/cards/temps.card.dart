import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/controllers/controllers.dart';
import 'package:klipper_controller/models/models.dart';
import 'package:klipper_controller/services/services.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:klipper_controller/widgets/widgets.dart';

class TempsCard extends StatelessWidget {
  const TempsCard({super.key});

  /// Build button to send cooldown command
  Widget buildCooldownButton() {
    final bool isConnected = KlipperService.isConnected();
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(color: AppColors.lightBlue),
        ),
      ),
      onPressed: isConnected ? KlipperService.cooldown : () {},
      label: Text(
        'cooldown'.tr,
        style: TextStyle(
          color: isConnected ? AppColors.lightBlue : AppColors.lightGrey,
        ),
      ),
      icon: Icon(
        Icons.ac_unit,
        color: isConnected ? AppColors.lightBlue : AppColors.lightGrey,
      ),
    );
  }

  /// Builds title row with cooldown button
  Widget buildTitleRow() {
    return Row(
      children: <Widget>[
        CardHeader('temperatures'.tr),
        const Spacer(),
        buildCooldownButton(),
      ],
    );
  }

  /// Builds preheat button, taking [Filament] type as an input.
  ///
  /// ```dart
  /// reusablePreheatButton(Filament.PLA, 'PLA');
  /// ```
  Widget reusablePreheatButton(
    final Filament filament,
    final String label,
  ) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        // backgroundColor: UserSettingsController.useDarkMode.value
        //     ? AppColors.lightBlue
        //     : AppColors.primaryColor,
        foregroundColor: UserSettingsController.useDarkMode.value
            ? AppColors.white
            : AppColors.darkGrey,
      ),
      onPressed: KlipperService.isConnected()
          ? () => KlipperService.preheat(filament)
          : null,
      child: Text(label),
    );
  }

  /// Builds a row of buttons for various preheat presets
  Widget buildPreheatShortcuts() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[
          Text(
            'preheat-presets'.tr,
            style: TextStyle(
              color: AppTheme.textColor(),
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  reusablePreheatButton(Filament.PLA, 'PLA'),
                  const SizedBox(width: 4.0),
                  reusablePreheatButton(Filament.PETG, 'PETG'),
                  const SizedBox(width: 4.0),
                  reusablePreheatButton(Filament.TPU, 'TPU'),
                  const SizedBox(width: 4.0),
                  reusablePreheatButton(Filament.NYLON, 'Nylon'),
                  const SizedBox(width: 4.0),
                  reusablePreheatButton(Filament.ABS, 'ABS'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a divider with indents
  Widget buildDivider() {
    final double indent = Get.width * 0.1;

    return Divider(
      indent: indent,
      endIndent: indent,
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
          title: buildTitleRow(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: <Widget>[
                  /// Build data row for primary extruder
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: TempDataRow('extruder0'),
                  ),

                  /// Build data row for second extruder if present
                  AppStateController.printer!.value.hasSecondExtruder
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: TempDataRow('extruder1'),
                        )
                      : Container(),

                  /// Build data row for printer bed if heated
                  AppStateController.printer!.value.hasHeatedBed
                      ? const TempDataRow('printerbed')
                      : Container(),

                  /// Build preheat shortcuts row
                  buildPreheatShortcuts(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
