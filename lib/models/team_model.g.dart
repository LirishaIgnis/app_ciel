// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeamAdapter extends TypeAdapter<Team> {
  @override
  final int typeId = 0;

  @override
  Team read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Team(
      name: fields[0] as String,
      acronym: fields[1] as String,
      primaryColor: fields[2] as int,
      secondaryColor: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Team obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.acronym)
      ..writeByte(2)
      ..write(obj.primaryColor)
      ..writeByte(3)
      ..write(obj.secondaryColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
