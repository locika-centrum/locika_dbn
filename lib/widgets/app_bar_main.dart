import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

Logger _log = Logger('app_bar_main.dart');

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const MainAppBar(this.title, {Key? key}) : super(key: key);

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(52.0 + 16.0 + 16.0);
}

class _MainAppBarState extends State<MainAppBar> {
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 62.0 + 16.0,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Image.asset(
              'assets/images/dbn_logo.png',
              height: 30.0,
            ),
            onLongPressStart: (_) {
              _timer = Timer(const Duration(milliseconds: 500), () {
                GoRouter.of(context).push('/chat_splash');
              });
            },
            onLongPressEnd: (_) => _timer.cancel(),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    );
  }
}
