import 'package:flutter/material.dart';

enum BulletColor { blue, green, yellow, red }

class BulletText extends StatelessWidget {
  final BulletColor color;
  final String text;

  const BulletText({
    required this.text,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0,),
            child: Image.asset(
              'assets/images/bullet_${color.toString().split('.').last}.png',
              width: 8.0,
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Text(text,
                style: Theme.of(context).textTheme.displaySmall),
          ),
        ],
      ),
    );
  }
}
