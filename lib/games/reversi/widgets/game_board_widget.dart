import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import '../../common/models/game_score_base.dart';
import '../game/game_board.dart';
import '../game/game_move.dart';
import '../game/player_ai.dart';

import '../../../settings/model/settings_data.dart';

Logger _log = Logger('Reversi game_board_widget.dart');

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
  late PlayerAI playerAI;

  @override
  void didChangeDependencies() {
    if (Provider.of<GameScoreBase>(context).lastMove == null) {
      _log.finest('*** NEW GAME ***');
      gameBoard = GameBoard(size: widget.gameSize);
      playerAI =
          PlayerAI(context.read<SettingsData>().reversiStartsHuman ? 0 : 1);

      if (gameBoard.symbol == playerAI.symbol) {
        isLocked = true;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _log.finest('RUNNING FIRST COMPUTER MOVE');
          _computerMove();
        });
      } else {
        isLocked = false;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: gameBoard.rows * gameBoard.cols,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gameBoard.cols,
        ),
        itemBuilder: _buildBoardItems,
      ),
    );
  }

  Widget _buildBoardItems(BuildContext context, int index) {
    int row = (index / gameBoard.cols).floor();
    int col = (index % gameBoard.cols);

    return Padding(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: GestureDetector(
          onTap: () => _gridItemTapped(row, col),
          child: Container(
              color: gameBoard.validPositions[row][col]
                  ? Colors.white.withOpacity(0.75)
                  : Colors.white.withOpacity(0.5),
              child: _buildBoardItem(row, col)),
        ),
      ),
    );
  }

  Widget _buildBoardItem(int row, int col) {
    return Center(
      child: LayoutBuilder(builder: (context, constraint) {
        if (gameBoard.board[row][col] == null) return Container();

        return gameBoard.board[row][col] == 0
            ? Image.asset(
                'assets/images/reversi_white.png',
                height: 0.8 * constraint.biggest.height,
              )
            : Image.asset(
                'assets/images/reversi_black.png',
                height: 0.8 * constraint.biggest.height,
              );
      }),
    );
  }

  void _gridItemTapped(int row, int col) {
    if (!isLocked && gameBoard.validPositions[row][col]) {
      isLocked = true;

      GameMove move = GameMove(
        row: row,
        col: col,
        symbol: gameBoard.symbol,
        humanPlayer: true,
        blackScore: 0,
        whiteScore: 0,
      );

      if (!_isEndMove(move)) {
        Future.delayed(const Duration(milliseconds: 50), () {
          _computerMove();
        });
      }
    }
  }

  bool _computerMove() {
    isLocked = true;

    return _isEndMove(playerAI.move(gameBoard)!);
  }

  // Returns true if there the last move was not winning or draw
  bool _isEndMove(GameMove move) {
    bool result = false;

    move = gameBoard.recordMove(move);


    context.read<GameScoreBase>().move(move);

    if (move.winning) {
      result = true;
    } else if (gameBoard.availableMoves == 0) {
      context.read<GameScoreBase>().gameOver();
      result = true;
    } else {
      isLocked = false;
    }

    setState(() {});

    return result;
  }
}
