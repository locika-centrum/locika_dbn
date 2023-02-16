import 'dart:math';

import './game_move.dart';
import 'package:logging/logging.dart';

Logger _log = Logger('game_board.dart');

const infinity = 999999;
const winValue = 200000;
const scoreValues = [
  [0, 1, 1751, winValue], // three in row
  [0, 1, 511, 5000, winValue], // four in row
  [0, 1, 73, 850, 7000, winValue], // five in row
];

class GameBoard {
  final int size;
  final List<Map<String, int>> _sizes = [
    {'size': 0, 'rows': 3, 'cols': 3, 'winning-len': 3},
    {'size': 1, 'rows': 5, 'cols': 5, 'winning-len': 4},
    {'size': 2, 'rows': 7, 'cols': 7, 'winning-len': 5},
    {'size': 3, 'rows': 11, 'cols': 11, 'winning-len': 5},
  ];

  late List<List<int?>> _board;
  late List<List<bool>> _surrounding;
  late int _rows, _cols, _winningLen;
  late int _symbol;
  late int _availableMoves;
  int _boardValue = 0;

  List<List<int?>> get board => _board;
  List<List<bool>> get surrounding => this._surrounding;
  int get rows => _rows;
  int get cols => _cols;
  int get symbol => _symbol;
  int get availableMoves => _availableMoves;
  bool isInside(int row, int col) =>
      (0 <= row && row < _rows && 0 <= col && col < _cols);

  GameBoard.from(this.size, GameBoard source) {
    _rows = source._rows;
    _cols = source._cols;
    _winningLen = source._winningLen;
    _symbol = source._symbol;

    _board = [
      for (var sublist in source._board) [...sublist]
    ];
    _surrounding = [
      for (var sublist in source._surrounding) [...sublist]
    ];
    _availableMoves = source._availableMoves;
    _boardValue = source._boardValue;
  }

  GameBoard({required this.size}) {
    _rows = _sizes[size]['rows']!;
    _cols = _sizes[size]['cols']!;
    _winningLen = _sizes[size]['winning-len']!;
    _symbol = 1; // cross always starts

    _board = List.generate(
      _rows,
      (index) => List.generate(
        _cols,
        (index) => null,
        growable: false,
      ),
      growable: false,
    );
    _surrounding = List.generate(
      _rows,
      (index) => List.generate(
        _cols,
        (index) => false,
        growable: false,
      ),
      growable: false,
    );
    _availableMoves = _rows * _cols;
  }

  GameMove recordMove(GameMove move) {
    assert(move.symbol == _symbol);
    assert(_board[move.row][move.col] == null);

    move = _evaluateMove(move);
    _availableMoves--;
    _board[move.row][move.col] = _symbol;
    _boardValue = move.value;
    _symbol = 1 - _symbol;

    if (_boardValue.abs() == winValue) {
      move.winning = true;
    }

    int diameter = (_winningLen / 2).floor();
    for (int i = -diameter; i <= diameter; i++) {
      for (int j = -diameter; j <= diameter; j++) {
        if (isInside(move.row + i, move.col + j) &&
            (i == 0 || j == 0 || i.abs() == j.abs())) {
          _surrounding[move.row + i][move.col + j] = true;
        }
      }
    }

    return move;
  }

