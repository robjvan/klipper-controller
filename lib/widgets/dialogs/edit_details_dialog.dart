import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/models/models.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:numberpicker/numberpicker.dart';

class EditDetailsDialog extends StatefulWidget {
  final Printer printer;
  const EditDetailsDialog({
    required this.printer,
    super.key,
  });

  @override
  State<EditDetailsDialog> createState() => _EditDetailsDialogState();
}

class _EditDetailsDialogState extends State<EditDetailsDialog> {
  TextEditingController ipController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PrinterType? printerType;
  late bool hasWebcam;
  late bool hasSecondExtruder = false;
  late bool hasHeatedBed = true;
  late int maxExtruder0Temp = 240;
  late int maxExtruder1Temp = 240;
  late int maxBedTemp = 100;
  late int id;

  @override
  void dispose() {
    ipController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ipController.text = widget.printer.ip;
    id = widget.printer.id;
    nameController.text = widget.printer.name;
    // printerType = widget.printer.printerType;
    hasWebcam = widget.printer.hasWebcam;
    hasSecondExtruder = widget.printer.hasSecondExtruder;
    hasHeatedBed = widget.printer.hasHeatedBed;
    maxExtruder0Temp = widget.printer.maxExtruder0Temp;
    maxExtruder1Temp = widget.printer.maxExtruder1Temp;
    maxBedTemp = widget.printer.maxBedTemp;
  }

  /// Builds the title text widget
  Widget buildTitle() {
    return Text(
      'Edit ${widget.printer.name}', // TODO(Rob): Add translation strings
      style: TextStyle(color: AppTheme.textColor()),
      textAlign: TextAlign.center,
    );
  }

  /// Builds the name input field
  Widget buildNameField() {
    return TextFormField(
      style: TextStyle(color: AppTheme.textColor()),
      controller: nameController,
      decoration: InputDecoration(
        label: Text(
          'name'.tr, // TODO(Rob): Add translation strings
          style: TextStyle(color: AppTheme.textColor()),
        ),
      ),
      validator: (final String? value) {
        if (value!.isEmpty) {
          return 'name-empty'.tr; // TODO(Rob): Add translation strings
        }
        return null;
      },
    );
  }

  /// Builds the IP address input field
  Widget buildIPAddressField() {
    return TextFormField(
      controller: ipController,
      keyboardType: TextInputType.number,
      style: TextStyle(color: AppTheme.textColor()),
      decoration: InputDecoration(
        label: Text(
          'ip-address'.tr, // TODO(Rob): Add translation strings
          style: TextStyle(color: AppTheme.textColor()),
        ),
      ),
      validator: (final String? value) {
        if (value!.isEmpty) {
          return 'ip_empty'.tr; // TODO(Rob): Add translation strings
        }
        if (!AppValidators.ip(value)) {
          return 'ip_invalid'.tr; // TODO(Rob): Add translation strings
        }
        return null;
      },
    );
  }

