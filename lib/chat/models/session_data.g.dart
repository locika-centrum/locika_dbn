// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionDataAdapter extends TypeAdapter<SessionData> {
  @override
  final int typeId = 10;

  @override
  SessionData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionData().._cookie = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, SessionData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj._cookie);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
