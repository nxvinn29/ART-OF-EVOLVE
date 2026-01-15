import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/core/monitoring/performance_observer.dart';

void main() {
  group('PerformanceObserver Tests', () {
    test('logs when provider is initialized', () {
      final logs = <String>[];
      final observer = PerformanceObserver(
        onLog: (message) => logs.add(message),
      );

      final container = ProviderContainer(observers: [observer]);
      final provider = Provider<int>((ref) => 0);

      container.read(provider);

      expect(
        logs,
        contains(predicate<String>((s) => s.contains('Provider init'))),
      );
    });

    test('logs when provider is updated', () {
      final logs = <String>[];
      final observer = PerformanceObserver(
        onLog: (message) => logs.add(message),
      );

      final container = ProviderContainer(observers: [observer]);
      final provider = StateProvider<int>((ref) => 0);

      container.read(provider.notifier).state++;

      expect(
        logs,
        contains(predicate<String>((s) => s.contains('Provider updated'))),
      );
    });

    test('logs when provider is disposed', () {
      final logs = <String>[];
      final observer = PerformanceObserver(
        onLog: (message) => logs.add(message),
      );

      final container = ProviderContainer(observers: [observer]);
      final provider = Provider<int>((ref) => 0);

      container.read(provider);
      container.dispose();

      // Note: Provider disposal might happen asynchronously depending on Riverpod,
      // but usually synchronous on container disposal.
      // However, observers are notified.
      // Actually, standard ProviderObserver 'didDisposeProvider' is called.

      expect(
        logs,
        contains(predicate<String>((s) => s.contains('Provider disposed'))),
      );
    });
  });
}
