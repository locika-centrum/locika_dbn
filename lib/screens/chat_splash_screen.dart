import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ChatSplashScreen extends StatelessWidget {
  const ChatSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      //Navigator.pop(context);
      GoRouter.of(context).push('/chat_intro');
    });

    return Scaffold(
      body: Column(
        children: [
          AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/dbn_logo.png',
                  height: 48,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
