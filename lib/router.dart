import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jaljayo/feature/home/view/home_screen.dart';
import 'package:jaljayo/feature/sensors/views/sensor_screen.dart';
import 'package:jaljayo/feature/sleep_analysis/view/sleep_analysis_screen.dart';
import 'package:jaljayo/feature/sleep_analysis/view/sleep_state_screen.dart';

final routerProvier = Provider(
  (ref) {
    return GoRouter(
      initialLocation: "/",
      routes: [
        GoRoute(
          path: HomeScreen.routeURL,
          name: HomeScreen.routeName,
          pageBuilder: (context, state) => const MaterialPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: SensorScreen.routeURL,
          name: SensorScreen.routeName,
          pageBuilder: (context, state) => const MaterialPage(
            child: SensorScreen(),
          ),
        ),
        GoRoute(
          path: SleepAnalysisScreen.routeURL,
          name: SleepAnalysisScreen.routeName,
          pageBuilder: (context, state) => const MaterialPage(
            child: SleepAnalysisScreen(),
          ),
        ),
      ],
    );
  },
);
