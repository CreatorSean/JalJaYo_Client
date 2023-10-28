import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jaljayo/main_navigator/nav_tab.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  @override
  Widget build(BuildContext context) {
    return const BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavigationTab(
            name: 'sleep',
            icon: FontAwesomeIcons.bed,
          ),
          NavigationTab(
            name: 'sensors',
            icon: FontAwesomeIcons.signal,
          ),
        ],
      ),
    );
  }
}
