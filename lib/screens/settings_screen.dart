import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

import '../settings/model/settings_data.dart';

import '../games/tictactoe/model/tictactoe_game_score.dart';
import '../games/sliding/model/sliding_game_score.dart';
import '../games/reversi/model/reversi_game_score.dart';

Logger _log = Logger('settings_screen.dart');

class SettingsScreen extends StatefulWidget {
  final String title;
  final Color backgroundColor;

  const SettingsScreen({
    required this.title,
    this.backgroundColor = const Color(0xffd6e8f4),
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  final Uri _urlGDPR = Uri.parse('https://detstvibeznasili.cz/gdpr');
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      _log.severe('Couldn\'t check connectivity status', e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
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
                title: const Text('Kameny: začíná hráč'),
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
              SettingsTile(
                leading: const Icon(Icons.network_check),
                title: const Text('Data'),
                value: Text(_connectionStatus[0].name),
              ),
              SettingsTile(
                leading: const Icon(Icons.help),
                title: const Text(
                    'Podržením loga DBN se přepneš do chatovacího režimu, ve kterém je možné se online spojit s dětským poradcem.'),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.assured_workload_rounded),
                title: const Text('GDPR'),
                onPressed: (context) {
                  _launchUrl();
                },
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

  Future<void> _launchUrl() async {
    if (!await launchUrl(_urlGDPR)) {
      throw Exception('Could not launch $_urlGDPR');
    }
  }
}
