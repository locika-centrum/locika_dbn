import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../widgets/app_bar_main.dart';
import '../widgets/bottom_navigation_bar_main.dart';

Logger _log = Logger('main_screen.dart');

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Widget _page;
  late String _title;
  late Color _backgroundColor;
  late Color _navBackgroundColor;

  @override
  void initState() {
    _onMenuChange(0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(_title),
      body: Container(color: _backgroundColor),
      bottomNavigationBar: MainBottomNavigationBar(
        _onMenuChange,
        backgroundColor: _navBackgroundColor,
      ),
    );
  }

  void _onMenuChange(int index) {
    _log.finest('Change screen: $index');
    setState(() {
      switch (index) {
        case 1:
          _title = 'Puzzle';
          _backgroundColor = const Color(0xffb2e0d9);
          _navBackgroundColor = const Color(0xff000000);
          break;
        case 2:
          _title = 'Reversi';
          _backgroundColor = const Color(0xffffabb0);
          _navBackgroundColor = const Color(0xff000000);
          break;
        case 3:
          _title = 'Nastavení';
          _backgroundColor = Theme.of(context).canvasColor;
          break;
        case 4:
          _title = 'Tetris';
          break;
        default:
          _title = 'Piškvorky';
          _backgroundColor = const Color(0xffffddb8);
          _navBackgroundColor = const Color(0xff000000);
      }
    });
  }
}
