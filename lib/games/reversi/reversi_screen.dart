import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './widgets/game_board_widget.dart';
import '../common/widgets/action_widget.dart';
import '../common/widgets/record_widget.dart';
import '../common/widgets/score_widget.dart';

import '../../settings/model/settings_data.dart';

import '../common/models/game_score_base.dart';
import './model/reversi_game_score.dart';

class ReversiScreen extends StatelessWidget {
  final String title;
  final Color backgroundColor;

  const ReversiScreen({
    required this.title,
    this.backgroundColor = const Color(0xffd6e8f4),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureProvider<ReversiGameScore>(
        create: (BuildContext context) async {
          return ReversiGameScore.loadData(context.read<SettingsData>().gameSize);
        },
        initialData: ReversiGameScore(),
        builder: (context, child) {
          return ChangeNotifierProvider<GameScoreBase>.value(
            value: Provider.of<ReversiGameScore>(context),
            child: child,
          );
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = min(constraints.maxWidth, constraints.maxHeight);
                  return Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: size,
                      width: size,
                      child: GameBoardWidget(gameSize: context.read<SettingsData>().gameSize),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  RecordWidget(
                    title: 'Celkem',
                  ),
                  ScoreWidget(
                    title: 'Stav',
                  ),
                  ActionWidget(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
