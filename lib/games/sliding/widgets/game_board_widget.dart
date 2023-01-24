import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import '../../common/models/game_score_base.dart';
import '../game/game_board.dart';
import '../game/game_move.dart';

import '../../../settings/model/settings_data.dart';
import '../../common/models/game_move_base.dart';
import '../model/sliding_game_score.dart';

Logger _log = Logger('Sliding game_board_widget.dart');

class GameBoardWidget extends StatefulWidget {
  final int gameSize;

  const GameBoardWidget({
    this.gameSize = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<GameBoardWidget> createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget> {
  late GameBoard gameBoard;
  late bool isLocked;

  @override
  void didChangeDependencies() {
    _log.finest('didChangeDependencies');

    if (Provider.of<GameScoreBase>(context).lastMove == null) {
      gameBoard = GameBoard(settingsSize: widget.gameSize);
      isLocked = gameBoard.evaluateBoard();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: gameBoard.size * gameBoard.size,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gameBoard.size,
        ),
        itemBuilder: _buildBoardItems,
      ),
    );
  }

  Widget _buildBoardItems(BuildContext context, int index) {
    int row = (index / gameBoard.size).floor();
    int col = (index % gameBoard.size);

    return Padding(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: GestureDetector(
          onTap: () => _gridItemTapped(row, col),
          child: Container(
              color: gameBoard.board[row][col] != null
                  ? Colors.white
                  : Colors.white.withOpacity(0.75),
              child: _buildBoardItem(row, col)),
        ),
      ),
    );
  }

  Widget _buildBoardItem(int row, int col) {
    return Center(
      child: LayoutBuilder(builder: (context, constraint) {
        if (gameBoard.board[row][col] == null) return Container();

        return Text(
          gameBoard.board[row][col].toString(),
          style: TextStyle(fontSize: constraint.maxHeight / 2),
        );
      }),
    );
  }

  void _gridItemTapped(int row, int col) {
    if (!isLocked) {
      GameMove? move = gameBoard.recordCoordinates(row, col);
      _log.finest(
          'Tapped: ($row, $col) - ${move == null ? 'in' : ''}valid move');

      if (move != null) {
        isLocked = gameBoard.evaluateBoard();
        move.winning = isLocked;
        context.read<SlidingGameScore>().move(move);

        setState(() {});
      }
    }
  }
}
