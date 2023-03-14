// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsDataAdapter extends TypeAdapter<SettingsData> {
  @override
  final int typeId = 0;

  @override
  SettingsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsData()
      .._gameSize = fields[0] == null ? 0 : fields[0] as int
      .._slidingPictures = fields[1] == null ? false : fields[1] as bool
      .._tictactoeStartsHuman = fields[2] == null ? true : fields[2] as bool
      .._reversiStartsHuman = fields[3] == null ? true : fields[3] as bool
      .._nickName = fields[4] == null ? '' : fields[4] as String
      .._firstLogin = fields[5] == null ? true : fields[5] as bool;
  }

  @override
  void write(BinaryWriter writer, SettingsData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj._gameSize)
      ..writeByte(1)
      ..write(obj._slidingPictures)
      ..writeByte(2)
      ..write(obj._tictactoeStartsHuman)
      ..writeByte(3)
      ..write(obj._reversiStartsHuman)
      ..writeByte(4)
      ..write(obj._nickName)
      ..writeByte(5)
      ..write(obj._firstLogin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
