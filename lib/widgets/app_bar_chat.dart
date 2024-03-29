import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../widgets/app_bar_text_button.dart';

Logger _log = Logger('app_bar_main.dart');

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String route;
  final bool showAboutLink;

  const ChatAppBar({
    this.route = '',
    this.showAboutLink = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 62.0 + 16.0,
      leading: route.isNotEmpty ? AppBarTextButton('Zavřít', route) : null,
      leadingWidth: 72.0,
      actions: showAboutLink
          ? [
              const AppBarTextButton('O chatu', '/about_chat'),
            ]
          : null,
      title: Image.asset(
        'assets/images/dbn_logo.png',
        height: 30.0,
      ),
      automaticallyImplyLeading: false,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52.0);
}
