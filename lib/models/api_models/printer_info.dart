// class PrinterInfo {
//   final String state;
//   final String stateMessage;
//   final String hostName;
//   final String softwareVersion;
//   final String cpuInfo;
//   final String klipperPath;
//   final String pythonPath;
//   final String logFile;
//   final String configFile;

//   PrinterInfo({
//     required this.state,
//     required this.stateMessage,
//     required this.hostName,
//     required this.softwareVersion,
//     required this.cpuInfo,
//     required this.klipperPath,
//     required this.pythonPath,
//     required this.logFile,
//     required this.configFile,
//   });

//   factory PrinterInfo.initial() => PrinterInfo(
//         state: '',
//         stateMessage: '',
//         hostName: '',
//         softwareVersion: '',
//         cpuInfo: '',
//         klipperPath: '',
//         pythonPath: '',
//         logFile: '',
//         configFile: '',
//       );

//   factory PrinterInfo.fromJson(final Map<String, dynamic> json) => PrinterInfo(
//         state: json['result']['state'],
//         stateMessage: json['result']['state_message'],
//         hostName: json['result']['hostname'],
//         softwareVersion: json['result']['software_version'],
//         cpuInfo: json['result']['cpu_info'],
//         klipperPath: json['result']['klipper_path'],
//         pythonPath: json['result']['python_path'],
//         logFile: json['result']['log_file'],
//         configFile: json['result']['config_file'],
//       );
// }
