import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'screens/main_screen.dart';
import 'chat/screens/chat_intro_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/settings_picker_screen.dart';
import 'screens/settings_text_screen.dart';
import 'screens/work_in_progress_screen.dart';
import 'chat/screens/chat_screen.dart';
import 'chat/screens/about_chat_screen.dart';
import 'chat/screens/chat_login_screen.dart';
import 'chat/screens/chat_sign_up_screen.dart';
import 'chat/screens/chat_reset_password_screen.dart';
import 'chat/models/chat_response.dart';
import 'chat/screens/about_call_police_screen.dart';
import 'chat/screens/how_chat_works.dart';
import 'chat/screens/chat_rules_screen.dart';
import 'chat/screens/most_interesting_facts_screen.dart';
import 'chat/screens/email_screen.dart';
import 'chat/screens/about_reset_password_screen.dart';
import 'chat/screens/about_navigation_screen.dart';

import 'chat/services/neziskovky_parser.dart';

import 'utils/app_theme.dart';
import 'settings/model/settings_data.dart';
import 'chat/models/session_data.dart';

import 'games/tictactoe/model/tictactoe_game_score.dart';
import 'games/sliding/model/sliding_game_score.dart';
import 'games/reversi/model/reversi_game_score.dart';

Logger _log = Logger('main.dart');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  await initLogger();

  // Initialize hive database
  await initHive();

  runApp(
    MultiProvider(
      providers: [
        FutureProvider<SettingsData>(
          create: (BuildContext context) => loadSettingsData(),
          initialData: SettingsData(),
          builder: (context, child) {
            return ChangeNotifierProvider<SettingsData>.value(
              value: Provider.of<SettingsData>(context),
              child: child,
            );
          },
        ),
        FutureProvider<SessionData>(
          create: (BuildContext context) => loadSessionData(),
          initialData: SessionData(),
          builder: (context, child) {
            return ChangeNotifierProvider<SessionData>.value(
              value: Provider.of<SessionData>(context),
              child: child,
            );
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> initLogger() async {
  Logger.root.level = Level.ALL;

  Logger.root.onRecord.listen((record) {
    print(
        '[${record.level.name}] ${record.time} [${record.loggerName}]: ${record.message}');
  });
}

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(SettingsDataAdapter());
  Hive.registerAdapter(SessionDataAdapter());

  Hive.registerAdapter(TicTacToeGameScoreAdapter());
  Hive.registerAdapter(SlidingGameScoreAdapter());
  Hive.registerAdapter(ReversiGameScoreAdapter());
}

Future<SettingsData> loadSettingsData() async {
  Box box = await Hive.openBox<SettingsData>(SettingsData.hiveBoxName);
  SettingsData? result = box.get(SettingsData.settingsKey);

  if (result == null) {
    result = SettingsData();
    box.put(SettingsData.settingsKey, result);
  }
  result.isReady = true;
  _log.finest('Initial settings: $result');

  return result;
}

Future<SessionData> loadSessionData() async {
  Box box = await Hive.openBox<SessionData>(SessionData.hiveBoxName);
  SessionData? result = box.get(SessionData.dataKey);

  if (result == null) {
    result = SessionData();
    box.put(SessionData.dataKey, result);
  }
  result.isReady = true;
  _log.finest('Sessiom: $result');

  return result;
}

class MyApp extends StatelessWidget {
  static final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(
          title: 'Nastavení',
        ),
      ),
      GoRoute(
        path: '/settings_picker',
        builder: (context, state) {
          SettingsPickerData optionsData = state.extra as SettingsPickerData;

          return SettingsPickerScreen(
            title: optionsData.title,
            options: optionsData.options,
            selectedOption: optionsData.selectedOption,
            onChange: optionsData.onChange,
          );
        },
      ),
      GoRoute(
        path: '/settings_text',
        builder: (context, state) {
          SettingsTextData textData = state.extra as SettingsTextData;

          return SettingsTextScreen(
            title: textData.title,
            text: textData.text,
            onChange: textData.onChange,
          );
        },
      ),
      GoRoute(
        path: '/chat_intro',
        builder: (context, state) => const ChatIntroScreen(),
      ),
      GoRoute(
          path: '/login',
          redirect: (context, state) async {
            ChatResponse response = await checkAuthorized(
                cookie: context.read<SessionData>().cookie);

            if (response.statusCode == HttpStatus.ok) {
              _log.fine('Cookie is valid, skipping login');
              return '/chat';
            }
            return null;
          },
          builder: (context, state) {
            return ChatLoginScreen(
              nickName: context.read<SettingsData>().nickName,
            );
          }),
      GoRoute(
        path: '/sign_up',
        builder: (context, state) => const ChatSignUpScreen(),
      ),
      GoRoute(
        path: '/reset_password',
        builder: (context, state) => ChatResetPassword(
          nickName: context.read<SettingsData>().nickName,
        ),
      ),
      GoRoute(
          path: '/chat',
          builder: (context, state) {
            Cookie cookie =
                (state.extra ?? context.read<SessionData>().cookie) as Cookie;
            _log.finest(
                'First login: ${context.read<SettingsData>().firstLogin}');
            // context.read<SettingsData>().firstLogin = false;

            return ChatScreen(
              cookie: cookie,
            );
          }),
      GoRoute(
        path: '/about_chat',
        builder: (context, state) => const AboutChatScreen(),
      ),
      GoRoute(
        path: '/about_navigation',
        builder: (context, state) => AboutNavigationScreen(
          returnRoute: state.extra as String,
        ),
      ),
      GoRoute(
        path: '/about_call_police',
        builder: (context, state) => const AboutCallPoliceScreen(),
      ),
      GoRoute(
        path: '/how_chat_works',
        builder: (context, state) => const HowChatWorks(),
      ),
      GoRoute(
        path: '/chat_rules',
        builder: (context, state) => const ChatRulesScreen(),
      ),
      GoRoute(
        path: '/most_interesting_facts',
        builder: (context, state) => const MostInterestingFactsScreen(),
      ),
      GoRoute(
        path: '/email',
        builder: (context, state) => const EmailScreen(),
      ),
      GoRoute(
        path: '/about_reset_password',
        builder: (context, state) => const AboutResetPasswordScreen(),
      ),
      GoRoute(
        path: '/work_in_progress',
        builder: (context, state) => const WorkInProgressScreen(),
      ),
    ],
  );

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DBN',
      theme: AppTheme.chatTheme,
      // darkTheme: AppTheme.chatTheme,
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      debugShowCheckedModeBanner: false,
    );
  }
}
