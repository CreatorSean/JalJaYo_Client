import 'package:flutter/material.dart';

class NavigationTab extends StatefulWidget {
  final String name;
  final IconData icon;

  const NavigationTab({
    super.key,
    this.name = 'home',
    this.icon = Icons.home,
  });

  @override
  State<NavigationTab> createState() => _NavigationTabState();
}

class _NavigationTabState extends State<NavigationTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(widget.icon),
        Text(widget.name),
      ],
    );
  }
}
