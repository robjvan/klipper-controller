// import 'package:flutter/foundation.dart';

// @immutable
// class HeaterbedData {
//   final double temperature;
//   final double target;
//   final double power;

//   const HeaterbedData({
//     required this.temperature,
//     required this.target,
//     required this.power,
//   });

//   factory HeaterbedData.initial() {
//     return const HeaterbedData(
//       temperature: -1,
//       target: 0,
//       power: 0,
//     );
//   }

//   factory HeaterbedData.fromJson(final Map<String, dynamic> json) {
//     return HeaterbedData(
//       temperature: json['params'][0]['heater_bed']['temperature'],
//       target: json['params'][0]['heater_bed']['target'],
//       power: json['params'][0]['heater_bed']['power'],
//     );
//   }

//   HeaterbedData copyWith({
//     final double? temperature,
//     final double? target,
//     final double? power,
//   }) {
//     return HeaterbedData(
//       temperature: temperature ?? this.temperature,
//       target: target ?? this.target,
//       power: power ?? this.power,
//     );
//   }

//   @override
//   bool operator ==(final Object other) =>
//       identical(this, other) ||
//       other is HeaterbedData &&
//           other.temperature == temperature &&
//           other.power == power &&
//           other.target == target;

//   @override
//   int get hashCode => temperature.hashCode ^ power.hashCode ^ target.hashCode;
// }
