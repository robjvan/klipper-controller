import 'package:flutter/material.dart';
import 'package:klipper_controller/utilities/utilities.dart';

class CardHeader extends StatelessWidget {
  final String title;
  const CardHeader(this.title, {super.key});

  @override
  Widget build(final BuildContext context) {
    return Text(
      title,
      style: AppStyles.cardHeaderStyle,
    );
  }
}
