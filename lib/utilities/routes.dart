import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:klipper_controller/pages/pages.dart';

@immutable
class AppRoutes {
  static const String initialRoute = LoginPage.routeName;

  static final List<GetPage<dynamic>> getPages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: DashboardPage.routeName,
      page: DashboardPage.new,
    ),
    GetPage<dynamic>(
      name: LoginPage.routeName,
      page: LoginPage.new,
    ),
  ];
}
