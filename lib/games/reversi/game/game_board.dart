import 'dart:math';

import './game_move.dart';
import 'package:logging/logging.dart';

Logger _log = Logger('game_board.dart');

const infinity = 9999999;

class GameBoard {
  final int size;
  final List<Map<String, int>> _sizes = [
    {'size': 0, 'rows': 6, 'cols': 6},
    {'size': 1, 'rows': 8, 'cols': 8},
    {'size': 2, 'rows': 10, 'cols': 10},
    {'size': 3, 'rows': 12, 'cols': 12},
  ];

  late List<List<int?>> _board;
  late List<List<bool>> _validPositions;
  late List<List<int>> _cellWeights;
  late int _rows, _cols;
  late int _symbol;
  late int _availableMoves;
  late int _validMoves;
  int _boardValue = 0;
  List<int> _symbolCount = [0, 0];

  List<List<int?>> get board => _board;
  List<List<bool>> get validPositions => _validPositions;
  int get rows => _rows;
  int get cols => _cols;
  int get symbol => _symbol;
  int get availableMoves => _availableMoves;
  int get validMoves => _validMoves;
  List<int> get symbolCount => _symbolCount;
  bool isInside(int row, int col) =>
      (0 <= row && row < _rows && 0 <= col && col < _cols);

  GameBoard.from(this.size, GameBoard source) {
    _rows = source._rows;
    _cols = source._cols;
    _symbol = source._symbol;

    _board = [
      for (var sublist in source._board) [...sublist]
    ];
    _validPositions = [
      for (var sublist in source._validPositions) [...sublist]
    ];
    _cellWeights = source._cellWeights;
    _symbolCount = [...source._symbolCount];
    _availableMoves = source._availableMoves;
    _validMoves = source._validMoves;
    _boardValue = source._boardValue;
  }

  GameBoard({required this.size}) {
    _rows = _sizes[size]['rows']!;
    _cols = _sizes[size]['cols']!;
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
    _validPositions = List.generate(
      _rows,
      (index) => List.generate(
        _cols,
        (index) => false,
        growable: false,
      ),
      growable: false,
    );
    _prepareCellWeights();

    // Initial position
    _board[_rows ~/ 2 - 1][_cols ~/ 2] = _board[_rows ~/ 2][_cols ~/ 2 - 1] = 0;
    _board[_rows ~/ 2 - 1][_cols ~/ 2 - 1] = _board[_rows ~/ 2][_cols ~/ 2] = 1;

    _symbolCount[0] = _symbolCount[1] = 2;
    _availableMoves = _rows * _cols - 4;

    // Recalculate valid positions
    _recalculateValidMoves();
  }

  GameMove recordMove(GameMove move) {
    assert(move.symbol == _symbol);
    assert(_board[move.row][move.col] == null);
    assert(validPositions[move.row][move.col]);

    for (GameMove take in evaluateAllTakes(move)) {
      _board[take.row][take.col] = _symbol;
      _symbolCount[_symbol]++;
      _symbolCount[1 - _symbol]--;
    }
    board[move.row][move.col] = _symbol;
    _symbolCount[_symbol]++;
    move = _evaluateMove(move);
    _symbol = 1 - _symbol;
    _availableMoves--;
    _recalculateValidMoves();

    _log.finest('Move recorded: $move');
    return move;
  }

  GameMove _evaluateMove(GameMove move) {
    move.blackScore = _symbolCount[1];
    move.whiteScore = _symbolCount[0];

    move.value = move.blackScore - move.whiteScore;

    int positionValue = 0;
    for (int row = 0; row < _rows; row++) {
      for (int col = 0; col < _cols; col++) {
        if (_board[row][col] == 1) positionValue += _cellWeights[row][col];
        if (_board[row][col] == 0) positionValue -= _cellWeights[row][col];
      }
    }
    move.value += positionValue;

    return move;
  }

