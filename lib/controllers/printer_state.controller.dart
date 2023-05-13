import 'package:get/get.dart';

/// Holds state data for the printer that we are currently connected to

class PrinterStateController {
  static RxDouble extruder0Temp = 0.0.obs;
  static RxInt extruder0Power = 0.obs;
  static RxDouble extruder0Target = 0.0.obs;

  static RxDouble extruder1Temp = 0.0.obs;
  static RxInt extruder1Power = 0.obs;
  static RxDouble extruder1Target = 0.0.obs;

  static RxDouble bedTemp = 0.0.obs;
  static RxInt bedPower = 0.obs;
  static RxDouble bedTarget = 0.0.obs;

  static RxInt fanSpeed = 0.obs;

  static RxString stateMessage = ''.obs;
  static RxString filename = ''.obs;
  static RxDouble totalDuration = 0.0.obs;
  static RxDouble printDuration = 0.0.obs;
  static RxInt totalLayers = 0.obs;
  static RxInt currentLayer = 0.obs;

  static RxDouble moveSpeed = 0.0.obs;
  static RxBool absoluteCoordinates = false.obs;
  static RxList<dynamic> position = <dynamic>[0.0, 0.0, 0.0, 0.0].obs;

  static RxDouble maxVelocity = 0.0.obs;
  static RxDouble maxAcceleration = 0.0.obs;
  static RxDouble squareCornerVelocity = 0.0.obs;
  static RxDouble smoothTime = 0.0.obs;
  static RxDouble pressureAdvance = 0.0.obs;

  /// Moonraker Stats
  static RxDouble cpuUsage = 0.0.obs;
  static RxDouble cpuTemp = 0.0.obs;
  static RxInt memTotal = 0.obs;
  static RxInt memUsed = 0.obs;

  /// List to hold the past response strings
  static RxList<dynamic> consoleResponses = <dynamic>[].obs;
}
