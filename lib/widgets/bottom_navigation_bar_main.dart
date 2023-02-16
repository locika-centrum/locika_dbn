import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:logging/logging.dart';

import '../model/app_menu_item.dart';

Logger _log = Logger('bottom_navigation_bar_main.dart');

class BottomNavigationBarMain extends StatefulWidget {
  final List<AppMenuItem>? menuItems;
  final Function menuItemsCallback;

  const BottomNavigationBarMain(this.menuItems, this.menuItemsCallback, {Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarMain> createState() => _BottomNavigationBarMainState();
}

class _BottomNavigationBarMainState extends State<BottomNavigationBarMain> {
  late int _currentIndex = 0;

  @override
  void initState() {
    _currentIndex = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<TabItem> items = [];

    if (widget.menuItems != null) {
      for (AppMenuItem item in widget.menuItems!) {
        items.add(TabItem(
          icon: item.icon,
          isIconBlend: true,
          title: item.title,
        ));
      }
    }

    return ConvexAppBar(
      style: TabStyle.react,
      top: -16.0,
      curveSize: 64.0,
      backgroundColor: const Color(0xff000000),
      items: items,
      initialActiveIndex: _currentIndex,
      onTap: (int index) {
        if (index != _currentIndex) {
          setState(() {
            _currentIndex = index;
          });
          widget.menuItemsCallback(index);
        }
      },
    );
  }
}