  void _recalculateValidMoves() {
    _validMoves = 0;
    for (int row = 0; row < _rows; row++) {
      for (int col = 0; col < _cols; col++) {
        if (_board[row][col] != null) {
          _validPositions[row][col] = false;
        } else {
          List<GameMove> possibleTakes = evaluateAllTakes(GameMove(
            row: row,
            col: col,
            symbol: _symbol,
            humanPlayer: false,
          ));

          _validPositions[row][col] = possibleTakes.isNotEmpty;
          _validMoves += possibleTakes.isNotEmpty ? 1 : 0;
        }
      }
    }
  }

  void skipMove() {
    _symbol = 1 - _symbol;
    _recalculateValidMoves();
  }

  List<GameMove> evaluateAllTakes(GameMove move) {
    List<GameMove> result = [];

    // horizontal
    result.addAll(evaluateTake(move, 0, 1));
    result.addAll(evaluateTake(move, 0, -1));

    // vertical
    result.addAll(evaluateTake(move, 1, 0));
    result.addAll(evaluateTake(move, -1, 0));

    // diagonal left_top-right_bottom
    result.addAll(evaluateTake(move, 1, 1));
    result.addAll(evaluateTake(move, -1, -1));

    // diagonal right_top-left_bottom
    result.addAll(evaluateTake(move, 1, -1));
    result.addAll(evaluateTake(move, -1, 1));

    return result;
  }

  List<GameMove> evaluateTake(GameMove move, int rowStep, int colStep) {
    assert(-1 <= rowStep && rowStep <= 1 && -1 <= colStep && colStep <= 1);
    List<GameMove> result = [];
    int? piece;

    for (int distance = 1; distance <= max(_rows, _cols); distance++) {
      if (!isInside(
          move.row + rowStep * distance, move.col + colStep * distance)) {
        return [];
      }
      piece =
          _board[move.row + rowStep * distance][move.col + colStep * distance];

      if (piece == null) return [];
      if (piece == move.symbol) break;

      result.add(GameMove(
        row: move.row + rowStep * distance,
        col: move.col + colStep * distance,
        symbol: 1 - move.symbol,
        humanPlayer: move.humanPlayer,
      ));
    }
    return result;
  }

  void _prepareCellWeights() {
    const int standardValue = 3;

    _cellWeights = List.generate(
      _rows,
      (index) => List.generate(
        _cols,
        (index) => standardValue,
        growable: false,
      ),
      growable: false,
    );

    for (int row = 0; row < _rows; row++) {
      for (int col = 0; col < _cols; col++) {
        if (row == 0 || col == 0 || row == _rows - 1 || col == _cols - 1) {
          _cellWeights[row][col] = 5;
        }
        if (_cellWeights[row][col] == standardValue &&
            (row == 1 || col == 1 || row == _rows - 2 || col == _cols - 2)) {
          _cellWeights[row][col] = -5;
        }

        // Corners
        if ((row == 0 || row == _rows - 1) && (col == 0 || col == _cols - 1)) {
          _cellWeights[row][col] = 120;
        }
        // Inside corners
        if ((row == 1 || row == _rows - 2) && (col == 1 || col == _cols - 2)) {
          _cellWeights[row][col] = -40;
        }
      }
    }

    _cellWeights[0][2] = _cellWeights[0][_cols - 3] =
      _cellWeights[_rows - 1][2] = _cellWeights[_rows - 1][_cols - 3] =
      _cellWeights[2][0] = _cellWeights[2][_cols - 1] =
      _cellWeights[_rows - 3][0] = _cellWeights[_rows - 3][_cols - 1] = 20;

    _cellWeights[0][1] = _cellWeights[0][_cols - 2] =
      _cellWeights[_rows - 1][1] = _cellWeights[_rows - 1][_cols - 2] =
      _cellWeights[1][0] = _cellWeights[1][_cols - 1] =
      _cellWeights[_rows - 2][0] = _cellWeights[_rows - 2][_cols - 1] = -20;
  }
}
