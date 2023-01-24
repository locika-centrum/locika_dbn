import 'dart:math';

import './game_move.dart';
import 'package:logging/logging.dart';

Logger _log = Logger('game_board.dart');

class GameBoard {
  final int size;
  final List<Map<String, int>> _sizes = [
    {'size': 0, 'rows': 4, 'cols': 4},
    {'size': 1, 'rows': 6, 'cols': 6},
    {'size': 2, 'rows': 8, 'cols': 8},
    {'size': 3, 'rows': 10, 'cols': 10},
  ];

  late List<List<int?>> _board;
  late List<List<bool>> _validPositions;
  late int _rows, _cols;
  late int _symbol;
  late int _availableMoves;
  int _boardValue = 0;
  List<int> _symbolCount = [0, 0];

  List<List<int?>> get board => _board;
  List<List<bool>> get validPositions => _validPositions;
  int get rows => _rows;
  int get cols => _cols;
  int get symbol => _symbol;
  int get availableMoves => _availableMoves;
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
    _symbolCount = [...source._symbolCount];
    _availableMoves = source._availableMoves;
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
    _availableMoves--;
    move = _evaluateMove(move);
    _symbol = 1 - _symbol;
    _recalculateValidMoves();

    _log.finest('Move recorded: $move');
    return move;
  }

  GameMove _evaluateMove(GameMove move) {
    move.blackScore = _symbolCount[1];
    move.whiteScore = _symbolCount[0];

    return move;
  }

  void _recalculateValidMoves() {
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
        }
      }
    }
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
      if (!isInside(move.row + rowStep * distance, move.col + colStep * distance)) return [];
      piece = _board[move.row + rowStep * distance][move.col + colStep * distance];

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

  List<GameMove> possibleMoves() {
    List<GameMove> result = [];

    for (int row = 0; row < _rows; row++) {
      for (int col = 0; col < _cols; col++) {
        throw UnimplementedError;
      }
    }

    return result;
  }
}
