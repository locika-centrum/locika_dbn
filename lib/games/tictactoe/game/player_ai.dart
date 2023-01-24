import 'dart:math';
import 'package:logging/logging.dart';

import './game_move.dart';
import './game_board.dart';

Logger _log = Logger('tictactoe AIPlayer');

class PlayerAI {
  final int symbol;

  PlayerAI(this.symbol);

  int _myValue(int value) => (symbol == 1 ? 1 : -1) * value;

  GameMove? move(GameBoard board) {
    final random = Random();
    GameMove? result;
    List<GameMove> bestMoves = [];
    int bestMoveValue = -infinity;
    int moveValue;

    List<GameMove> possibleMoves = _possibleMoves(board);

    for (GameMove move in possibleMoves) {
      moveValue = _minMax(board, move, board.size < 2 ? 4 : 3);
      move.value = moveValue;

      // Evaluate the move value
      if (_myValue(moveValue) > bestMoveValue) {
        bestMoves.clear();
        bestMoveValue = _myValue(moveValue);
        bestMoves.add(move);
      } else if (_myValue(move.value) == bestMoveValue) {
        bestMoves.add(move);
      }
    }
    _log.finest('BEST MOVES: {count: ${bestMoves.length}, value: ${bestMoves[0].value}}');
    result = bestMoves[random.nextInt(bestMoves.length)];

    return result;
  }

  int _minMax(GameBoard board, GameMove move, int depth,
      [int alpha = -infinity,
      int beta = infinity,
      bool maximizingPlayer = false]) {
    int bestMoveValueAI;
    int bestMoveValue;
    int moveValue;

    // Copy board
    GameBoard boardCopy = GameBoard.from(board.size, board);
    // Record move
    move = boardCopy.recordMove(move);
    bestMoveValue = move.value;

    // Check limit cases
    if (depth > 0 && move.value.abs() < winValue && boardCopy.availableMoves > 0) {
      if (maximizingPlayer) {
        bestMoveValueAI = -infinity;

        for (GameMove nextMove in _possibleMoves(boardCopy)) {
          moveValue = _minMax(boardCopy, nextMove, depth - 1, alpha, beta, false);
          if (bestMoveValueAI < _myValue(moveValue)) {
            bestMoveValue = moveValue;
            bestMoveValueAI = _myValue(moveValue);
          }

          alpha = max(alpha, _myValue(moveValue));
          if (beta <= alpha) break;
        }
        // _log.finest('maximizingPlayer - ${board.symbol == symbol ? 'AI' : 'Human'} ... best move: $bestMoveValue (AI move value: $bestMoveValueAI)');

      } else {
        bestMoveValueAI = infinity;

        for (GameMove nextMove in _possibleMoves(boardCopy)) {
          moveValue = _minMax(boardCopy, nextMove, depth - 1, alpha, beta, true);
          if (_myValue(moveValue) < bestMoveValueAI) {
            bestMoveValue = moveValue;
            bestMoveValueAI = _myValue(moveValue);
          }

          beta = min(beta, _myValue(moveValue));
          if (beta <= alpha) break;
        }
        // _log.finest('minimizingPlayer - ${board.symbol == symbol ? 'AI' : 'Human'} ... best move: $bestMoveValue (AI move value: $bestMoveValueAI)');
      }
    }

    return bestMoveValue;
  }

  List<GameMove> _possibleMoves(GameBoard board) {
    List<GameMove> result = [];

    for (int row = 0; row < board.rows; row++) {
      for (int col = 0; col < board.cols; col++) {
        if (board.board[row][col] == null) {
          result.add(GameMove(
              row: row, col: col, symbol: board.symbol, humanPlayer: false));
        }
      }
    }

    return result;
  }
}
