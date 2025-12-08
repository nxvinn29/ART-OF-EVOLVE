import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/journal_entry.dart';
import '../../../services/storage/hive_service.dart';
import '../../../core/data/repository_interfaces.dart';

final journalRepositoryProvider = Provider<IJournalRepository>((ref) {
  return JournalRepository(HiveService.journalBox);
});

class JournalRepository implements IJournalRepository {
  final Box<JournalEntry> _box;

  JournalRepository(this._box);

  @override
  Future<List<JournalEntry>> getEntries() async {
    return _box.values.toList();
  }

  @override
  Future<void> saveEntry(JournalEntry entry) async {
    await _box.put(entry.id, entry);
  }

  @override
  Future<void> deleteEntry(String id) async {
    await _box.delete(id);
  }
}