  GameMove _evaluateMove(GameMove move) {
    int result = _boardValue;
    int value = 0;
    int valueDirection = 0;
    List<int> symbolCount = [0, 0];

    // horizontal check
    for (int col = max(0, move.col - _winningLen + 1);
        col <= min(move.col, _cols - _winningLen);
        col++) {
      symbolCount = [0, 0];
      for (int i = 0; i < _winningLen; i++) {
        symbolCount[_board[move.row][col + i] ?? 0] +=
            _board[move.row][col + i] == null ? 0 : 1;
      }
      valueDirection = _calculateScore(symbolCount[0], symbolCount[1]);
      if (valueDirection.abs() == winValue) {
        move.value = valueDirection;
        move.winDirection = Direction.horizontal;
        return move;
      }
      value += valueDirection;
    }

    // vertical check
    for (int row = max(0, move.row - _winningLen + 1);
        row <= min(move.row, _rows - _winningLen);
        row++) {
      symbolCount = [0, 0];
      for (int i = 0; i < _winningLen; i++) {
        symbolCount[_board[row + i][move.col] ?? 0] +=
            _board[row + i][move.col] == null ? 0 : 1;
      }
      valueDirection = _calculateScore(symbolCount[0], symbolCount[1]);
      if (valueDirection.abs() == winValue) {
        move.value = valueDirection;
        move.winDirection = Direction.vertical;
        return move;
      }
      value += valueDirection;
    }

    // diagonal left_up-right_down
    int leftTopDelta = min(
        (move.col - _winningLen + 1) >= 0 ? _winningLen - 1 : move.col,
        (move.row - _winningLen + 1) >= 0 ? _winningLen - 1 : move.row);
    int rightBottomDelta = min(
            (move.col + _winningLen - 1) < _cols
                ? _winningLen
                : _cols - move.col,
            (move.row + _winningLen - 1) < _rows
                ? _winningLen
                : _rows - move.row) -
        1;
    if (leftTopDelta + rightBottomDelta + 1 >= _winningLen) {
      for (int diag = -leftTopDelta;
          diag <= rightBottomDelta - _winningLen + 1;
          diag++) {
        symbolCount = [0, 0];
        for (int i = 0; i < _winningLen; i++) {
          symbolCount[_board[move.row + diag + i][move.col + diag + i] ?? 0] +=
              _board[move.row + diag + i][move.col + diag + i] == null ? 0 : 1;
        }
        valueDirection = _calculateScore(symbolCount[0], symbolCount[1]);
        if (valueDirection.abs() == winValue) {
          move.value = valueDirection;
          move.winDirection = Direction.diagonalLTRB;
          return move;
        }
        value += valueDirection;
      }
    }

    // diagonal right_up-left_down
    int rightTopDelta = min(
        (move.col + _winningLen - 1) < _cols
            ? _winningLen
            : _cols - move.col - 1,
        (move.row - _winningLen + 1) >= 0 ? _winningLen - 1 : move.row);
    int leftBottomDelta = min(
        (move.col - _winningLen + 1) >= 0 ? _winningLen - 1 : move.col,
        (move.row + _winningLen - 1) < _rows
            ? _winningLen
            : _rows - move.row - 1);
    if (rightTopDelta + leftBottomDelta + 1 >= _winningLen) {
      for (int diag = -rightTopDelta;
          diag <= leftBottomDelta - _winningLen + 1;
          diag++) {
        symbolCount = [0, 0];
        for (int i = 0; i < _winningLen; i++) {
          symbolCount[_board[move.row + diag + i][move.col - diag - i] ?? 0] +=
              _board[move.row + diag + i][move.col - diag - i] == null ? 0 : 1;
        }
        valueDirection = _calculateScore(symbolCount[0], symbolCount[1]);
        if (valueDirection.abs() == winValue) {
          move.value = valueDirection;
          move.winDirection = Direction.diagonalRTLB;
          return move;
        }
        value += valueDirection;
      }
    }

    move.value = result + value;
    return move;
  }

  int _calculateScore(int countO, int countX) {
    int value = 0;

    for (int i = 0; i <= 1; i++) {
      // The first loop calculates value before the move, the second after the move
      if (countO == 0 || countX == 0) {
        if (scoreValues[_winningLen - 3][countO] == winValue ||
            scoreValues[_winningLen - 3][countX] == winValue) {
          value = scoreValues[_winningLen - 3][countX] == winValue
              ? winValue
              : -winValue;
          break;
        }
        value -= (i == 0 ? -1 : 1) * scoreValues[_winningLen - 3][countO];
        value += (i == 0 ? -1 : 1) * scoreValues[_winningLen - 3][countX];
      }
      countO += _symbol == 0 ? 1 : 0;
      countX += _symbol == 1 ? 1 : 0;
    }

    return value;
  }

  @override
  String toString() {
    String result = '';

    for (int row = 0; row < _rows; row++) {
      result = '$result\n';
      for (int col = 0; col < _cols; col++) {
        result = '$result ${_board[row][col] ?? '-'} ';
      }
    }

    result = '$result   [$_boardValue]\n';
    return result;
  }
}
