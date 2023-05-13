// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:klipper_controller/pages/dashboard.page.dart';
// import 'package:klipper_controller/services/klipper.service.dart';
// import 'package:klipper_controller/utilities/utilities.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   static const String routeName = '/login';

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController addressController = TextEditingController();
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     addressController.text = '192.168.0.82';
//   }

//   @override
//   void dispose() {
//     addressController.dispose();
//     super.dispose();
//   }

//   /// Build button to connect to the server
//   Widget buildConnectBtn() {
//     return ElevatedButton(
//       onPressed: addressController.text.isEmpty
//           ? null
//           : () {
//               if (formKey.currentState!.validate()) {
//                 KlipperService.connectToPrinter(addressController.text);
//                 Get.offAndToNamed(
//                   DashboardPage.routeName,
//                   arguments: <String, dynamic>{
//                     'address': addressController.text,
//                   },
//                 );
//               }
//             },
//       // onPressed: AppStateController.printerAddress.value == ''
//       //     ? null
//       //     : () => setState(
//       //           () => SocketsService.connectToPrinter(
//       //             AppStateController.printerAddress.value,
//       //           ),
//       //         ),
//       child: const Text('Connect to printer'),
//     );
//   }

//   Widget buildAddressForm() {
//     return Container(
//       padding: const EdgeInsets.only(bottom: 64, top: 32),
//       width: 500,
//       child: Center(
//         child: Form(
//           key: formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               const Text(
//                 'Printer IP Address',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 32,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               SizedBox(
//                 width: 150,
//                 child: TextFormField(
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   validator: (final dynamic value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Address cannot be empty';
//                     } else if (!AppValidators.ip(value)) {
//                       return 'Must be a valid IP address';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     setState(() {});
//                   },
//                   controller: addressController,
//                   decoration: const InputDecoration(
//                     hintText: 'Printer Address',
//                   ),
//                   style: TextStyle(fontSize: 24),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(final BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: GestureDetector(
//           /// This GestureDetector allows us to easily hide the soft keybaord
//           /// by clicking outside of a textfield
//           onTapDown: (final _) => FocusManager.instance.primaryFocus?.unfocus(),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 buildAddressForm(),
//                 buildConnectBtn(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
