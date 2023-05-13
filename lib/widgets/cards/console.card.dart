import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/controllers/controllers.dart';
import 'package:klipper_controller/services/klipper.service.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:klipper_controller/widgets/widgets.dart';

class ConsoleCard extends StatefulWidget {
  const ConsoleCard({super.key});

  @override
  State<ConsoleCard> createState() => _ConsoleCardState();
}

class _ConsoleCardState extends State<ConsoleCard> {
  late ScrollController _scrollController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _commandController = TextEditingController();
  bool _commandisValid = false;
  String _gCodeCommand = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {}); //the listener for up and down.
  }

  @override
  void dispose() {
    PrinterStateController.consoleResponses.clear();
    _commandController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildCommandBox() {
    return SizedBox(
      width: Get.width - 147,
      child: TextFormField(
        onChanged: (final String? value) {
          if (value != null) {
            if (GCode.allowedCommands.contains(value.split(' ')[0])) {
              setState(() {
                _gCodeCommand = value;
                _commandisValid = true;
              });
            } else {
              setState(() {
                _commandisValid = false;
              });
            }
          }
        },
        expands: false,
        controller: _commandController,
        style: TextStyle(color: AppTheme.textColor()),
        decoration: InputDecoration(
          hintText: 'Enter command...',
          hintStyle: TextStyle(
            color: AppTheme.textColor().withOpacity(0.5),
            fontSize: 12.0,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.lightBlue),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: _commandisValid ? AppColors.lightBlue : AppColors.grey,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 8,
          ),
        ),
      ),
    );
  }

  Widget buildSendCmdBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightBlue,
      ),
      onPressed: () {
        PrinterStateController.consoleResponses.add(_gCodeCommand);
        if (_commandisValid) {
          KlipperService.sendGcodeScript(_gCodeCommand);
          KlipperService.queryStatus();
          setState(() {
            _commandController.clear();
            _commandisValid = false;
          });
        }
      },
      child: Text(
        'Send',
        style: TextStyle(color: AppTheme.textColor()),
      ),
    );
  }

  void _scrollToTop() {
    if (_scrollController.position.hasContentDimensions) {
      try {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } on Exception catch (_) {}
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => Card(
        color: AppTheme.backgroundColor(),
        child: ExpansionTile(
          iconColor: AppColors.lightBlue,
          collapsedIconColor: AppColors.lightBlue,
          initiallyExpanded: false,
          title: CardHeader('console'.tr),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            buildCommandBox(),
                            const SizedBox(width: 16),
                            buildSendCmdBtn(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.black,
                      border: Border.all(color: AppColors.grey),
                    ),
                    height: 350,
                    child: Obx(
                      () => ListView.builder(
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        reverse: true,
                        itemCount:
                            PrinterStateController.consoleResponses.length,
                        itemBuilder: (final BuildContext ctx, final int index) {
                          _scrollToTop();
                          return ListTile(
                            dense: true,
                            key: Key('$index'),
                            title: Obx(
                              () => Text(
                                PrinterStateController.consoleResponses[index]
                                    .toString(),
                                style: AppStyles.consoleTextStyle,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
