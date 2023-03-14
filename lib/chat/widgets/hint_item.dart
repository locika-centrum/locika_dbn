import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HintItem extends StatelessWidget {
  final String hintText;
  final IconData hintIcon;
  final String? hintRoute;
  final Function? hintCallback;

  const HintItem({
    required this.hintText,
    this.hintIcon = Icons.lightbulb_outline,
    this.hintRoute,
    this.hintCallback,
    Key? key,
  })  : assert(
            (hintRoute != null && hintCallback == null) ||
                (hintRoute == null && hintCallback != null),
            'You cannot use both hintRoute and hintCallback'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: InkWell(
        onTap: () {
          if (hintRoute != null) {
            context.go(hintRoute!);
          } else {
            hintCallback!();
          }
        },
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
                hintText,
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
