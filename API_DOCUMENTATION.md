# API Documentation

## Overview
This document provides comprehensive API documentation for the Art of Evolve application's core services and repositories.

## Repositories

### GoalsRepository

#### Purpose
Manages persistent storage of user goals using Hive local database.

#### Methods

##### `getGoals()`
```dart
Future<List<Goal>> getGoals()
```
Retrieves all stored goals sorted by target date.

**Returns**: `Future<List<Goal>>` - List of all goals

**Example**:
```dart
final goals = await repository.getGoals();
```

##### `saveGoal(Goal goal)`
```dart
Future<void> saveGoal(Goal goal)
```
Saves or updates a goal.

**Parameters**:
- `goal`: The goal object to save

**Example**:
```dart
final goal = Goal(title: 'Learn Flutter', targetDate: DateTime(2025, 12, 31));
await repository.saveGoal(goal);
```

##### `deleteGoal(String id)`
```dart
Future<void> deleteGoal(String id)
```
Deletes a goal by ID.

**Parameters**:
- `id`: Unique identifier of the goal

**Example**:
```dart
await repository.deleteGoal('goal-123');
```

### JournalRepository

#### Purpose
Manages journal entries with support for rich content, moods, and tags.

#### Methods

##### `getEntries()`
```dart
Future<List<JournalEntry>> getEntries()
```
Retrieves all journal entries sorted by date (newest first).

**Returns**: `Future<List<JournalEntry>>` - List of journal entries

##### `saveEntry(JournalEntry entry)`
```dart
Future<void> saveEntry(JournalEntry entry)
```
Saves or updates a journal entry.

**Parameters**:
- `entry`: The journal entry to save

##### `deleteEntry(String id)`
```dart
Future<void> deleteEntry(String id)
```
Deletes a journal entry by ID.

**Parameters**:
- `id`: Unique identifier of the entry

## Controllers

### GoalsController

#### Purpose
State management for goals using Riverpod.

#### State
```dart
AsyncValue<List<Goal>>
```

#### Methods

##### `loadGoals()`
```dart
Future<void> loadGoals()
```
Loads goals from repository and updates state.

##### `addGoal(String title, DateTime targetDate, {String description})`
```dart
Future<void> addGoal(String title, DateTime targetDate, {String description = ''})
```
Creates a new goal.

**Parameters**:
- `title`: Goal title
- `targetDate`: Target completion date
- `description`: Optional description

##### `toggleGoal(String id)`
```dart
Future<void> toggleGoal(String id)
```
Toggles the achievement status of a goal.

**Parameters**:
- `id`: Goal identifier

##### `deleteGoal(String id)`
```dart
Future<void> deleteGoal(String id)
```
Deletes a goal.

**Parameters**:
- `id`: Goal identifier

### JournalController

#### Purpose
State management for journal entries.

#### State
```dart
AsyncValue<List<JournalEntry>>
```

#### Methods

##### `loadEntries()`
```dart
Future<void> loadEntries()
```
Loads journal entries from repository.

##### `addEntry(...)`
```dart
Future<void> addEntry(
  String title,
  String content,
  String mood, {
  List<String> tags = const [],
  String? prompt,
  List<Map<String, dynamic>> contentBlocks = const [],
  bool hasDrawing = false,
  bool hasAudio = false,
  DateTime? reminderTime,
})
```
Creates a new journal entry with rich content support.

**Parameters**:
- `title`: Entry title
- `content`: Main text content
- `mood`: Current mood
- `tags`: Optional tags for categorization
- `prompt`: Optional writing prompt
- `contentBlocks`: Rich content blocks
- `hasDrawing`: Whether entry includes drawings
- `hasAudio`: Whether entry includes audio
- `reminderTime`: Optional reminder time

##### `deleteEntry(String id)`
```dart
Future<void> deleteEntry(String id)
```
Deletes a journal entry.

**Parameters**:
- `id`: Entry identifier

### SettingsController

#### Purpose
Manages user settings and preferences.

#### State
```dart
UserSettings
```

#### Methods

##### `toggle24HourTime()`
```dart
Future<void> toggle24HourTime()
```
Toggles between 12-hour and 24-hour time format.

##### `setTemperatureUnit(String unit)`
```dart
Future<void> setTemperatureUnit(String unit)
```
Sets temperature unit preference.

**Parameters**:
- `unit`: Temperature unit ('Celsius', 'Fahrenheit', 'Kelvin')

##### `setStartOfWeek(String day)`
```dart
Future<void> setStartOfWeek(String day)
```
Sets the start day of the week.

**Parameters**:
- `day`: Day name ('Monday', 'Sunday', etc.)

##### `setDateFormat(String format)`
```dart
Future<void> setDateFormat(String format)
```
Sets date format preference.

**Parameters**:
- `format`: Date format string

## Models

### Goal

```dart
class Goal {
  final String id;
  final String title;
  final String description;
  final DateTime targetDate;
  final bool isAchieved;
  final DateTime createdAt;
}
```

### JournalEntry

```dart
class JournalEntry {
  final String id;
  final String title;
  final String content;
  final String mood;
  final List<String> tags;
  final DateTime date;
  final String? prompt;
  final List<Map<String, dynamic>> contentBlocks;
  final bool hasDrawing;
  final bool hasAudio;
  final DateTime? reminderTime;
}
```

### UserSettings

```dart
class UserSettings {
  final bool is24HourTime;
  final String temperatureUnit;
  final String startOfWeek;
  final String dateFormat;
}
```

## Error Handling

All async methods may throw:
- `HiveError`: Database operation failures
- `Exception`: General errors with descriptive messages

## Usage Examples

### Creating and Managing Goals

```dart
// Get goals controller
final controller = ref.read(goalsProvider.notifier);

// Add a new goal
await controller.addGoal(
  'Complete Flutter Course',
  DateTime(2025, 12, 31),
  description: 'Finish all modules and projects',
);

// Toggle goal completion
await controller.toggleGoal(goalId);

// Delete a goal
await controller.deleteGoal(goalId);
```

### Working with Journal Entries

```dart
// Get journal controller
final controller = ref.read(journalControllerProvider.notifier);

// Create entry with mood and tags
await controller.addEntry(
  'Today\'s Reflection',
  'Had a productive day working on my goals.',
  'happy',
  tags: ['productivity', 'gratitude'],
);

// Delete entry
await controller.deleteEntry(entryId);
```

### Managing Settings

```dart
// Get settings controller
final controller = ref.read(settingsProvider.notifier);

// Change time format
await controller.toggle24HourTime();

// Set temperature unit
await controller.setTemperatureUnit('Celsius');
```

## Best Practices

1. Always handle `AsyncValue` states (loading, data, error)
2. Use `ref.watch` for reactive updates
3. Use `ref.read` for one-time reads
4. Implement proper error handling
5. Show loading indicators during async operations

## Resources

- [Riverpod Documentation](https://riverpod.dev)
- [Hive Documentation](https://docs.hivedb.dev)
- [Flutter State Management](https://docs.flutter.dev/development/data-and-backend/state-mgmt)
