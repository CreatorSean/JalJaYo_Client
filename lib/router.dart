import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jaljayo/feature/authentication/repos/authentication_repo.dart';
import 'package:jaljayo/feature/authentication/views/login_screen.dart';
import 'package:jaljayo/feature/authentication/views/sign_up_screen.dart';
import 'package:jaljayo/feature/home/view/home_screen.dart';
import 'package:jaljayo/feature/sensors/views/sensor_screen.dart';
import 'package:jaljayo/feature/sleep_analysis/view/sleep_analysis_screen.dart';
import 'package:jaljayo/feature/sleep_analysis/view/sleep_state_screen.dart';

final routerProvier = Provider(
  (ref) {
    return GoRouter(
      initialLocation: "/home",
      redirect: (context, state) {
        final isLoggedIn = ref.read(authRepo).isLoggedIn;
        //subloc은 user가 있는 location을 뜻한다.
        if (!isLoggedIn) {
          if (state.subloc != SignUpScreen.routeURL &&
              state.subloc != LoginScreen.routeURL) {
            return SignUpScreen.routeURL;
          }
        }
        return null;
      },
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
        GoRoute(
          name: SignUpScreen.routeName,
          path: SignUpScreen.routeURL,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          name: LoginScreen.routeName,
          path: LoginScreen.routeURL,
          builder: (context, state) => const LoginScreen(),
        ),
      ],
    );
  },
);
