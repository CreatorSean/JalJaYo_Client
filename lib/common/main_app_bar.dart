import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jaljayo/feature/bluetooth/views/bluetooth.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  const MainAppBar({
    super.key,
    this.title = 'JalJaYo',
  });
  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  void onBluetooth(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Bluetooth();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
            onPressed: () {
              onBluetooth(context);
            },
            icon: const Icon(FontAwesomeIcons.bluetooth),
          ),
        ),
      ],
      backgroundColor: const Color(0xff322D3F),
      elevation: 3,
      title: Text(
        widget.title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
