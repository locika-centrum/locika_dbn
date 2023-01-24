import '../../common/models/game_move_base.dart';

enum Direction {
  horizontal,
  vertical,
  diagonalLTRB,
  diagonalRTLB
}

class GameMove extends GameMoveBase {
  int symbol;
  bool humanPlayer;
  Direction? winDirection;

  GameMove({
    required super.row,
    required super.col,
    required this.symbol,
    required this.humanPlayer,
  });

  @override
  String toString() {
    return '{row: $row, col: $col, symbol: $symbol, value: $value, humanPlayer: $humanPlayer, winningMove: $winning, winningDirection: $winDirection}';
  }
}
