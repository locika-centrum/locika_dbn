import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'screens/main_screen.dart';
import 'screens/chat_splash_screen.dart';
import 'screens/chat_intro_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/settings_picker_screen.dart';
import 'screens/settings_text_screen.dart';
import 'screens/chat_menu_screen.dart';
import 'screens/work_in_progress_screen.dart';
import 'chat/chat_screen.dart';
import 'chat/about_chat_screen.dart';
import 'chat/chat_login_screen.dart';
import 'chat/chat_sign_up_screen.dart';

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

  // runApp(const MyApp());
  /*
  runApp(
    FutureProvider<SettingsData>(
      create: (BuildContext context) => loadSettingsData(),
      initialData: SettingsData(),
      builder: (context, child) {
        return ChangeNotifierProvider<SettingsData>.value(
          value: Provider.of<SettingsData>(context),
          child: child,
        );
      },
      child: const MyApp(),
    ),
  );
  */
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
  Logger.root.level = Level.FINE;

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
        path: '/chat_splash',
        //builder: (context, state) => const ChatSplashScreen(),
        pageBuilder: (context, state) {
          // return const ChatSplashScreen();
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ChatSplashScreen(),
            transitionDuration: const Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/chat_intro',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ChatIntroScreen(),
            transitionDuration: const Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/chat_menu',
        builder: (context, state) => const ChatMenuScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => ChatLoginScreen(
          nickName: context.read<SettingsData>().nickName,
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const ChatSignUpScreen(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/about_chat',
        builder: (context, state) => const AboutChatScreen(),
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
    );
  }
}
