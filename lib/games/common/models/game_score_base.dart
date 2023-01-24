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

  void Function()? action;
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
    lastMove = null;
    action = null;
    noOfMoves = 0;

    notifyListeners();
  }
}