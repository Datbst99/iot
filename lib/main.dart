import 'dart:ui';

import 'package:flutter/material.dart';
import 'Configs/constant.dart';
import 'Configs/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iot smart',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: backColor),
        scaffoldBackgroundColor: backColor,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textColor),
          bodyMedium: TextStyle(color: textColor),
          bodySmall: TextStyle(color: textColor),
        ),
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          color: primaryColor,
          titleTextStyle: TextStyle(
              color: whiteColor, fontSize: 20, fontWeight: FontWeight.w500),
          centerTitle: true,
        ),
      ),
      onGenerateRoute: RouteApp.generateRoute,
    );
  }
}

