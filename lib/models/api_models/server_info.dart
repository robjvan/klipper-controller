// // ignore_for_file: non_constant_identifier_names

// class ServerInfo {
//   final bool klippy_connected;
//   final String klippy_state;
//   final List<dynamic> components;
//   final List<dynamic> failed_components;
//   final List<dynamic> registered_directories;
//   final List<dynamic> warnings;
//   final int websocket_count;
//   final dynamic moonraker_version;
//   final List<dynamic> api_version;
//   final String api_version_string;

//   ServerInfo({
//     required this.klippy_connected,
//     required this.klippy_state,
//     required this.components,
//     required this.failed_components,
//     required this.registered_directories,
//     required this.warnings,
//     required this.websocket_count,
//     required this.moonraker_version,
//     required this.api_version,
//     required this.api_version_string,
//   });

//   factory ServerInfo.initial() {
//     return ServerInfo(
//       klippy_connected: false,
//       klippy_state: '',
//       components: <dynamic>[],
//       failed_components: <dynamic>[],
//       registered_directories: <dynamic>[],
//       warnings: <dynamic>[],
//       websocket_count: 0,
//       moonraker_version: '',
//       api_version: <dynamic>[],
//       api_version_string: '',
//     );
//   }

//   factory ServerInfo.fromJson(final Map<String, dynamic> json) {
//     return ServerInfo(
//       klippy_connected: json['result']['klippy_connected'],
//       klippy_state: json['result']['klippy_state'],
//       components: json['result']['components'],
//       failed_components: json['result']['failed_components'],
//       registered_directories: json['result']['registered_directories'],
//       warnings: json['result']['warnings'],
//       websocket_count: json['result']['websocket_count'],
//       moonraker_version: json['result']['moonraker_version'],
//       api_version: json['result']['api_version'],
//       api_version_string: json['result']['api_version_string'],
//     );
//   }
// }
