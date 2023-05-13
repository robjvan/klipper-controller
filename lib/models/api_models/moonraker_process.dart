// class MoonrakerProcess {
//   double cpuTemp;
//   double cpuUsage;

//   MoonrakerProcess({
//     required this.cpuUsage,
//     required this.cpuTemp,
//   });

//   factory MoonrakerProcess.fromJson(final Map<String, dynamic> json) =>
//       MoonrakerProcess(
//         cpuUsage: json['system_cpu_usage']['cpu'],
//         cpuTemp: json['cpu_temp'],
//       );

//   factory MoonrakerProcess.initial() => MoonrakerProcess(
//         cpuUsage: 0.0,
//         cpuTemp: 0.0,
//       );

//   MoonrakerProcess copyWith({
//     final double? cpuTemp,
//     final double? cpuUsage,
//   }) =>
//       MoonrakerProcess(
//         cpuUsage: cpuUsage ?? this.cpuUsage,
//         cpuTemp: cpuTemp ?? this.cpuTemp,
//       );
// }
