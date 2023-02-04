import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';

import './game_move_base.dart';

Logger _log = Logger('Abstract GameScore');

abstract class GameScoreBase with ChangeNotifier, HiveObjectMixin {
  bool isReady = false;

  int _noOfMoves = 0;
  int get noOfMoves => _noOfMoves;
  set noOfMoves(int count) {
    _noOfMoves = count;
    notifyListeners();
  }

  int _noOfGames = 0;
  int get noOfGames => _noOfGames;
  set noOfGames(int count) {
    _noOfGames = count;
    notifyListeners();
  }

  String _gameScore = '';
  String get gameScore => _gameScore;
  set gameScore(String score) {
    _gameScore = score;
    notifyListeners();
  }

  String _highScore = '';
  String get highScore => _highScore;
  set highScore(String score) {
    _highScore = score;
    notifyListeners();
  }

  void Function()? _action;
  Function? get action => _action;

  String _actionTitle = 'Nová hra';
  String get actionTitle => _actionTitle;
  set actionTitle(String title) {
    _actionTitle = title;
    notifyListeners();
  }

  Icon _actionIcon = const Icon(Icons.sync);
  Icon get actionIcon => _actionIcon;

  void setAction(Function()? action, [String title = 'Nová hra']) {
    _actionIcon =
        title == 'Nová hra' ? const Icon(Icons.sync) : const Icon(Icons.skip_next);
    _action = action;

    actionTitle = title;
  }

  GameMoveBase? lastMove;

  void gameOver() {
    noOfGames++;
  }

  void move(GameMoveBase? move) {
    lastMove = move;
    noOfMoves++;

    if (move?.winning ?? false) {
      gameOver();
    }
  }

  void reset() {
    _log.finest('reset');
    lastMove = null;
    _action = null;
    actionTitle = 'Nová hra';
    noOfMoves = 0;

    notifyListeners();
  }
}
