import 'package:flutter/material.dart';
import 'package:jaljayo/main_navigator/main_navigator_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeURL = '/';
  static const routeName = "home";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home'),
      ),
      bottomNavigationBar: MainNavigator(),
    );
  }
}
