/// Extension methods for [Iterable].
extension IterableExtensions<T> on Iterable<T> {
  /// Groups the elements in this [Iterable] by the key returned by [keySelector].
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  /// Returns a lazy iterable containing only the first element for each unique key.
  Iterable<T> distinctBy<K>(K Function(T) keySelector) sync* {
    final set = <K>{};
    for (final element in this) {
      final key = keySelector(element);
      if (set.add(key)) {
        yield element;
      }
    }
  }

  /// Splits the iterable into chunks of the given [size].
  Iterable<List<T>> chunked(int size) sync* {
    if (size <= 0) {
      throw ArgumentError('Size must be positive');
    }
    var chunk = <T>[];
    for (final element in this) {
      chunk.add(element);
      if (chunk.length == size) {
        yield chunk;
        chunk = [];
      }
    }
    if (chunk.isNotEmpty) {
      yield chunk;
    }
  }

  /// Returns a random element from the iterable.
  ///
  /// Throws [StateError] if the iterable is empty.
  T get random {
    if (isEmpty) {
      throw StateError('Cannot get random element from empty iterable');
    }
    return elementAt(DateTime.now().millisecond % length);
  }

  /// Returns the sum of all elements in the collection using the given [selector].
  num sumBy(num Function(T) selector) {
    num sum = 0;
    for (final element in this) {
      sum += selector(element);
    }
    return sum;
  }

  /// Returns the average of all elements in the collection using the given [selector].
  ///
  /// Returns 0.0 if the collection is empty.
  double averageBy(num Function(T) selector) {
    if (isEmpty) return 0.0;
    return sumBy(selector) / length;
  }

  /// Returns the first element that satisfies the given [test], or `null` if no
  /// such element is found.
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns a new list with elements from this iterable shuffled.
  List<T> toShuffledList() {
    final list = toList();
    list.shuffle();
    return list;
  }

  /// Returns [n] random elements from this iterable.
  List<T> takeRandom(int n) {
    if (n <= 0) return [];
    final list = toList();
    list.shuffle();
    return list.take(n).toList();
  }
}

/// Extension methods for [Iterable] of numbers.
extension IterableNumExtensions<T extends num> on Iterable<T> {
  /// Returns the sum of all elements in the collection.
  ///
  /// Returns 0 if the collection is empty.
  T get sum {
    if (isEmpty) return (T == int ? 0 : 0.0) as T;
    return reduce((value, element) => (value + element) as T);
  }

  /// Returns the average of all elements in the collection.
  ///
  /// Returns 0.0 if the collection is empty.
  double get average {
    if (isEmpty) return 0.0;
    return sum / length;
  }
}
