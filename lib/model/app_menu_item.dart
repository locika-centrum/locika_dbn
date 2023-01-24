import 'package:flutter/material.dart';

class AppMenuItem<T> {
  final String title;
  final T icon;
  final bool blend;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget? page;

  const AppMenuItem({
    this.title = '',
    required this.icon,
    bool? isIconBlend,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.page
  })  : assert(icon is IconData || icon is Widget,
  'AppMenuItem only support IconData and Widget'),
        blend = isIconBlend ?? (icon is IconData);
}