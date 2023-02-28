import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_theme.dart';
import './app_bar_chat.dart';
import '../chat/widgets/redirect_button.dart';

class ScrollingScaffold extends StatefulWidget {
  final String? title;
  final String? closeRoute;
  final Widget? body;

  final String? actionRoute;
  final String actionString;
  final Color actionColor;
  final Color actionBackgroundColor;

  const ScrollingScaffold({
    this.title,
    this.body,
    this.closeRoute,
    this.actionRoute,
    this.actionString = '',
    this.actionColor = Colors.white,
    this.actionBackgroundColor = Colors.black,
    Key? key,
  }) : super(key: key);

  @override
  State<ScrollingScaffold> createState() => _ScrollingScaffoldState();
}

class _ScrollingScaffoldState extends State<ScrollingScaffold> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.chatTheme.copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Scaffold(
        appBar: ChatAppBar(
          route: widget.closeRoute ?? '',
        ),
        body: widget.body,
        persistentFooterButtons: widget.actionRoute == null
            ? null
            : [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: RedirectButton(
                    label: widget.actionString ?? '',
                    route: widget.actionRoute!,
                    buttonColor: widget.actionColor,
                    backgroundColor: widget.actionBackgroundColor,
                  ),
                )
              ],
      ),
    );
  }
}
