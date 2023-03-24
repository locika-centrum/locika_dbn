import '../../common/models/game_move_base.dart';

class GameMove extends GameMoveBase {
  int symbol;
  bool humanPlayer;
  int blackScore;
  int whiteScore;

  GameMove({
    required super.row,
    required super.col,
    required this.symbol,
    required this.humanPlayer,
    this.blackScore = 0,
    this.whiteScore = 0,
  });

  @override
  String toString() {
    return '{row: $row, col: $col, symbol: $symbol, value: $value, score: (${symbol == 1 ? blackScore : whiteScore}:${symbol == 0 ? blackScore : whiteScore}), humanPlayer: $humanPlayer, winningMove: $winning}';
  }
}
