import 'package:flutter/material.dart';

import './app_bar_chat.dart';

class InfoPageScaffold extends StatelessWidget {
  final String title;
  final String route;
  final Widget body;
  final Widget? bottomButton;

  const InfoPageScaffold({
    this.route = '',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            body,
            if (bottomButton != null)
              const Spacer(),
            if (bottomButton != null)
              SafeArea(child: bottomButton!),
          ],
        ),
      ),
    );
  }
}
