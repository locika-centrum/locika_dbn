import 'package:hive/hive.dart';
import 'package:logging/logging.dart';

import '../../common/models/game_move_base.dart';
import '../../common/models/game_score_base.dart';
import '../game/game_move.dart';

part 'reversi_game_score.g.dart';

Logger _log = Logger('reversi_game_score.dart');

@HiveType(typeId: 3)
class ReversiGameScore extends GameScoreBase {
  static String hiveBoxName = 'reversi-score-box';
  static String dataKey = 'score';

  ReversiGameScore({int noOfGames = 0, int noOfWins = 0, int noOfLosses = 0})
      : _noOfGames = noOfGames,
        _noOfWins = noOfWins,
        _noOfLosses = noOfLosses;

  static Future<ReversiGameScore> loadData(int gameSize) async {
    Box box = await Hive.openBox(hiveBoxName);
    ReversiGameScore? result = box.get('${dataKey}_$gameSize');
    _log.finest('Data from DB ($hiveBoxName, ${dataKey}_$gameSize): $result');

    if (result == null) {
      result = ReversiGameScore();
      box.put('${dataKey}_$gameSize', result);
    }
    result.isReady = true;

    return result;
  }

  // Persisted values
  @HiveField(0, defaultValue: 0)
  int _noOfGames;
  @override
  int get noOfGames => _noOfGames;
  @override
  set noOfGames(int games) {
    _noOfGames = games;
    notifyListeners();

    save();
  }

  @HiveField(1, defaultValue: 0)
  int _noOfWins;
  int get noOfWins => _noOfWins;
  set noOfWins(int wins) {
    _noOfWins = wins;
    notifyListeners();

    save();
  }

  @HiveField(2, defaultValue: 0)
  int _noOfLosses;
  int get noOfLosses => _noOfLosses;
  set noOfLosses(int losses) {
    _noOfLosses = losses;
    notifyListeners();

    save();
  }

  @override
  String get highScore => '$noOfGames';


  @override
  void move(GameMoveBase? move) {
    GameMove? currentMove = move as GameMove?;
    int humanScore;
    int aiScore;

    if (currentMove != null) {
      if (currentMove.humanPlayer) {
        humanScore = currentMove.symbol == 1 ? currentMove.blackScore : currentMove.whiteScore;
        aiScore = currentMove.symbol == 0 ? currentMove.blackScore : currentMove.whiteScore;
      } else {
        humanScore = currentMove.symbol == 0 ? currentMove.blackScore : currentMove.whiteScore;
        aiScore = currentMove.symbol == 1 ? currentMove.blackScore : currentMove.whiteScore;
      }

      gameScore = '$humanScore:$aiScore';
    }

    super.move(move);
  }

  // Specific functions for given game (overide)
  // move       ... records move
  // gameOver   ... evaluates best score
  // reset      ... resets score and action button
  @override
  void gameOver() {
    GameMove? move = lastMove as GameMove?;

    if (move != null) {
      if (move.winning) {
        noOfWins += move.humanPlayer ? 1 : 0;
        noOfLosses += move.humanPlayer ? 0 : 1;
        _log.fine('GAME OVER: (${move.humanPlayer ? "win" : "loss"}) $this');
      } else {
        _log.fine('GAME OVER: (draw) $this');
      }
    }
    action = reset;

    super.gameOver();
  }

  @override
  String toString() {
    return '{noOfGames: $noOfGames, score: ($noOfWins:$noOfLosses)}';
  }
}
