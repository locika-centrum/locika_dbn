import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../widgets/app_bar_text_button.dart';

Logger _log = Logger('app_bar_main.dart');

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const AppBarTextButton('Zavřít', ''),
      leadingWidth: 64.0,
      title: Image.asset(
        'assets/images/dbn_logo.png',
        height: 30.0,
      ),
      automaticallyImplyLeading: false,
      toolbarHeight: 52.0,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52.0);
}
