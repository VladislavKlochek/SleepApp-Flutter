// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmInfoAdapter extends TypeAdapter<AlarmInfo> {
  @override
  final int typeId = 1;

  @override
  AlarmInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlarmInfo(
      time: fields[0] as String,
      description: fields[1] as String,
      isActive: fields[2] as bool,
      isSound: fields[3] as bool,
      isVibration: fields[4] as bool,
      id: fields[5] as int,
      soundName: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmInfo obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.isActive)
      ..writeByte(3)
      ..write(obj.isSound)
      ..writeByte(4)
      ..write(obj.isVibration)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.soundName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
