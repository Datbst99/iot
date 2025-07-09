
import 'package:flutter/material.dart';
import '/Views/MonitorPressure/monitor_pressure_detail_screen.dart';
import '/Views/MonitorQuality/monitor_quality_detail_screen.dart';
import '/Views/MonthlyOutputChart/monthy_output_screen.dart';

import '../Views/Authentication/login_screen.dart';
import '../Views/MonitorPressure/monitor_pressure_screen.dart';
import '../Views/MonitorQuality/monitor_quality_screen.dart';
import '../Views/splash_screen.dart';

class RouteApp{
  static const String splash = "/splash";
  static const String login = "/login";
  static const String monitorPressure = "/monitorPressure";
  static const String monitorPressureDetail = "/monitorPressureDetail";
  static const String monitorQuality = "/monitorQuality";
  static const String monitorQualityDetail = "/monitorQualityDetail";
  static const String monthlyOutput = "/monthlyOutput";


  static const String home = "/home";
  static const String networkMonitor = "/networkMonitor";
  static const String yield = "/yield";

  static const String quantityMonitoring = "/quantityMonitoring";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteApp.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RouteApp.home:
        return MaterialPageRoute(builder: (_) => MonitorPressureScreen());
      case RouteApp.monitorPressure:
        return MaterialPageRoute(builder: (_) => MonitorPressureScreen());
      case RouteApp.monitorPressureDetail:
        final id = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => MonitorPressureDetailScreen(id: id,));
      case RouteApp.monitorQuality:
        return MaterialPageRoute(builder: (_) => MonitorQualityScreen());
      case RouteApp.monitorQualityDetail:
        final id = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => MonitorQualityDetailScreen(id: id,));
      case RouteApp.monthlyOutput:
        return MaterialPageRoute(builder: (_) => MonthlyOutputScreen());
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }
}