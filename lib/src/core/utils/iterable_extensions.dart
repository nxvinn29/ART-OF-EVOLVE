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
