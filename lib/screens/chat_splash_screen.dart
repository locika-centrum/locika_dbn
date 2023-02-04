import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatSplashScreen extends StatefulWidget {
  const ChatSplashScreen({Key? key}) : super(key: key);

  @override
  State<ChatSplashScreen> createState() => _ChatSplashScreenState();
}

class _ChatSplashScreenState extends State<ChatSplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      //Navigator.pop(context);
      //GoRouter.of(context).push('/chat_intro');
      context.go('/chat_intro');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/dbn_logo.png',
          height: 48,
        ),
      ),
    );
    /*
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
     */
  }
}
