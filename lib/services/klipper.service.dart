// ignore_for_file: unnecessary_lambdas, avoid_init_to_null

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:json_rpc_2/json_rpc_2.dart';
import 'package:klipper_controller/controllers/controllers.dart';
import 'package:klipper_controller/models/models.dart';
import 'package:klipper_controller/utilities/utilities.dart';
import 'package:klipper_controller/widgets/dialogs/printer_error_dialog.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@immutable
class KlipperService {
  // static IO.Socket? printerSocket = null;
  static Client? client = null;
  static WebSocketChannel? printerSocket = null;
  static int? websocketId = null;
  static bool keepAlive = false;
  static late WebSocket? testSocket;
  static late bool connected;

  /// Opens a websocket connection to the printer at given ip [address]
  static Future<void> connectToPrinter(final String address) async {
    /// Establish a websocket channel to communicate with the printer
    try {
      /// Build a standard websocket so we can check for connectivity with the printer
      testSocket = await WebSocket.connect('ws://$address:7125/websocket');
      if (testSocket != null) {
        connected = true;
      }
    } on Exception catch (_) {
      /// Could not connect to the printer, show error dialog
      connected = false;
      unawaited(
        Get.dialog(
          const PrinterErrorDialog(),
        ),
      );
    }

    if (connected) {
      /// if test connection was live, create websocketchannel for communications
      await testSocket!.close();
      printerSocket =
          WebSocketChannel.connect(Uri.parse('ws://$address:7125/websocket'));
      client = Client(printerSocket!.cast<String>());
      AppStateController.isConnected.value = true;
    }
  }

  /// Kills active printer connection
  static Future<void> killConnection(final String ip) async {
    /// Wait for all resources to be released
    await client!.close();

    /// Send en empty subscribe request to unsubscribe from the printer
    unawaited(
      http.get(
        Uri.parse(
          'http://$ip:7125/printer/objects/subscribe?connection_id=$websocketId',
        ),
      ),
    );
    dev.log('Printer connection has been closed');

    /// Clear local client variable
    client = null;

    /// Clear connection data in AppState
    AppStateController.printer!.value = Printer.initial();
  }

