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
    List<GameMove> bestMoves = [];
    int bestMoveValue = -infinity;

    for (GameMove possibleMove in _possibleMoves(board)) {
      int moveValue = _minMax(board, possibleMove, 4);
      if (moveValue > bestMoveValue) {
        bestMoveValue = moveValue;
        bestMoves.clear();
      }
      if (moveValue == bestMoveValue) {
        bestMoves.add(possibleMove);
      }
    }

    return bestMoves.isEmpty ? null : bestMoves[random.nextInt(bestMoves.length)];
  }

  int _minMax(GameBoard board, GameMove move, int depth,
      [int alpha = -infinity,
        int beta = infinity,
        bool maximizingPlayer = false]) {
    GameBoard newBoard = GameBoard.from(board.size, board);
    int bestMoveValue = (symbol == 1 ? 1 : -1) * newBoard.recordMove(move).value;

    if (depth > 0) {
      List<GameMove> possibleMoves = _possibleMoves(newBoard);
      if (possibleMoves.isNotEmpty) {
        if (maximizingPlayer) {
          bestMoveValue = -infinity;
          for (GameMove nextMove in possibleMoves) {
            int nextMoveValue = _minMax(newBoard, nextMove, depth - 1, alpha, beta, !maximizingPlayer);
            if (bestMoveValue < nextMoveValue) {
              bestMoveValue = nextMoveValue;
            }

            alpha = max(alpha, nextMoveValue);
            if (beta <= alpha) break;
          }
        } else {
          bestMoveValue = infinity;
          for (GameMove nextMove in possibleMoves) {
            int nextMoveValue = _minMax(newBoard, nextMove, depth - 1, alpha, beta, !maximizingPlayer);
            if (nextMoveValue < bestMoveValue) {
              bestMoveValue = nextMoveValue;
            }

            beta = min(beta, nextMoveValue);
            if (beta <= alpha) break;
          }
        }
      }
    }

    return bestMoveValue;
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
