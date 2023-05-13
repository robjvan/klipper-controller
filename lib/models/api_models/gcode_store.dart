// import 'package:klipper_controller/models/api_models/api_models.dart';

// class GcodeStore {
//   final List<GCodeMessage> gCodeMessages;

//   GcodeStore({required this.gCodeMessages});

//   factory GcodeStore.initial() => GcodeStore(gCodeMessages: <GCodeMessage>[]);

//   factory GcodeStore.fromJson(final Map<String, dynamic> json) => GcodeStore(
//         gCodeMessages: json['gcode_store']
//             .toList()
//             .map(
//               (final dynamic element) => GCodeMessage(
//                 message: element['message'],
//                 time: element['time'],
//                 type: element['type'],
//               ),
//             )
//             .toList(),
//       );
// }
