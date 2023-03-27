import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:logging/logging.dart';

import '../settings/model/settings_data.dart';

import '../games/tictactoe/model/tictactoe_game_score.dart';
import '../games/sliding/model/sliding_game_score.dart';
import '../games/reversi/model/reversi_game_score.dart';

Logger _log = Logger('settings_screen.dart');

class SettingsScreen extends StatelessWidget {
  final String title;
  final Color backgroundColor;

  const SettingsScreen({
    required this.title,
    this.backgroundColor = const Color(0xffd6e8f4),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Hry'),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.view_comfy),
                title: const Text('Velikost hry'),
                value: Text(context.select<SettingsData, String>(
                    (value) => SettingsData.gameSizes[value.gameSize])),
                onPressed: (context) {
                  GoRouter.of(context).push(
                    '/settings_picker',
                    extra: SettingsPickerData(
                      title: 'Velikost hry',
                      options: SettingsData.gameSizes,
                      selectedOption: context.read<SettingsData>().gameSize,
                      onChange: (index) {
                        context.read<SettingsData>().gameSize = index;
                        _log.finest('New size: $index');
                      },
                    ),
                  );
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.psychology_alt),
                title: const Text('Složitost'),
                value: Text(context.select<SettingsData, String>((value) =>
                    SettingsData.gameComplexities[value.gameComplexity])),
                onPressed: (context) {
                  GoRouter.of(context).push(
                    '/settings_picker',
                    extra: SettingsPickerData(
                      title: 'Složitost hry',
                      options: SettingsData.gameComplexities,
                      selectedOption:
                          context.read<SettingsData>().gameComplexity,
                      onChange: (index) {
                        context.read<SettingsData>().gameComplexity = index;
                        _log.finest('New complexity: $index');
                      },
                    ),
                  );
                },
              ),
              SettingsTile.switchTile(
                initialValue: context.select<SettingsData, bool>(
                    (value) => value.tictactoeStartsHuman),
                leading: Image.asset(
                  'assets/images/game_icon_01.png',
                  color: Colors.grey,
                  height: 24,
                ),
                title: const Text('Piškvorky: začíná hráč'),
                onToggle: (value) {
                  context.read<SettingsData>().tictactoeStartsHuman = value;
                },
              ),
              SettingsTile.switchTile(
                initialValue: context.select<SettingsData, bool>(
                    (value) => value.reversiStartsHuman),
                leading: Image.asset(
                  'assets/images/game_icon_03.png',
                  color: Colors.grey,
                  height: 24,
                ),
                title: const Text('Reversi: začíná hráč'),
                onToggle: (value) {
                  context.read<SettingsData>().reversiStartsHuman = value;
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.redo),
                title: const Text('Vynulovat score'),
                onPressed: (context) async {
                  // tictactoe
                  Box box = await Hive.openBox(TicTacToeGameScore.hiveBoxName);
                  box.clear();

                  // slider
                  box = await Hive.openBox(SlidingGameScore.hiveBoxName);
                  box.clear();

                  // reversi
                  box = await Hive.openBox(ReversiGameScore.hiveBoxName);
                  box.clear();
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Chat'),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.person),
                title: const Text('Přezdívka'),
                value: Text(context
                    .select<SettingsData, String>((value) => value.nickName)),
                onPressed: (context) {
                  GoRouter.of(context).push(
                    '/settings_text',
                    extra: SettingsTextData(
                      title: 'Přezdívka',
                      text: context.read<SettingsData>().nickName,
                      onChange: (String name) {
                        context.read<SettingsData>().nickName = name;
                        _log.finest('New nick name: $name');
                      },
                    ),
                  );
                },
              ),
              SettingsTile.switchTile(
                initialValue: context
                    .select<SettingsData, bool>((value) => value.firstLogin),
                leading: const Icon(Icons.verified_user),
                title: const Text('První přihlášení'),
                onToggle: (value) {
                  context.read<SettingsData>().firstLogin = value;
                },
              )
            ],
          ),
          SettingsSection(
            title: const Text('O Aplikaci'),
            tiles: [
              SettingsTile(
                leading: const Icon(Icons.info),
                title: const Text('Verze'),
                value: FutureBuilder<String>(
                  future: _getVersion(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data ?? '');
                    } else {
                      return Text('does not have data');
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return '${packageInfo.version} - ${packageInfo.buildNumber}';
  }
}
