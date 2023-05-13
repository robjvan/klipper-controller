import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/controllers/controllers.dart';
import 'package:klipper_controller/utilities/utilities.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  Widget buildHeader() {
    return Text(
      'Settings',
      style: TextStyle(
        fontSize: 16.0,
        color: AppTheme.textColor(),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildControlButton(final String label) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(100, 48),
      ),
      onPressed: () {},
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.textColor(),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildSystemControls() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: <Widget>[
          Text(
            'Host Controls', // TODO(Rob): Add translation strings
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: AppTheme.textColor(),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildControlButton(
                'Restart', // TODO(Rob): Add translation strings
              ),
              const SizedBox(width: 4.0),
              buildControlButton(
                'Firmware Restart', // TODO(Rob): Add translation strings
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildControlButton(
                'Reboot Host', // TODO(Rob): Add translation strings
              ),
              const SizedBox(width: 4.0),
              buildControlButton(
                'Shutdown Host', // TODO(Rob): Add translation strings
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return const Divider(
      indent: 32,
      endIndent: 32,
    );
  }

  Widget buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: <Widget>[
          Text(
            'About Klipper Controller', // TODO(Rob): Add translation strings
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: AppTheme.textColor(),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Natus aut non. Voluptatem reiciendis vero nam. Voluptas laudantium quia. Enim vitae quaerat.', // TODO(Rob): Fix this blurb
            style: TextStyle(
              fontSize: 11.0,
              color: AppTheme.textColor(),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildDarkModeSwitch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 8.0),
      child: Row(
        children: <Widget>[
          Text(
            'Toggle Dark Mode',
            style: TextStyle(
              color: AppTheme.textColor(),
            ),
          ),
          const Spacer(),
          Obx(
            () => IconButton(
              icon: Icon(
                UserSettingsController.useDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () {
                setState(UserSettingsController.toggleDarkMode);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => Dialog(
        backgroundColor: AppTheme.backgroundColor(),
        child: SizedBox(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                buildHeader(),
                Expanded(child: Container()),
                buildDivider(),
                buildDarkModeSwitch(),
                buildDivider(),
                buildSystemControls(),
                buildDivider(),
                buildAboutSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
