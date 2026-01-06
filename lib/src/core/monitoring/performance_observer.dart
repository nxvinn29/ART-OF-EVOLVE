import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A [ProviderObserver] that logs provider state changes and performance metrics.
///
/// This observer helps track:
/// - Provider initialization time
/// - State updates
/// - Errors in providers
class PerformanceObserver extends ProviderObserver {
  /// Called when a provider is initialized.
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      print('Provider init: ${provider.name ?? provider.runtimeType}');
    }
  }

  /// Called when a provider's value changes.
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      final name = provider.name ?? provider.runtimeType;
      // Simple logging for now, but could be extended to measure frequency
      print('Provider updated: $name');
    }
  }

  /// Called when a provider is disposed.
  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      print('Provider disposed: ${provider.name ?? provider.runtimeType}');
    }
  }
}
