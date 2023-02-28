import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RedirectButton extends StatelessWidget {
  final String label;
  final String route;
  final Color buttonColor;
  final Color backgroundColor;

  const RedirectButton({
    required this.label,
    this.route = '/',
    this.buttonColor = Colors.white,
    this.backgroundColor = Colors.black,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => context.go(route),
      style: OutlinedButton.styleFrom(
        foregroundColor: buttonColor,
        backgroundColor: backgroundColor,
        minimumSize: const Size.fromHeight(48.0),
        shape: const StadiumBorder(),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: buttonColor,
            ),
      ),
    );
  }
}
