import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/logger.dart';

/// A [ProviderObserver] that logs provider state changes and performance metrics.
///
/// This observer helps track:
/// - Provider initialization time
/// - State updates
/// - Errors in providers
class PerformanceObserver extends ProviderObserver {
  /// Function to handle log messages. Defaults to `Logger.log` if not provided.
  final void Function(String message)? onLog;

  /// Creates a [PerformanceObserver].
  ///
  /// [onLog] can be provided for testing or custom logging.
  PerformanceObserver({this.onLog});

  /// Called when a provider is initialized.
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    _log('Provider init: ${provider.name ?? provider.runtimeType}');
  }

  /// Called when a provider's value changes.
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final name = provider.name ?? provider.runtimeType;
    _log('Provider updated: $name');
  }

  /// Called when a provider is disposed.
  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    _log('Provider disposed: ${provider.name ?? provider.runtimeType}');
  }

  void _log(String message) {
    if (onLog != null) {
      onLog!(message);
    } else {
      Logger.log(message, name: 'Performance');
    }
  }
}
