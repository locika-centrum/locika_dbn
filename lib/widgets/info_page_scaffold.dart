import 'package:flutter/material.dart';

import './app_bar_chat.dart';

class InfoPageScaffold extends StatelessWidget {
  final String title;
  final String route;
  final Widget body;
  final Widget? bottomButton;

  const InfoPageScaffold({
    this.route = '/',
    required this.title,
    required this.body,
    this.bottomButton,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        route: route,
      ),
      body: Stack(
        children: [
          body,
          if (bottomButton != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 8.0, left: 8.0, right: 8.0),
                child: SafeArea(child: bottomButton!),
              ),
            ),
        ],
      ),
    );
  }
}
