// import 'package:flutter/foundation.dart';

// @immutable
// class ExtruderData {
//   final double? temperature;
//   final double? target;
//   final double? power;

//   const ExtruderData({
//     this.temperature,
//     this.target,
//     this.power,
//   });

//   factory ExtruderData.initial() {
//     return const ExtruderData(
//       temperature: -1,
//       target: 0,
//       power: 0,
//     );
//   }

//   factory ExtruderData.fromJson(final Map<String, dynamic> json) {
//     return ExtruderData(
//       temperature: json['params'][0]['extruder']['temperature'],
//       target: json['params'][0]['extruder']['target'],
//       power: json['params'][0]['extruder']['power'],
//     );
//   }

//   ExtruderData copyWith({
//     final double? temperature,
//     final double? target,
//     final double? power,
//   }) {
//     return ExtruderData(
//       temperature: temperature ?? this.temperature,
//       target: target ?? this.target,
//       power: power ?? this.power,
//     );
//   }

//   @override
//   bool operator ==(final Object other) =>
//       identical(this, other) ||
//       other is ExtruderData &&
//           other.temperature == temperature &&
//           other.power == power &&
//           other.target == target;

//   @override
//   int get hashCode => temperature.hashCode ^ power.hashCode ^ target.hashCode;
// }
