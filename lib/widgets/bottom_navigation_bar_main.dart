import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:logging/logging.dart';

Logger _log = Logger('bottom_navigation_bar_main.dart');

class MainBottomNavigationBar extends StatefulWidget {
  final Function onMenuChange;
  final Color? backgroundColor;

  const MainBottomNavigationBar(this.onMenuChange, {Key? key, this.backgroundColor}) : super(key: key);

  @override
  State<MainBottomNavigationBar> createState() => _MainBottomNavigationBarState();
}

class _MainBottomNavigationBarState extends State<MainBottomNavigationBar> {
  late int _currentIndex = 0;

  @override
  void initState() {
    _currentIndex = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      style: TabStyle.react,
      backgroundColor: widget.backgroundColor,
      items: [
        TabItem(
          icon: Image.asset('assets/images/game_icon_01.png'),
          isIconBlend: true,
          title: 'Piškvorky',
        ),
        TabItem(
          icon: Image.asset('assets/images/game_icon_02.png'),
          isIconBlend: true,
          title: 'Puzzle',
        ),
        TabItem(
          icon: Image.asset('assets/images/game_icon_03.png'),
          isIconBlend: true,
          title: 'Reversi',
        ),
        const TabItem(
          icon: Icons.settings,
          title: 'Nastavení',
        ),
      ],
      initialActiveIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
        widget.onMenuChange(index);
      },
    );
  }
}
