import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../settings/model/settings_data.dart';

Logger _log = Logger('app_bar_main.dart');

class AppBarMain extends StatelessWidget {
  const AppBarMain({super.key});

  @override
  Widget build(BuildContext context) {
    Timer? timer;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: Image.asset(
            'assets/images/dbn_logo.png',
            height: 30.0,
          ),
          onLongPressStart: (_) {
            timer = Timer(const Duration(milliseconds: 500), () {
              // HapticFeedback.vibrate();
              HapticFeedback.heavyImpact();
              HapticFeedback.heavyImpact();
              if (context.read<SettingsData>().firstLogin) {
                context.go('/chat_intro');
              } else {
                context.go('/login');
              }
            });
          },
          onLongPressEnd: (_) => timer?.cancel(),
        ),
      ],
    );
  }
}
