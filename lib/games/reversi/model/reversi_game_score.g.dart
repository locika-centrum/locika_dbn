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
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReversiGameScore()
      .._noOfGames = fields[0] == null ? 0 : fields[0] as int
      .._noOfWins = fields[1] == null ? 0 : fields[1] as int
      .._noOfLosses = fields[2] == null ? 0 : fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, ReversiGameScore obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._noOfGames)
      ..writeByte(1)
      ..write(obj._noOfWins)
      ..writeByte(2)
      ..write(obj._noOfLosses);
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
