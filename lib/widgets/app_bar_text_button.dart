import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

Logger _log = Logger('app_bar_text_button.dart');

class AppBarTextButton extends StatelessWidget {
  final String title;
  final String route;

  const AppBarTextButton(this.title, this.route, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go(route);
      },
      child: Text(
        title,
        style: const TextStyle(
            fontFamily: '',
            fontWeight: FontWeight.normal,
            fontSize: 15.0
        ),
      ),
    );
  }
}
