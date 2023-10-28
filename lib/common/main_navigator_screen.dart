import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jaljayo/common/widgets/nav_tab.dart';

class MainNavigator extends StatefulWidget {
  final int page;
  final Function(int) changeFunc;

  const MainNavigator({
    super.key,
    this.page = 0,
    required this.changeFunc,
  });

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          NavigationTab(
            name: 'sleep',
            icon: FontAwesomeIcons.bed,
            selected: widget.page == 0,
            onTap: () => widget.changeFunc(0),
          ),
          NavigationTab(
            name: 'sensors',
            icon: FontAwesomeIcons.signal,
            selected: widget.page == 1,
            onTap: () => widget.changeFunc(1),
          ),
        ],
      ),
    );
  }
}
