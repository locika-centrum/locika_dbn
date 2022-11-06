import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

import 'screens/main_screen.dart';
import 'screens/chat_splash_screen.dart';
import 'screens/chat_intro_screen.dart';
import 'utils/app_theme.dart';

Logger _log = Logger('main.dart');

Future<void> main() async {
  await initLogger();

  runApp(const MyApp());
}

Future<void> initLogger() async {
  Logger.root.level = Level.ALL;

  Logger.root.onRecord.listen((record) {
    print(
        '[${record.level.name}] ${record.time} [${record.loggerName}]: ${record.message}');
  });
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
        path: '/chat_splash',
        pageBuilder: (_, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ChatSplashScreen(),
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          );
        },
      ),
      GoRoute(
        path: '/chat_intro',
        pageBuilder: (_, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ChatIntroScreen(),
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          );
        },
      )
    ],
  );

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DBN',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}
