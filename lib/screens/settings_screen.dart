import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:logging/logging.dart';

import '../settings/model/settings_data.dart';

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
                    (value) => value.gameSizes[value.gameSize])),
                onPressed: (context) {
                  GoRouter.of(context).push(
                    '/settings_picker',
                    extra: SettingsPickerData(
                      title: 'Velikost hry',
                      options: context.read<SettingsData>().gameSizes,
                      selectedOption: context.read<SettingsData>().gameSize,
                      onChange: (index) {
                        context.read<SettingsData>().gameSize = index;
                        _log.finest('New size: $index');
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
                    (value) => value.slidingPictures),
                leading: Image.asset(
                  'assets/images/game_icon_02.png',
                  color: Colors.grey,
                  height: 24,
                ),
                title: const Text('Puzzle: obrázky'),
                onToggle: (value) {
                  context.read<SettingsData>().slidingPictures = value;
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
                onPressed: (context) {
                  // TODO tictactoe

                  // TODO puzzle

                  // TODO reversi

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
        ],
      ),
    );
  }
}