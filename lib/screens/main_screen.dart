import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../model/app_menu_item.dart';
import '../widgets/app_bar_main.dart';

import '../games/reversi/reversi_screen.dart';
import '../games/sliding/sliding_screen.dart';
import '../games/tictactoe/tictactoe_screen.dart';
import './settings_screen.dart';
import '../settings/model/settings_data.dart';

import '../widgets/bottom_navigation_bar_main.dart';

Logger _log = Logger('main_screen.dart');

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<AppMenuItem> menuItems = [];

  late Widget _page;
  int _index = 0;

  @override
  void initState() {
    super.initState();

    _page = const Center();
    menuItems.add(AppMenuItem(
      title: 'Piškvorky',
      icon: Image.asset('assets/images/game_icon_01.png'),
      page: const TicTacToeScreen(
        title: 'Piškvorky',
        backgroundColor: Color(0xffffbb1e),
      ),
    ));
    menuItems.add(AppMenuItem(
      title: 'Puzzle',
      icon: Image.asset('assets/images/game_icon_02.png'),
      page: const SlidingScreen(
        title: 'Puzzle',
        backgroundColor: Color(0xfffe485b),
      ),
    ));
    menuItems.add(AppMenuItem(
      title: 'Reversi',
      icon: Image.asset('assets/images/game_icon_03.png'),
      page: const ReversiScreen(
        title: 'Reversi',
        backgroundColor: Color(0xff5ac8b8),
      ),
    ));
    menuItems.add(const AppMenuItem(
        title: 'Nastavení',
        icon: Icon(Icons.settings),
        page: SettingsScreen(
          title: 'Nastavení',
          backgroundColor: Color(0xffd6e8f4),
        )));

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    _index = 0;
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _page = context.select<SettingsData, bool>((value) => value.isReady)
        ? menuItems[_index].page!
        : const Center();
    _log.finest('Is ready: ${context.read<SettingsData>().isReady}');

    return Scaffold(
      appBar: AppBar(
        title: const AppBarMain(),
        toolbarHeight: 50.0,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: _page,
      bottomNavigationBar: BottomNavigationBarMain(menuItems, _onMenuChange),
    );
  }

  void _onMenuChange(int index) {
    _log.finest('Page changed to $index -> ${menuItems[index].title}');

    setState(() {
      _index = index;
    });
  }
}
