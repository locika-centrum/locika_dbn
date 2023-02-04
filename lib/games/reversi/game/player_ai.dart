import 'dart:math';
import 'package:logging/logging.dart';

import './game_move.dart';
import './game_board.dart';

Logger _log = Logger('reversi AIPlayer');

class PlayerAI {
  final int symbol;

  PlayerAI(this.symbol);

  GameMove? move(GameBoard board) {
    final random = Random();
    List<GameMove> bestMoves;

    bestMoves = _possibleMoves(board);

    return bestMoves.isEmpty ? null : bestMoves[random.nextInt(bestMoves.length)];
  }

  List<GameMove> _possibleMoves(GameBoard board) {
    List<GameMove> result = [];

    for (int row = 0; row < board.rows; row++) {
      for (int col = 0; col < board.cols; col++) {
        if (board.validPositions[row][col]) {
          result.add(GameMove(
            row: row,
            col: col,
            symbol: board.symbol,
            humanPlayer: false,
          ));
        }
      }
    }

    return result;
  }
}
