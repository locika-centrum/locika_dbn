import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_theme.dart';
import './app_bar_chat.dart';
import '../chat/widgets/redirect_button.dart';

class ActionButtonData {
  String actionString;
  String actionRoute;
  Color actionColor;
  Color actionBackgroundColor;
  Function? callback;

  ActionButtonData({
    required this.actionString,
    this.actionRoute = '/',
    this.callback,
    this.actionColor = Colors.white,
    this.actionBackgroundColor = Colors.black,
  });
}

class ScrollingScaffold extends StatefulWidget {
  final String? title;
  final String? closeRoute;
  final Widget? body;

  final List<ActionButtonData> actionButtonData;

  const ScrollingScaffold({
    this.title,
    this.body,
    this.closeRoute,
    this.actionButtonData = const [],
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.title != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          widget.title ?? '',
                          style: Theme.of(context).textTheme.displayLarge,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    widget.body ?? Container(),
                  ],
                ),
              ),
            ),
            if (widget.actionButtonData.isNotEmpty)
              ...List<Widget>.generate(
                  widget.actionButtonData.length,
                  (int index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4.0,
                        ),
                        child: RedirectButton(
                          label: widget.actionButtonData[index].actionString,
                          route: widget.actionButtonData[index].actionRoute,
                          callback: widget.actionButtonData[index].callback,
                          buttonColor:
                              widget.actionButtonData[index].actionColor,
                          backgroundColor: widget
                              .actionButtonData[index].actionBackgroundColor,
                        ),
                      ),
                  growable: false),
            SafeArea(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
