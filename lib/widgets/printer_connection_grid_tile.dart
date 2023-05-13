import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/controllers/app_state.controller.dart';
import 'package:klipper_controller/models/models.dart';
import 'package:klipper_controller/pages/pages.dart';
import 'package:klipper_controller/services/services.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:klipper_controller/widgets/widgets.dart';

@immutable
class PrinterConnectionGridTile extends StatefulWidget {
  final int index;
  const PrinterConnectionGridTile({
    required this.index,
    super.key,
  });

  @override
  State<PrinterConnectionGridTile> createState() =>
      _PrinterConnectionGridTileState();
}

class _PrinterConnectionGridTileState extends State<PrinterConnectionGridTile> {
  Widget buildNameField() {
    return Text(
      AppStateController.availablePrinters[widget.index].name,
      style: TextStyle(
        color: AppTheme.textColor(),
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      ),
    );
  }

  Widget buildAddressField() {
    return Text(
      AppStateController.availablePrinters[widget.index].ip,
      style: TextStyle(
        color: AppTheme.textColor(),
      ),
    );
  }

  Widget buildButtonRow() {
    Widget buildDeleteButton() {
      return IconButton(
        icon: Icon(
          Icons.close,
          color: AppTheme.textColor(),
        ),
        onPressed: () async {
          bool confirmDelete = false;

          try {
            /// Double-check that user wants to delete the printer
            confirmDelete = await Get.dialog(
                  ConfirmDeleteDialog(
                    printerConnection:
                        AppStateController.availablePrinters[widget.index],
                  ),
                ) ==
                true;
          } on Exception catch (_) {}
          if (confirmDelete) {
            setState(() {
              AppStateController.removePrinterConnection(widget.index);
            });
          }
        },
      );
    }

    Widget buildEditButton() {
      /// Show edit connection dialog
      /// Returns either updated connection details or null on cancel/fail
      Future<Printer?> fetchConnectionDetails() async {
        Printer? newDetails;

        newDetails = await Get.dialog(
          EditDetailsDialog(
            printer: AppStateController.availablePrinters[widget.index],
          ),
        );

        return newDetails;
      }

      return IconButton(
        icon: Icon(Icons.edit, color: AppTheme.textColor()),
        onPressed: () async {
          /// Grab new connection details from user
          final Printer? updatedPrinterConnection =
              await fetchConnectionDetails();

          if (updatedPrinterConnection != null) {
            /// Add the new entry and...
            setState(() {
              /// Remove the old one
              AppStateController.removePrinterConnection(widget.index);

              AppStateController.addNewPrinterConnection(
                updatedPrinterConnection,
              );
            });

            // AppStateController.availablePrinterConnections[index];
          }
        },
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        buildEditButton(),
        buildDeleteButton(),
      ],
    );
  }

  Future<void> onTapAction() async {
    /// Connect to the printer
    await KlipperService.connectToPrinter(
      AppStateController.availablePrinters[widget.index].ip,
    );

    /// Copy selected printer info to app state
    AppStateController.printer!.value =
        AppStateController.availablePrinters[widget.index];

    if (AppStateController.isConnected.value) {
      /// Navigate to printer dashboard page
      unawaited(
        Get.offAndToNamed(
          DashboardPage.routeName,
          arguments: <String, dynamic>{
            'address': AppStateController.availablePrinters[widget.index].ip,
            'printer': AppStateController.availablePrinters[widget.index]
          },
        ),
      );
    } else {
      /// Could not connect to the printer, show error dialog to user
      // TODO: Add alert dialog
    }
  }

  @override
  Widget build(final BuildContext context) {
    // final bool portraitMode =
    //     MediaQuery.of(context).orientation == Orientation.portrait;
    return GridTile(
      child: InkWell(
        onTap: onTapAction,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: AppTheme.backgroundColor(),
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Spacer(),
                    KlipperService.buildPrinterImage(1),
                    Column(
                      children: <Widget>[
                        buildNameField(),
                        buildAddressField(),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              buildButtonRow(),
            ],
          ),
        ),
      ),
    );
  }
}
