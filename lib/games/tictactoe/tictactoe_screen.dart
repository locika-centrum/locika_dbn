import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import './widgets/game_board_widget.dart';
import '../common/widgets/action_widget.dart';
import '../common/widgets/record_widget.dart';
import '../common/widgets/score_widget.dart';

import '../../settings/model/settings_data.dart';

import '../common/models/game_score_base.dart';
import './model/tictactoe_game_score.dart';

Logger _log = Logger('tictactoe_screen.dart');

class TicTacToeScreen extends StatelessWidget {
  final String title;
  final Color backgroundColor;

  const TicTacToeScreen({
    required this.title,
    this.backgroundColor = const Color(0xffd6e8f4),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureProvider<TicTacToeGameScore>(
        create: (BuildContext context) async {
          return TicTacToeGameScore.loadData(context.read<SettingsData>().gameSize);
        },
        initialData: TicTacToeGameScore(),
        builder: (context, child) {
          return ChangeNotifierProvider<GameScoreBase>.value(
            value: Provider.of<TicTacToeGameScore>(context),
            child: child,
          );
        },
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: GameBoardWidget(gameSize: context.read<SettingsData>().gameSize),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    RecordWidget(title: 'Počet her',),
                    ScoreWidget(),
                    ActionWidget(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}