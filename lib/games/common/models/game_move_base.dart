abstract class GameMoveBase {
  int row;
  int col;
  int value = 0;
  bool winning = false;

  GameMoveBase({required this.row, required this.col});
}