import 'package:art_of_evolve/src/features/goals/data/goal_repository.dart';
import 'package:art_of_evolve/src/features/goals/domain/goal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'goal_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Box<Goal>>(as: #MockBox)])
void main() {
  late MockBox mockBox;
  late GoalRepository repository;

  setUp(() {
    mockBox = MockBox();
    repository = GoalRepository(mockBox);
  });

  group('GoalRepository', () {
    final tGoal = Goal(
      id: '1',
      title: 'Test Goal',
      targetDate: DateTime.now(), // Added required param
      createdAt: DateTime.now(),
    );

    test('getGoals returns list of goals from box', () async {
      // Arrange
      when(mockBox.values).thenReturn([tGoal]);

      // Act
      final result = await repository.getGoals();

      // Assert
      expect(result, equals([tGoal]));
      verify(mockBox.values).called(1);
    });

    test('saveGoal puts goal into box', () async {
      // Act
      await repository.saveGoal(tGoal);

      // Assert
      verify(mockBox.put('1', tGoal)).called(1);
    });

    test('deleteGoal removals goal from box', () async {
      // Act
      await repository.deleteGoal('1');

      // Assert
      verify(mockBox.delete('1')).called(1);
    });
  });
}
