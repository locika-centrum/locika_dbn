import 'package:hive/hive.dart';
import 'package:logging/logging.dart';

import '../../common/models/game_score_base.dart';
import '../game/game_move.dart';

part 'tictactoe_game_score.g.dart';

Logger _log = Logger('tictactoe_game_score.dart');

@HiveType(typeId: 1)
class TicTacToeGameScore extends GameScoreBase {
  static String hiveBoxName = 'tictactoe-score-box';
  static String dataKey = 'score';

  TicTacToeGameScore({int noOfGames = 0, int noOfWins = 0, int noOfLosses = 0})
      : _noOfGames = noOfGames,
        _noOfWins = noOfWins,
        _noOfLosses = noOfLosses;

  static Future<TicTacToeGameScore> loadData(int gameSize) async {
    Box box = await Hive.openBox(hiveBoxName);
    TicTacToeGameScore? result = box.get('${dataKey}_$gameSize');
    _log.finest('Data from DB ($hiveBoxName, ${dataKey}_$gameSize): $result');

    if (result == null) {
      result = TicTacToeGameScore();
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

  // Calculated score values (override)
  @override
  String get gameScore => '$noOfWins:$noOfLosses';

  @override
  String get highScore => '$noOfGames';

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
    setAction(reset);

    super.gameOver();
  }

  @override
  String toString() {
    return '{noOfGames: $noOfGames, score: ($noOfWins:$noOfLosses)}';
  }
}
