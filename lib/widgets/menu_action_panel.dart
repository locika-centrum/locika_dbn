import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuActionPanel extends StatelessWidget {
  final String title;
  final String text;
  final Widget? actionButton;
  final String? hintText;
  final String? hintRoute;

  const MenuActionPanel({
    required this.title,
    required this.text,
    this.actionButton,
    this.hintText,
    this.hintRoute,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
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
                        color: Colors.blue,
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