  /// Subscribes to the printer using JSON-RPC request
  static void subscribeToPrinterObjects() {
    /// Grab a new ID for the request
    final int id = newId();

    try {
      /// Fire the request
      client!.sendRequest(
        'printer.objects.subscribe',
        <String, dynamic>{
          'objects': <String, dynamic>{
            'toolhead': null,
            'gcode_move': null,
            'print_stats': null,
            'heater_bed': null,
            'extruder': null,
            'fan': null,
            'webhooks': null,
            // 'heater_fan'
          },
          'id': id,
        },
      ).onError((final dynamic error, final StackTrace stackTrace) {
        // TODO(Rob): handle errors
        print(error);
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  /// Checks if connection to server is live
  static bool isConnected() {
    return client != null;

    // if (client != null) {
    //   return !client!.isClosed;
    // } else {
    //   return false;
    // }
  }

  /// Subscribes to the printer using http request and given [websocketId]
  static void subscribeToPrinter(final String ip, final int websocketId) {
    final String requestURLString =
        'http://$ip:7125/printer/objects/subscribe?connection_id=$websocketId'
        '&toolhead'
        '&heater_bed'
        '&extruder'
        '&fan'
        '&heater_fan&extruder_fan'
        '&heater_fan&stepstick_fan'
        '&print_stats'
        '&webhooks';
    http.get(Uri.parse(requestURLString));
  }

  /// Processes incoming [snapshot] data
  static void parseSnapshotData({
    required final AsyncSnapshot<dynamic> snapshot,
    required final String printerIp,
    // required int socketId,
  }) {
    final Map<String, dynamic> passedData = json.decode(snapshot.data);

    if (passedData['error'] != null) {
      /// Handle API errors
      KlipperService.killConnection(printerIp);
      final Map<String, dynamic> error = passedData['error']['message'];
      dev.log(error.toString());
    } else if (passedData['method'] != null) {
      switch (passedData['method']) {
        case 'notify_klippy_disconnected':

          /// Moonraker's connection to Klippy has terminated

          break;

        /// Parse moonraker system stats
        case 'notify_proc_stat_update':
          // PrinterStateController.consoleResponses.add(passedData['params']);
          parseMoonrakerStats(passedData);
          break;
        case 'notify_gcode_response':
          PrinterStateController.consoleResponses.add(passedData['params'][0]);

          /// Ignore "not printing" status updates
          /// Ignore "ok" messages
          final String responseMsg = passedData['params'][0];

          if (responseMsg == 'Not SD printing.' || responseMsg == 'ok') {
            break;
          }

          /// Parse extruder temp
          if (responseMsg.contains('T0:')) {
            final String newTemp = responseMsg
                .substring(
                  responseMsg.indexOf('T0:') + 3,
                  responseMsg.indexOf('T0:') + 7,
                )
                .trim();
            PrinterStateController.extruder0Temp.value = double.parse(newTemp);
          }

          /// Parse 2nd extruder temp
          if (responseMsg.contains('T1:')) {
            final String newTemp = responseMsg
                .substring(
                  responseMsg.indexOf('T1:') + 3,
                  responseMsg.indexOf('T1:') + 7,
                )
                .trim();
            PrinterStateController.extruder1Temp.value = double.parse(newTemp);
          }

          /// Parse bed temp
          if (responseMsg.contains('B:')) {
            final String bedTempData = passedData['params'][0];
            final String newBedTemp = bedTempData
                .substring(
                  bedTempData.indexOf('B:') + 2,
                  bedTempData.indexOf('B:') + 6,
                )
                .trim();
            PrinterStateController.bedTemp.value = double.parse(newBedTemp);
          }

          break;
        case 'notify_status_update':
          // PrinterStateController.consoleResponses.add(
          //   passedData['params'].toString(),
          // );

          /// Parse extruder0 data
          if (passedData['params'][0]['extruder'] != null) {
            parseExtruder0Data(passedData);
          }

          /// Parse bed data
          if (passedData['params'][0]['heater_bed'] != null) {
            parseHeatedBedData(passedData);
          }

          /// Parse cooling fan speed data
          if (passedData['params'][0]['fan'] != null) {
            /// Parse the raw data
            final double rawFanSpeed = passedData['params'][0]['fan']['speed'];

            /// Convert to a usable value
            final int fanSpeed = (rawFanSpeed * 100).round();

            /// Update the state
            PrinterStateController.fanSpeed.value = fanSpeed;
          }
          break;
        default:
          // secondString = passedData.toString();
          break;
      }
    } else if (passedData['result'] == 'ok') {
      PrinterStateController.consoleResponses.add(passedData['result']);
      // ignore these messages, do nothing
    } else if (passedData['result']['websocket_id'] != null) {
      /// Process the websocket ID, needed to subscribe to the printer
      websocketId = json.decode(snapshot.data)['result']['websocket_id'];
      KlipperService.subscribeToPrinter(printerIp, websocketId!);
    } else if (passedData['result']['status'] != null) {
      // final String status = passedData['result'].toString();
      // PrinterStateController.consoleResponses.add(passedData['result']);
      parsePrinterStatus(passedData);
    } else {
      /// Some other type of message, these are usually handled individually
      PrinterStateController.consoleResponses.add(passedData['result']);
    }
  }

  /// Extracts host system stats
  static void parseMoonrakerStats(final Map<String, dynamic> passedData) {
    if (passedData['params'][0]['moonraker_stats']['cpu_usage'] != null) {
      PrinterStateController.cpuUsage.value =
          passedData['params'][0]['moonraker_stats']['cpu_usage'];
    }
    if (passedData['params'][0]['cpu_temp'] != null) {
      PrinterStateController.cpuTemp.value =
          passedData['params'][0]['cpu_temp'];
    }
    if (passedData['params'][0]['system_memory']['total'] != null) {
      PrinterStateController.memTotal.value =
          passedData['params'][0]['system_memory']['total'];
    }
    if (passedData['params'][0]['system_memory']['used'] != null) {
      PrinterStateController.memUsed.value =
          passedData['params'][0]['system_memory']['used'];
    }
  }

  /// Extracts printer state, temps, position, and more
  static void parsePrinterStatus(final Map<String, dynamic> passedData) {
    /// Parse printer state
    if (passedData['result']['status']['webhooks']['state_message'] != null) {
      PrinterStateController.stateMessage.value =
          passedData['result']['status']['webhooks']['state_message'];
    }

    /// Parse printer stats
    if (passedData['result']['status']['print_stats']['filename'] != null) {
      PrinterStateController.filename.value =
          passedData['result']['status']['print_stats']['filename'];
    }
    if (passedData['result']['status']['print_stats']['total_duration'] !=
        null) {
      PrinterStateController.totalDuration.value =
          passedData['result']['status']['print_stats']['total_duration'];
    }
    if (passedData['result']['status']['print_stats']['printDuration'] !=
        null) {
      PrinterStateController.printDuration.value =
          passedData['result']['status']['print_stats']['printDuration'];
    }
    if (passedData['result']['status']['print_stats']['info']['total_layer'] !=
        null) {
      PrinterStateController.totalLayers.value =
          passedData['result']['status']['print_stats']['info']['total_layer'];
    }
    if (passedData['result']['status']['print_stats']['info']
            ['current_layer'] !=
        null) {
      PrinterStateController.currentLayer.value = passedData['result']['status']
          ['print_stats']['info']['current_layer'];
    }

    /// Parse heated bed data
    if (passedData['result']['status']['heater_bed']['temperature'] != null) {
      PrinterStateController.bedTemp.value =
          passedData['result']['status']['heater_bed']['temperature'];
    }
    if (passedData['result']['status']['heater_bed']['target'] != null) {
      PrinterStateController.bedTarget.value =
          passedData['result']['status']['heater_bed']['target'];
    }
    if (passedData['result']['status']['heater_bed']['power'] != null) {
      PrinterStateController.bedPower.value =
          (passedData['result']['status']['heater_bed']['power'] * 100).round();
    }

    /// Parse extruder data
    if (passedData['result']['status']['extruder']['temperature'] != null) {
      PrinterStateController.bedTemp.value =
          passedData['result']['status']['extruder']['temperature'];
    }
    if (passedData['result']['status']['extruder']['target'] != null) {
      PrinterStateController.bedTarget.value =
          passedData['result']['status']['extruder']['target'];
    }
    if (passedData['result']['status']['extruder']['power'] != null) {
      PrinterStateController.extruder0Power.value =
          (passedData['result']['status']['extruder']['power'] * 100).round();
    }
    if (passedData['result']['status']['extruder']['pressure_advance'] !=
        null) {
      PrinterStateController.pressureAdvance.value =
          passedData['result']['status']['extruder']['pressure_advance'];
    }
    if (passedData['result']['status']['extruder']['smooth_time'] != null) {
      PrinterStateController.smoothTime.value =
          passedData['result']['status']['extruder']['smooth_time'];
    }

    // /// Parse fan speed data
    // if (passedData['result']['status']['fan']['speed'] != null) {
    //   final double fanSpeed =
    //       passedData['result']['status']['extruder']['smooth_time'];
    //   if (fanSpeed > 0) {
    //     PrinterStateController.fanSpeed.value = (fanSpeed * 100).round();
    //   }
    // }

    /// Parse tool head data
    if (passedData['result']['status']['toolhead']['max_velocity'] != null) {
      PrinterStateController.maxVelocity.value =
          passedData['result']['status']['toolhead']['max_velocity'];
    }
    if (passedData['result']['status']['toolhead']['max_accel'] != null) {
      PrinterStateController.maxAcceleration.value =
          passedData['result']['status']['toolhead']['max_accel'];
    }
    if (passedData['result']['status']['toolhead']['square_corner_velocity'] !=
        null) {
      PrinterStateController.squareCornerVelocity.value =
          passedData['result']['status']['toolhead']['square_corner_velocity'];
    }
    if (passedData['result']['status']['toolhead']['position'] != null) {
      PrinterStateController.position.value =
          passedData['result']['status']['toolhead']['position'];
    }
    if (passedData['result']['status']['gcode_move']['absolute_coordinates'] !=
        null) {
      PrinterStateController.absoluteCoordinates.value =
          passedData['result']['status']['gcode_move']['absolute_coordinates'];
    }
    if (passedData['result']['status']['gcode_move']['speed'] != null) {
      PrinterStateController.moveSpeed.value =
          passedData['result']['status']['gcode_move']['speed'];
    }
  }

  /// Extracts temp, power, and target from extruder data
  static void parseExtruder0Data(final Map<String, dynamic> passedData) {
    if (passedData['params'][0]['extruder']['temperature'] != null) {
      PrinterStateController.extruder0Temp.value =
          passedData['params'][0]['extruder']['temperature'];
    }
    if (passedData['params'][0]['extruder']['target'] != null) {
      PrinterStateController.extruder0Target.value =
          passedData['params'][0]['extruder']['target'];
    }
    if (passedData['params'][0]['extruder']['power'] != null) {
      PrinterStateController.extruder0Power.value =
          (passedData['params'][0]['extruder']['power'] * 100).round();
    }
  }

  /// Extracts temp, power, and target from heated bed data
  static void parseHeatedBedData(final Map<String, dynamic> passedData) {
    if (passedData['params'][0]['heater_bed']['temperature'] != null) {
      PrinterStateController.bedTemp.value =
          passedData['params'][0]['heater_bed']['temperature'];
    }
    if (passedData['params'][0]['heater_bed']['target'] != null) {
      PrinterStateController.bedTarget.value =
          passedData['params'][0]['heater_bed']['target'];
    }
    if (passedData['params'][0]['heater_bed']['power'] != null) {
      PrinterStateController.bedPower.value =
          (passedData['params'][0]['heater_bed']['power'] * 100).round();
    }
  }

  /// Extracts fan speed from cooling fan data
  static void parseFanSpeedData(final Map<String, dynamic> passedData) {
    final double fanSpeed =
        passedData['result']['status']['fan']['speed'].toDouble();

    if (fanSpeed > 0) {
      PrinterStateController.fanSpeed.value = (fanSpeed * 100).round();
    }
  }

  /// Generate a "random" number between 1 and 2,147,395,600
  static int newId() {
    return Random().nextInt(46340) * Random().nextInt(46340);
  }

  /// Builds a fun printer image
  static Widget buildPrinterImage(final int printerType) {
    String imageAssetPath = '';

    switch (printerType) {
      case 1:
        // case PrinterType.cartesian:
        imageAssetPath = 'assets/images/printer2.png';
        break;
      case 2:
        // case PrinterType.corexy:
        imageAssetPath = 'assets/images/printer.png';
        break;
      case 3:
        // case PrinterType.delta:
        imageAssetPath = 'assets/images/printer3.png';
        break;
      default:
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Image.asset(
        imageAssetPath,
        fit: BoxFit.cover,
        width: Get.width / 3,
      ),
    );
  }

  /// Sends a snippet of GCode to the printer
  ///
  /// Example:
  /// ```dart
  /// KlipperService.sendGcodeScript('G91');
  /// ```
  static void sendGcodeScript(final String script) {
    // TODO(Rob): Add more validation!
    if (client != null) {
      client!.sendRequest(
        'printer.gcode.script',
        <String, String>{'script': script},
      ).onError((final dynamic err, final StackTrace st) {
        /// Client closed connection while request is in flight
        // print("'response in flight' error");

        /// Ignore.
      });
    } else {
      /// We are not connected to the printer!
      // TODO(Rob): Pop up some sort of error message?
    }
  }

  /// Sends a "preheat" command for the given [filament] to the printer.
  ///
  /// ```dart
  /// KlipperService.preheat(Filament.PLA);
  /// ```
  static void preheat(final Filament filament) {
    int heaterTemp = 0;
    int bedTemp = 0;

    switch (filament) {
      case Filament.PLA:
        heaterTemp = PreheatPresets.PLA['extruder']!;
        bedTemp = PreheatPresets.PLA['bedTemp']!;
        break;
      case Filament.ABS:
        heaterTemp = PreheatPresets.ABS['extruder']!;
        bedTemp = PreheatPresets.ABS['bedTemp']!;
        break;
      case Filament.PETG:
        heaterTemp = PreheatPresets.PETG['extruder']!;
        bedTemp = PreheatPresets.PETG['bedTemp']!;
        break;
      case Filament.TPU:
        heaterTemp = PreheatPresets.TPU['extruder']!;
        bedTemp = PreheatPresets.TPU['bedTemp']!;
        break;
      case Filament.NYLON:
        heaterTemp = PreheatPresets.NYLON['extruder']!;
        bedTemp = PreheatPresets.NYLON['bedTemp']!;
        break;
      default:
        break;
    }

    /// Send the actual commands
    sendGcodeScript('M104 T0 S$heaterTemp');
    if (AppStateController.printer!.value.hasHeatedBed) {
      sendGcodeScript('M140 S$bedTemp');
    }
  }

  /// Sends cooldown command, disables all heaters
  static void cooldown() {
    sendGcodeScript('M104 T0 S0');

    if (AppStateController.printer!.value.hasSecondExtruder) {
      sendGcodeScript('M104 T1 S0');
    }
    if (AppStateController.printer!.value.hasHeatedBed) {
      sendGcodeScript('M140 S0');
    }

    PrinterStateController.extruder0Target.value = 0;
    PrinterStateController.extruder1Target.value = 0;
    PrinterStateController.bedTarget.value = 0;
  }

  static void requestCachedData() {
    if (client != null) {
      client!.sendRequest('printer.object.query');
    }
  }

  /// Flip between Absolute and Relative coordinates
  ///
  /// Example:
  /// ```dart
  /// KlipperService.toggleAbsoluteCoordinates();
  /// ```
  static void toggleAbsoluteCoordinates() {
    if (PrinterStateController.absoluteCoordinates.isTrue) {
      sendGcodeScript('G91');
    } else {
      sendGcodeScript('G90');
    }
    queryStatus();
  }

  /// Sends a command to the set the cooling fan speed
  static void setFanSpeed(double speedPercent) {
    /// Ensure our input value is within range, fix if necessary
    if (speedPercent < 0) {
      speedPercent = 0;
    } else if (speedPercent > 100) {
      speedPercent = 100;
    }

    /// Convert our speed percentage to a value between 0 and 255
    final double speed = 255 * (speedPercent / 100);

    /// One last check that the value is valid, and send the command
    if (speed >= 0 && speed <= 255) {
      sendGcodeScript('M106 S$speed');
    }
  }

  /// Sends a home command to printer.  If no axis is supplied,
  /// printer will home all axes. If a [PrinterAxis]
  /// is supplied, pinter will only home that axis.
  ///
  /// Example:
  /// ```dart
  /// KlipperService.home(Axis.X);
  /// ```
  static void home([final PrinterAxis? axis]) {
    switch (axis) {
      case PrinterAxis.x:
        sendGcodeScript('G28 X');
        break;
      case PrinterAxis.y:
        sendGcodeScript('G28 Y');
        break;
      case PrinterAxis.z:
        sendGcodeScript('G28 Z');
        break;
      default:
        sendGcodeScript('G28');
        break;
    }
  }

  /// Send a request for printer object status
  ///
  /// Includes data on toolhead position, extruder and heater bed data, and more
  ///
  /// Example:
  /// ```dart
  /// KlipperService.queryStatus();
  /// ```
  static void queryStatus() {
    final int id = newId();

    client!.sendRequest(
      'printer.objects.query',
      <String, dynamic>{
        'objects': <String, dynamic>{
          'toolhead': null,
          'gcode_move': null,
          'print_stats': null,
          'heater_bed': null,
          'extruder': null,
          'fan': null,
          'webhooks': null,
        },
        'id': id,
      },
    ).onError((final dynamic error, final StackTrace stackTrace) {
      // TODO(Rob): handle errors
    });
  }
}
