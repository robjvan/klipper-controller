import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/controllers/app_state.controller.dart';
import 'package:klipper_controller/models/models.dart';
import 'package:klipper_controller/pages/pages.dart';
import 'package:klipper_controller/services/services.dart';
import 'package:klipper_controller/utilities/theme.dart';
import 'package:klipper_controller/widgets/widgets.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static const String routeName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String message = '';
  bool subscribed = false; // Are we subscribed to the printer?
  late int websocketId;
  // String? address = null;
  String? address;
  late Printer printer;

  /// Grab our printer's IP address and details from nav args
  @override
  void initState() {
    super.initState();
    address = Get.arguments['address'];
    printer = Get.arguments['printer'];

    KlipperService.subscribeToPrinterObjects();
  }

  @override
  void dispose() {
    if (address != '' && address != null) {
      KlipperService.killConnection(address!);
    }
    super.dispose();
  }

  /// Dynamically build server response text widget
  /// or show blank container if there is no reponse yet
  Widget buildServerResponseWidget() {
    return Obx(
      () => AppStateController.serverResponse.value == ''
          ? Container()
          : Text(AppStateController.serverResponse.value),
    );
  }

  /// Build central "Loading..." message
  Widget buildLoadingMessage() {
    return Center(child: Text('loading'.tr));
  }

  /// Build the page body
  Widget buildPageBody() {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              printer.hasWebcam ? WebcamViewCard(address!) : Container(),
              const TempsCard(),
              const CoolingCard(),
              const ToolheadCard(),
              const ConsoleCard(),
              const SystemLoadCard(),
              // BedHeaterCard(client),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the app bar
  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.backgroundColor(),
      title: Row(
        children: <Widget>[
          Text(
            printer.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppTheme.textColor(),
              fontFamily: 'Inter',
            ),
          ),
          Text(
            ' (${printer.ip})',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18.0,
              color: AppTheme.textColor(),
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: AppTheme.textColor()),
        onPressed: () => Get.offAndToNamed(LoginPage.routeName),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings, color: AppTheme.textColor()),
          onPressed: () => Get.dialog(const SettingsDialog()),
        )
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppTheme.scaffoldColor(),
        appBar: buildAppBar(),
        body: SafeArea(
          child: GestureDetector(
            /// This GestureDetector allows us to easily hide the soft keybaord
            /// by clicking outside of a textfield
            onTapDown: (final _) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            child: StreamBuilder<dynamic>(
              stream: KlipperService.printerSocket!.stream,
              builder: (final _, final AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  KlipperService.parseSnapshotData(
                    snapshot: snapshot,
                    printerIp: address!,
                  );
                  return buildPageBody();
                } else {
                  return buildLoadingMessage();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(final BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(),
  //     body: SafeArea(
  //       child: GestureDetector(
  //         /// This GestureDetector allows us to easily hide the soft keybaord
  //         /// by clicking outside of a textfield
  //         onTapDown: (final _) => FocusManager.instance.primaryFocus?.unfocus(),
  //         child: Center(
  //           child: Column(
  //             children: <Widget>[
  //               Column(
  //                 children: <Widget>[
  //                   buildSendMessageBtn(),
  //                   buildServerResponseWidget(),
  //                   buildEndConnectionBtn(),
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
