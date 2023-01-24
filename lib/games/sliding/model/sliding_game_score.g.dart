// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sliding_game_score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SlidingGameScoreAdapter extends TypeAdapter<SlidingGameScore> {
  @override
  final int typeId = 2;

  @override
  SlidingGameScore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SlidingGameScore()
      .._noOfGames = fields[0] == null ? 0 : fields[0] as int
      .._bestNoOfMoves = fields[1] == null ? -1 : fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, SlidingGameScore obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._noOfGames)
      ..writeByte(1)
      ..write(obj._bestNoOfMoves);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlidingGameScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
