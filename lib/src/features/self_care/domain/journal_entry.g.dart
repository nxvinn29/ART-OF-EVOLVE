// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 4;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalEntry(
      id: fields[0] as String?,
      title: fields[1] as String,
      content: fields[2] as String,
      date: fields[3] as DateTime?,
      mood: fields[4] as String,
      tags: (fields[5] as List).cast<String>(),
      prompt: fields[6] as String?,
      contentBlocks: fields[7] == null
          ? []
          : (fields[7] as List)
              .map((dynamic e) => (e as Map).cast<String, dynamic>())
              .toList(),
      hasDrawing: fields[8] == null ? false : fields[8] as bool,
      hasAudio: fields[9] == null ? false : fields[9] as bool,
      reminderTime: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.mood)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.prompt)
      ..writeByte(7)
      ..write(obj.contentBlocks)
      ..writeByte(8)
      ..write(obj.hasDrawing)
      ..writeByte(9)
      ..write(obj.hasAudio)
      ..writeByte(10)
      ..write(obj.reminderTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
