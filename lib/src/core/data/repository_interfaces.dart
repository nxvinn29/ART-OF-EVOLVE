import '../../features/habits/domain/habit.dart';
import '../../features/todos/domain/todo.dart';
import '../../features/goals/domain/goal.dart';
import '../../features/self_care/domain/journal_entry.dart';
import '../../features/onboarding/domain/user_profile.dart';

abstract class IHabitsRepository {
  Future<List<Habit>> getHabits();
  Future<void> saveHabit(Habit habit);
  Future<void> deleteHabit(String id);
  Stream<List<Habit>> watchHabits();
}

abstract class ITodosRepository {
  Future<List<Todo>> getTodos();
  Future<void> saveTodo(Todo todo);
  Future<void> deleteTodo(String id);
  Stream<List<Todo>> watchTodos();
}

abstract class IGoalsRepository {
  Future<List<Goal>> getGoals();
  Future<void> saveGoal(Goal goal);
  Future<void> deleteGoal(String id);
}

abstract class IJournalRepository {
  Future<List<JournalEntry>> getEntries();
  Future<void> saveEntry(JournalEntry entry);
  Future<void> deleteEntry(String id);
  Stream<List<JournalEntry>> watchEntries();
}

abstract class IUserRepository {
  Future<UserProfile?> getUserProfile();
  Future<void> saveUserProfile(UserProfile profile);
  Stream<UserProfile?> watchUserProfile();
}
