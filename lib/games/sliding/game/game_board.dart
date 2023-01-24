import 'package:logging/logging.dart';

import './game_move.dart';

Logger _log = Logger('GameBoard - sliding');

class GameBoard {
  final int settingsSize;
  late int _size;
  late List<List<int?>> _board;
  late int _moves = 0;

  List<List<int?>> get board => _board;
  int get size => _size;
  int get moves => _moves;

  GameBoard({required this.settingsSize}) {
    switch (settingsSize) {
      case 1:
        _size = 3;
        break;
      case 2:
        _size = 4;
        break;
      case 3:
        _size = 5;
        break;
      default:
        _size = 2;
    }
    _board = List.generate(
      _size,
      (index) => List.generate(
        _size,
        (index) => null,
        growable: false,
      ),
      growable: false,
    );

    while (!_setupBoard());
  }

  bool _setupBoard() {
    // Randomize the setup
    List<int?> values = List.generate(
      _size * _size,
          (index) => index == 0 ? null : index,
      growable: false,
    );
    values.shuffle();

    // Check if the sequence is solvable
    int inversions = 0;
    int emptyRow = 0;
    for (int i = 0; i < _size * _size; i++) {
      if (values[i] != null) {
        for (int j = i + 1; j < _size * _size; j++) {
          if (values[j] != null) {
            if (values[i]! > values[j]!) inversions++;
          }
        }
      } else {
        emptyRow = i ~/ _size;
      }
    }
    if (inversions == 0 && values[_size * _size - 1] == null) {
      return false;
    }

    _log.finest('List of values: $values');
    _log.finest(
        'Number of inversions: $inversions; Board size: $_size; Empty row: $emptyRow => ${_size % 2 == 1 ? inversions % 2 == 0 : (inversions + emptyRow) % 2 != 0}');
    // Correct if necessary
    if (!(_size % 2 == 1 ? inversions % 2 == 0 : (inversions + emptyRow) % 2 != 0)) {
      int first = -1;
      for (int i = 0; i < _size * _size; i++) {
        if (values[i] != null) {
          if (first < 0) {
            first = i;
          } else {
            int firstValue = values[first]!;
            values[first] = values[i];
            values[i] = firstValue;
            inversions--;
            break;
          }
        }
      }
      _log.finest('Corrected: $values');
    }
    if (inversions == 0 && values[_size * _size - 1] == null) {
      return false;
    }

    // Assign to the board
    for (int row = 0; row < _size; row++) {
      for (int col = 0; col < _size; col++) {
        _board[row][col] = values[_size * row + col];
      }
    }

    return true;
  }

  GameMove? recordCoordinates(int row, int col) {
    // find empty cell
    if (_board[row][col] == null) return null;

    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (row + i >= 0 &&
            col + j >= 0 &&
            row + i < _size &&
            col + j < _size &&
            i.abs() != j.abs()) {
          if (_board[row + i][col + j] == null) {
            _board[row + i][col + j] = _board[row][col];
            _board[row][col] = null;
            _moves++;
            return GameMove(row: row + i, col: col + j);
          }
        }
      }
    }

    return null;
  }

  bool evaluateBoard() {
    if (board[_size - 1][_size - 1] != null) return false;

    for (int i = 0; i < _size * _size - 1; i++) {
      if (board[i ~/ _size][i % _size] != i + 1) return false;
    }

    return true;
  }
}
