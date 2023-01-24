// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reversi_game_score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReversiGameScoreAdapter extends TypeAdapter<ReversiGameScore> {
  @override
  final int typeId = 3;

  @override
  ReversiGameScore read(BinaryReader reader) {
    return ReversiGameScore();
  }

  @override
  void write(BinaryWriter writer, ReversiGameScore obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReversiGameScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
