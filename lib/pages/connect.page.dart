import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/controllers/app_state.controller.dart';
import 'package:klipper_controller/models/models.dart';
import 'package:klipper_controller/services/services.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:klipper_controller/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/connect';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController addressController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    LocalIOService.grabPrintersFromDB();
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  Widget buildAddPrinterConnectionButton() {
    return ElevatedButton.icon(
      icon: Icon(
        Icons.add,
        color: AppTheme.textColor(),
      ),
      label: Text(
        'add-printer'.tr,
        style: TextStyle(color: AppTheme.textColor()),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.backgroundColor(),
        foregroundColor: AppTheme.textColor(),
      ),
      onPressed: () async {
        /// Show dialog to collect printer connection data
        final Printer? printerConnection =
            await Get.dialog(const NewPrinterConnectionDialog());

        /// Fire [addNewPrinterConnectionAction] with data from dialog
        if (printerConnection != null) {
          AppStateController.addNewPrinterConnection(printerConnection);
        }
        setState(() {});
      },
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.backgroundColor(),
      title: Text('app_title'.tr),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: buildAddPrinterConnectionButton(),
        ),
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    final bool portraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: AppTheme.scaffoldColor(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          width: Get.width,
          height: Get.height,
          child: Obx(
            () => GridView.builder(
              shrinkWrap: true,
              itemCount: AppStateController.availablePrinters.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: portraitMode ? 0.75 : 0.75,
                crossAxisCount: portraitMode ? 2 : 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemBuilder: (final _, final int i) {
                return PrinterConnectionGridTile(index: i);
              },
            ),
          ),
        ),
      ),
    );
    // return Scaffold(
    //   body: SafeArea(
    //     child: GestureDetector(
    //       /// This GestureDetector allows us to easily hide the soft keybaord
    //       /// by clicking outside of a textfield
    //       onTapDown: (final _) => FocusManager.instance.primaryFocus?.unfocus(),
    //       child: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             buildAddressForm(),
    //             buildConnectBtn(),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
