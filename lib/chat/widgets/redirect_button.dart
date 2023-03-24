import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/session_data.dart';

class RedirectButton extends StatelessWidget {
  final String label;
  final String route;
  final Function? callback;
  final Color buttonColor;
  final Color backgroundColor;
  final IconData? labelIcon;

  const RedirectButton({
    required this.label,
    this.labelIcon,
    this.route = '/',
    this.callback,
    this.buttonColor = Colors.white,
    this.backgroundColor = Colors.black,
    Key? key,
  })  : assert(route == '/' || callback == null,
            'Both route and callback cannot be specified'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => callback == null
          ? context.go(
              route,
              extra: context.read<SessionData>().cookie,
            )
          : callback!(),
      style: OutlinedButton.styleFrom(
        foregroundColor: buttonColor,
        backgroundColor: backgroundColor,
        minimumSize: const Size.fromHeight(48.0),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (labelIcon != null) Icon(labelIcon),
          Text(
            label,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: buttonColor,
                ),
          ),
        ],
      ),
    );
  }
}
