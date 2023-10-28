import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const MainAppBar({
    super.key,
    this.title = 'JalJaYo',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.bluetooth),
          ),
        ),
      ],
      backgroundColor: Colors.blueAccent,
      elevation: 3,
      title: Text(
        title,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
