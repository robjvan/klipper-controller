import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/models/models.dart';
import 'package:klipper_controller/services/local_io.service.dart';
// import 'package:klipper_controller/pages/connect_page/connect_page_viewmodel.dart';
// import 'package:klipper_controller/redux/app.state.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:klipper_controller/widgets/widgets.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:klipper_controller/widgets/buttons/cancel_button.dart';
// import 'package:klipper_controller/widgets/buttons/save_button.dart';

class NewPrinterConnectionDialog extends StatefulWidget {
  const NewPrinterConnectionDialog({super.key});

  @override
  State<NewPrinterConnectionDialog> createState() =>
      _NewPrinterConnectionDialogState();
}

class _NewPrinterConnectionDialogState
    extends State<NewPrinterConnectionDialog> {
  TextEditingController ipController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int? printerStyle = 0;
  bool hasWebcam = true;
  bool hasHeatedBed = true;
  bool hasSecondExtruder = false;
  int maxExtruder0Temp = 240;
  int maxExtruder1Temp = 240;
  int maxBedTemp = 100;

  @override
  void initState() {
    super.initState();
    ipController.text = '192.168.0.82'; // TODO(Rob): Remove for prod
    nameController.text = 'i3 Mega Pro'; // TODO(Rob): Remove for prod
  }

  @override
  void dispose() {
    ipController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Widget buildTitle() {
    return Text(
      'add_printer'.tr,
      style: TextStyle(
        color: AppTheme.textColor(),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget buildIPAddressField() {
    return TextFormField(
      style: TextStyle(color: AppTheme.textColor()),
      controller: ipController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(
          'ip'.tr,
          style: TextStyle(color: AppTheme.textColor()),
        ),
      ),
      validator: (final String? value) {
        if (value!.isEmpty) {
          return 'ip_empty'.tr;
        }
        if (!AppValidators.ip(value)) {
          return 'ip_invalid'.tr;
        }
        return null;
      },
    );
  }

  Widget buildNameField() {
    return TextFormField(
      style: TextStyle(color: AppTheme.textColor()),
      controller: nameController,
      decoration: InputDecoration(
        label: Text(
          'name'.tr,
          style: TextStyle(color: AppTheme.textColor()),
        ),
      ),
      validator: (final String? value) {
        if (value!.isEmpty) {
          return 'name_empty'.tr;
        }
        return null;
      },
    );
  }

  Widget buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        const CancelButton(),
        SaveButton(
          onPressed: () async {
            late int nextId;

            /// Check form validation for errors
            if (formKey.currentState!.validate()) {
              final Database db = LocalIOService.database;
              // late final int id;

              /// Fetch last record from DB to determine next available ID
              final List<Map<String, dynamic>> dbRecords =
                  await db.query('printers');

              if (dbRecords.isNotEmpty) {
                final Map<String, dynamic> lastRecord = dbRecords.last;
                nextId = lastRecord['id'] + 1;
              } else {
                nextId = 1;
              }

              /// Create new Printer object from form data
              final Printer newPrinterConnection = Printer(
                id: nextId,
                ip: ipController.text,
                name: nameController.text,
                hasWebcam: hasWebcam,
                // printerType: printerStyle ?? 1,
                hasSecondExtruder: hasSecondExtruder,
                hasHeatedBed: hasHeatedBed,
                maxExtruder0Temp: maxExtruder0Temp,
                maxExtruder1Temp: maxExtruder1Temp,
                maxBedTemp: maxBedTemp,
              );

              /// Return created printer object
              Get.back(result: newPrinterConnection);
            }
          },
        )
      ],
    );
  }

  // Widget buildPrinterTypePicker() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 16.0),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: <Widget>[
  //           Text(
  //             'printer_type'.tr,
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               // fontSize: 16.0,
  //               color: AppTheme.textColor(),
  //             ),
  //             textAlign: TextAlign.start,
  //           ),
  //           SingleChildScrollView(
  //             scrollDirection: Axis.horizontal,
  //             child: Theme(
  //               data: ThemeData(primaryColor: AppColors.lightBlue),
  //               child: Row(
  //                 children: <Widget>[
  //                   Text(
  //                     'cartesian'.tr,
  //                     style: TextStyle(color: AppTheme.textColor),
  //                   ),
  //                   Radio<int>(
  //                     value: 1,
  //                     groupValue: printerStyle,
  //                     onChanged: (final int? value) {
  //                       setState(() {
  //                         printerStyle = 1;
  //                       });
  //                     },
  //                   ),
  //                   Text(
  //                     'corexy'.tr,
  //                     style: TextStyle(color: AppTheme.textColor),
  //                   ),
  //                   Radio<int>(
  //                     value: 2,
  //                     groupValue: printerStyle,
  //                     onChanged: (final int? value) {
  //                       setState(() {
  //                         printerStyle = 2;
  //                       });
  //                     },
  //                   ),
  //                   Text(
  //                     'delta'.tr,
  //                     style: TextStyle(color: AppTheme.textColor),
  //                   ),
  //                   Radio<int>(
  //                     value: 3,
  //                     groupValue: printerStyle,
  //                     onChanged: (final int? value) {
  //                       setState(() {
  //                         printerStyle = 3;
  //                       });
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget buildWebcamCheckbox() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: <Widget>[
          Text(
            'Has webcam?',
            style: TextStyle(color: AppTheme.textColor()),
          ),
          Checkbox(
            fillColor: MaterialStateProperty.resolveWith<Color>(
                (final Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.lightBlue.withOpacity(.32);
              }
              return Colors.lightBlue;
            }),
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

  Widget buildHeatedBedCheckbox() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: <Widget>[
          Text(
            'Has heated bed?',
            style: TextStyle(color: AppTheme.textColor()),
          ),
          Checkbox(
            fillColor: MaterialStateProperty.resolveWith<Color>(
                (final Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.lightBlue.withOpacity(.32);
              }
              return Colors.lightBlue;
            }),
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

  Widget buildSecondExtruderRadios() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Number of tool heads: ',
            style: TextStyle(color: AppTheme.textColor()),
          ),
          Row(
            children: <Widget>[
              Text(
                '1'.tr,
                style: TextStyle(color: AppTheme.textColor()),
              ), // TODO(Rob): Add styling?
              Radio<bool>(
                activeColor: AppColors.lightBlue,
                value: false,
                groupValue: hasSecondExtruder,
                onChanged: (final bool? value) {
                  setState(() {
                    hasSecondExtruder = false;
                  });
                },
              ),
              Text(
                '2'.tr,
                style: TextStyle(color: AppTheme.textColor()),
              ), // TODO(Rob): Add styling?
              Radio<bool>(
                activeColor: AppColors.lightBlue,
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
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textColor(),
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
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0.0),
          child: buildButtonRow(),
        ),
      ],
    );
  }
}
