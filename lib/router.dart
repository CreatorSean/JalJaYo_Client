import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jaljayo/feature/home/view/home_screen.dart';

final routerProvier = Provider(
  (ref) {
    return GoRouter(
      initialLocation: "/",
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const MaterialPage(
            child: HomeScreen(),
          ),
        ),
      ],
    );
  },
);
