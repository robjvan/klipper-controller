import 'package:get/get.dart';
import 'package:klipper_controller/models/models.dart';
import 'package:klipper_controller/services/local_io.service.dart';

/// Holds common state data for the whole app

class AppStateController {
  static RxString printerAddress = ''.obs;
  static RxString serverResponse = ''.obs;
  static RxList<Printer> availablePrinters = <Printer>[].obs;
  static Rx<Printer>? printer = Printer.initial().obs;
  static RxBool isConnected = false.obs;

  static void addNewPrinterConnection(
    final Printer printer,
  ) {
    /// 1. Ensure printer isn't already in the list using IP
    final bool printerExists = availablePrinters.indexWhere(
          (final Printer element) => element.ip == printer.ip,
        ) !=
        -1;
    if (printerExists) {
      /// If printer is already in list, show snackbar and return
      Get.showSnackbar(GetSnackBar(message: 'printer_already_exists'.tr));
      return;
    }

    try {
      /// 2. Save printer to local DB
      LocalIOService.insertPrinter(printer);

      /// 3. Add new [printerConnection] to list
      availablePrinters.add(printer);
    } on Exception catch (_) {
      // print('Error adding printer: $err');
    }
  }

  static void removePrinterConnection(final int index) {
    /// Find printer in AppState with given index
    final Printer printer = AppStateController.availablePrinters[index];

    /// Remove printer from the local DB
    LocalIOService.removePrinter(printer);

    /// 1. Remove the item at given index from list
    try {
      availablePrinters.removeAt(index);
      // final Printer result = availablePrinters.removeAt(index);
      // if (result != null) {}
    } on Exception catch (_) {}
  }
}
