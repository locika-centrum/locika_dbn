import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HintItem extends StatelessWidget {
  final String hintRoute;
  final String hintText;
  final IconData hintIcon;

  const HintItem({
    required this.hintText,
    required this.hintRoute,
    this.hintIcon = Icons.lightbulb_outline,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: InkWell(
        onTap: () => context.go(hintRoute),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              hintIcon,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Text(
                '$hintText',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
