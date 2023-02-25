import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuActionPanel extends StatelessWidget {
  final String title;
  final String text;
  final Widget? actionButton;
  final String? hintText;
  final String? hintRoute;
  final Color backgroundColor;

  const MenuActionPanel({
    required this.title,
    required this.text,
    this.backgroundColor = const Color(0xffe9e9eb),
    this.actionButton,
    this.hintText,
    this.hintRoute,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            Text(
              '\n$text',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            if (hintText != null && hintRoute != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: InkWell(
                  onTap: () => context.go(hintRoute!),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                      ),
                      Text(
                        '  ${hintText!}',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            if (actionButton != null)
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: actionButton!,
              ),
          ],
        ),
      ),
    );
  }
}
