import 'package:hive/hive.dart';
import 'package:logging/logging.dart';

import '../../common/models/game_score_base.dart';

part 'sliding_game_score.g.dart';

Logger _log = Logger('sliding_game_score.dart');

@HiveType(typeId: 2)
class SlidingGameScore extends GameScoreBase {
  static String hiveBoxName = 'sliding-score-box';
  static String dataKey = 'score';

  static Future<SlidingGameScore> loadData(int gameSize) async {
    Box box = await Hive.openBox(hiveBoxName);
    SlidingGameScore? result = box.get('${dataKey}_$gameSize');
    _log.finest('Data from DB ($hiveBoxName, ${dataKey}_$gameSize): $result');

    if (result == null) {
      result = SlidingGameScore();
      box.put('${dataKey}_$gameSize', result);
    }
    result.isReady = true;

    return result;
  }

  SlidingGameScore({int noOfGames = 0, int bestNoOfMoves = -1})
      : _noOfGames = noOfGames,
        _bestNoOfMoves = bestNoOfMoves;

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

  @HiveField(1, defaultValue: -1)
  int _bestNoOfMoves;
  int get bestNoOfMoves => _bestNoOfMoves;
  set bestNoOfMoves(int wins) {
    _bestNoOfMoves = wins;
    notifyListeners();

    save();
  }

  // Calculated score values (override)
  @override
  String get highScore => bestNoOfMoves < 0 ? '-' : bestNoOfMoves.toString();

  @override
  String get gameScore => noOfMoves.toString();
  @override
  set gameScore(String value) {
    noOfMoves = value as int;
    gameScore = value;
  }

  // Specific functions for given game (overide)
  // move       ... records move
  // gameOver   ... evaluates best score
  // reset      ... resets score and action button
  @override
  void gameOver() {
    if (bestNoOfMoves < 0 || noOfMoves < bestNoOfMoves) {
      bestNoOfMoves = noOfMoves;
      _log.fine('GAME OVER: (new best score) $this');
    } else {
      _log.fine('GAME OVER: $this');
    }
    action = reset;

    super.gameOver();
  }

  @override
  String toString() {
    return '{noOfGames: $noOfGames, highScore: $highScore, currentScore: $gameScore}';
  }
}
