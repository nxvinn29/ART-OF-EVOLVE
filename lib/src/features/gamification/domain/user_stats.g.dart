// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStatsAdapter extends TypeAdapter<UserStats> {
  @override
  final int typeId = 6;

  @override
  UserStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStats(
      currentXp: fields[0] as int,
      level: fields[1] as int,
      totalHabitsCompleted: fields[2] as int,
      currentStreak: fields[3] as int,
      unlockedBadgeIds: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserStats obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.currentXp)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.totalHabitsCompleted)
      ..writeByte(3)
      ..write(obj.currentStreak)
      ..writeByte(4)
      ..write(obj.unlockedBadgeIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
