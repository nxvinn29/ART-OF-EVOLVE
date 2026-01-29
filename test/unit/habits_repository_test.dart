import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hive/hive.dart';
import 'package:art_of_evolve/src/features/habits/data/habits_repository.dart';
import 'package:art_of_evolve/src/features/habits/domain/habit.dart';

@GenerateNiceMocks([MockSpec<Box>()])
import 'habits_repository_test.mocks.dart';

void main() {
  late MockBox<Habit> mockBox;
  late HabitsRepository repository;

  setUp(() {
    mockBox = MockBox<Habit>();
    when(mockBox.values).thenReturn([]);
    when(mockBox.put(any, any)).thenAnswer((_) async {});
    when(mockBox.delete(any)).thenAnswer((_) async {});
    repository = HabitsRepository(mockBox);
  });

  group('HabitsRepository', () {
    final testHabit = Habit(
      id: '1',
      title: 'Test Habit',
      color: 0xFF000000,
      iconCodePoint: 123,
    );

    test('getHabits should return list of habits from box', () async {
      when(mockBox.values).thenReturn([testHabit]);

      final result = await repository.getHabits();

      expect(result, equals([testHabit]));
      verify(mockBox.values).called(1);
    });

    test('saveHabit should put habit into box', () async {
      await repository.saveHabit(testHabit);

      verify(mockBox.put(testHabit.id, testHabit)).called(1);
    });

    test('deleteHabit should delete habit from box', () async {
      await repository.deleteHabit('1');

      verify(mockBox.delete('1')).called(1);
    });
  });
}
