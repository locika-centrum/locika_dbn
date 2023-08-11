import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import '../../common/models/game_score_base.dart';
import '../game/game_board.dart';
import '../game/game_move.dart';
import '../game/player_ai.dart';

import '../../../settings/model/settings_data.dart';

Logger _log = Logger('Reversi game_board_widget.dart');

enum MoveResult { win, draw, loss, pass }

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
  bool pass = false;

  @override
  void didChangeDependencies() {
    _log.finest('didChangeDependencies');
    if (Provider.of<GameScoreBase>(context).lastMove == null && !pass) {
      _log.finest('*** NEW GAME ***');
      gameBoard = GameBoard(size: widget.gameSize);
      playerAI = PlayerAI(
        context.read<SettingsData>().reversiStartsHuman ? 0 : 1,
        complexity: context.read<SettingsData>().gameComplexity,
      );

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

  void _skipMove() {
    _log.finest(
        '*** PASS CONFIRMED ${gameBoard.symbol == playerAI.symbol ? 'Computer' : 'Human'}');
    gameBoard.skipMove();
    context.read<GameScoreBase>().setAction(null);

    _log.finest(
        '*** NEXT PLAYER IS ${gameBoard.symbol == playerAI.symbol ? 'Computer' : 'Human'}');
    _log.finest('VALID MOVES: ${gameBoard.validMoves}');

    // Computer if it was the Human pass
    if (gameBoard.symbol == playerAI.symbol) {
      Future.delayed(const Duration(milliseconds: 50), () {
        _computerMove();
      });
    } else if (gameBoard.validMoves == 0) {
      // Two skips - game over
      _isEndMove(null);
    }

    isLocked = false;
    setState(() {});
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

  void _computerMove() {
    _log.finest('Computer moves');
    isLocked = true;

    GameMove? move = playerAI.move(gameBoard);
    if (!_isEndMove(move)) {
      if (move != null) {
        if (gameBoard.validMoves == 0) {
          // Human cannot play - forced pass
          _isEndMove(null);
          /*
          if (!_isEndMove(null)) {
            Future.delayed(const Duration(milliseconds: 50), () {
              _computerMove();
            });
          }
           */
        }
      }
    }
  }

  // Return true, if game ends
  bool _isEndMove(GameMove? move) {
    bool result = false;
    _log.finest('CHECK MOVE: $move (${gameBoard.symbol} moves)');

    // Pass move
    if (move == null) {
      _log.finest(
          '${gameBoard.symbol == playerAI.symbol ? 'COMPUTER' : 'HUMAN'} will be forded to pass');
      if (pass) {
        _log.finest('Game over: 2x pass');
        context.read<GameScoreBase>().gameOver();
        pass = false;
        result = true;
      } else {
        _log.finest('Need to pass - no moves found');
        pass = true;
        context.read<GameScoreBase>().setAction(_skipMove, 'Vynechat');
      }
    } else {
      // Record move
      pass = false;
      move = gameBoard.recordMove(move);
      context.read<GameScoreBase>().move(move);

      // Final move
      if (move.winning || gameBoard.availableMoves == 0) {
        context.read<GameScoreBase>().gameOver();
        result = true;
      } else {
        isLocked = false;
      }
    }

    setState(() {});

    _log.finest(
        'End Move: $result - {humanPlayer: ${gameBoard.symbol == playerAI.symbol}, pass: $pass}');
    return result;
  }
}
