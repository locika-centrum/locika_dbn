import 'package:flutter/material.dart';

class ParagraphText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;

  const ParagraphText(
    this.text, {
    this.fontWeight = FontWeight.normal,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .displaySmall
          ?.copyWith(fontWeight: fontWeight),
    );
  }
}
