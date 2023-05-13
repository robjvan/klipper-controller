import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:klipper_controller/widgets/widgets.dart';

@immutable
class WebcamViewCard extends StatefulWidget {
  final String ip;
  const WebcamViewCard(this.ip, {super.key});

  @override
  State<WebcamViewCard> createState() => _WebcamViewCardState();
}

class _WebcamViewCardState extends State<WebcamViewCard> {
  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => Card(
        color: AppTheme.backgroundColor(),
        child: ExpansionTile(
          iconColor: AppColors.lightBlue,
          collapsedIconColor: AppColors.lightBlue,
          title: CardHeader('webcam-header'.tr),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                width: 320,
                height: 240,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: InAppWebView(
                      // key: webViewKey,
                      initialUrlRequest: URLRequest(
                        url: Uri.parse(
                          'http://${widget.ip}/webcam/?action=stream',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