  // /// Builds the printer type radio buttons
  // Widget buildPrinterTypePicker() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: <Widget>[
  //         Text(
  //           'printer-type'.tr,
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             // fontSize: 16.0,
  //             color: AppTheme.textColor(),
  //           ),
  //           textAlign: TextAlign.start,
  //         ),
  //         Row(
  //           children: <Widget>[
  //             Text(
  //               'cartesian'.tr, // TODO(Rob): Add translation strings
  //               style: TextStyle(color: AppTheme.textColor),
  //             ),
  //             Radio<PrinterType>(
  //               activeColor: AppColors.lightBlue,
  //               value: PrinterType.cartesian,
  //               groupValue: printerType,
  //               onChanged: (final PrinterType? value) {
  //                 setState(() {
  //                   printerType = value;
  //                 });
  //               },
  //             ),
  //             Text(
  //               'corexy'.tr, // TODO(Rob): Add translation strings
  //               style: TextStyle(color: AppTheme.textColor),
  //             ),
  //             Radio<PrinterType>(
  //               activeColor: AppColors.lightBlue,
  //               value: PrinterType.corexy,
  //               groupValue: printerType,
  //               onChanged: (final PrinterType? value) {
  //                 setState(() {
  //                   printerType = value;
  //                 });
  //               },
  //             ),
  //             Text(
  //               'delta'.tr, // TODO(Rob): Add translation strings
  //               style: TextStyle(color: AppTheme.textColor),
  //             ), // TODO(Rob): Add styling?
  //             Radio<PrinterType>(
  //               activeColor: AppColors.lightBlue,
  //               value: PrinterType.delta,
  //               groupValue: printerType,
  //               onChanged: (final PrinterType? value) {
  //                 setState(() {
  //                   printerType = value;
  //                 });
  //               },
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// Builds the Save/Cancel buttons
  Widget buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextButton(
          onPressed: () => Get.back(result: null),
          child: Text(
            'cancel'.tr, // TODO(Rob): Add translation strings
            style: TextStyle(
              color: AppTheme.textColor(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Get.back(
            result: Printer(
              id: id,
              ip: ipController.text,
              name: nameController.text,
              hasWebcam: hasWebcam,
              // printerType: printerType ?? PrinterType.cartesian,
              hasSecondExtruder: hasSecondExtruder,
              hasHeatedBed: hasHeatedBed,
              maxExtruder0Temp: maxExtruder0Temp,
              maxExtruder1Temp: maxExtruder1Temp,
              maxBedTemp: maxBedTemp,
            ),
          ),
          child: Text(
            'save'.tr, // TODO(Rob): Add translation strings
            style: TextStyle(
              color: AppTheme.textColor(),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the webcam checkbox
  Widget buildWebcamCheckbox() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: <Widget>[
          Text(
            'Has webcam?', // TODO(Rob): Add translation strings
            style: TextStyle(color: AppTheme.textColor()),
          ),
          Checkbox(
            value: hasWebcam,
            onChanged: (final bool? value) {
              setState(() {
                hasWebcam = !hasWebcam;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Builds the heated print bed checkbox
  Widget buildHeatedBedCheckbox() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: <Widget>[
          Text(
            'Has heated bed?', // TODO(Rob): Add translation strings
            style: TextStyle(color: AppTheme.textColor()),
          ),
          Checkbox(
            value: hasHeatedBed,
            onChanged: (final bool? value) {
              setState(() {
                hasHeatedBed = !hasHeatedBed;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Builds the radio buttons for number of tool heads
  Widget buildSecondExtruderRadios() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: <Widget>[
          Text(
            'Number of tool heads?', // TODO(Rob): Add translation strings
            style: TextStyle(color: AppTheme.textColor()),
          ),
          Row(
            children: <Widget>[
              Text(
                '1'.tr,
              ), // TODO(Rob): Add styling?
              Radio<bool>(
                value: false,
                groupValue: hasSecondExtruder,
                onChanged: (final bool? value) {
                  setState(() {
                    hasSecondExtruder = false;
                  });
                },
              ),
              Text('2'.tr), // TODO(Rob): Add styling?
              Radio<bool>(
                value: true,
                groupValue: hasSecondExtruder,
                onChanged: (final bool? value) {
                  setState(() {
                    hasSecondExtruder = true;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the max temp pickers
  Widget buildTempPicker(final String type) {
    String label = '';
    int value = 0;
    int maxTemp = 0;

    switch (type) {
      case 'extruder0':
        label =
            'Extruder 0 Max Temp: '.tr; // TODO(Rob): Add translation strings
        value = maxExtruder0Temp;
        maxTemp = 350;
        break;
      case 'extruder1':
        label =
            'Extruder 1 Max Temp: '.tr; // TODO(Rob): Add translation strings
        value = maxExtruder1Temp;
        maxTemp = 350;
        break;
      case 'printerbed':
        label = 'Print Bed Max Temp: '.tr; // TODO(Rob): Add translation strings
        value = maxBedTemp;
        maxTemp = 200;
        break;
      default:
        break;
    }

    return Column(
      children: <Widget>[
        type == 'extruder0'
            ? Container()
            : Divider(
                indent: Get.width * 0.05,
                endIndent: Get.width * 0.05,
              ),
        Row(
          children: <Widget>[
            const SizedBox(width: 16.0),
            SizedBox(
              width: Get.width * 0.4,
              child: Text(
                label,
                style: TextStyle(color: AppTheme.textColor()),
              ),
            ),
            NumberPicker(
              itemHeight: 32,
              textStyle: TextStyle(
                color: AppTheme.textColor().withOpacity(0.5),
                fontSize: 10.0,
              ),
              selectedTextStyle: TextStyle(
                color: AppTheme.textColor(),
                fontSize: 16.0,
              ),
              step: 5,
              minValue: 0,
              maxValue: maxTemp,
              value: value,
              onChanged: (final int value) {
                setState(() {
                  switch (type) {
                    case 'extruder0':
                      maxExtruder0Temp = value;
                      break;
                    case 'extruder1':
                      maxExtruder1Temp = value;
                      break;
                    case 'printerbed':
                      maxBedTemp = value;
                      break;
                    default:
                      break;
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    return SimpleDialog(
      backgroundColor: AppTheme.backgroundColor(),
      title: buildTitle(),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                buildIPAddressField(),
                buildNameField(),
                buildWebcamCheckbox(),
                buildHeatedBedCheckbox(),
                buildSecondExtruderRadios(),
                // buildPrinterTypePicker(),
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    collapsedIconColor: AppTheme.textColor(),
                    iconColor: AppTheme.textColor(),
                    title: Text(
                      'Max Temps (optional)'
                          .tr, // TODO(Rob): Add translation strings
                      style: TextStyle(color: AppTheme.textColor()),
                    ),
                    children: <Widget>[
                      buildTempPicker('extruder0'),
                      hasSecondExtruder
                          ? buildTempPicker('extruder1')
                          : Container(),
                      hasHeatedBed
                          ? buildTempPicker('printerbed')
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        buildButtonRow(),
      ],
    );
  }
}
