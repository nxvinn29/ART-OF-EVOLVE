# Performance Optimization Guide

## Overview
This guide provides best practices and strategies for optimizing performance in the Art of Evolve application.

## Flutter Performance Best Practices

### Widget Optimization

#### Use const Constructors
```dart
// Good
const Text('Hello World');
const SizedBox(height: 16);

// Bad
Text('Hello World');
SizedBox(height: 16);
```

#### Avoid Unnecessary Rebuilds
```dart
// Use const constructors
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Text('Static content');
  }
}

// Extract widgets that don't need to rebuild
class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Complex widget tree
  }
}
```

### List Performance

#### Use ListView.builder for Long Lists
```dart
// Good - Only builds visible items
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemWidget(item: items[index]);
  },
);

// Bad - Builds all items at once
ListView(
  children: items.map((item) => ItemWidget(item: item)).toList(),
);
```

#### Implement Pagination
```dart
class PaginatedList extends StatefulWidget {
  @override
  State<PaginatedList> createState() => _PaginatedListState();
}

class _PaginatedListState extends State<PaginatedList> {
  final ScrollController _scrollController = ScrollController();
  List<Item> _items = [];
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMore();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMore();
    }
  }
  
  Future<void> _loadMore() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    
    final newItems = await fetchItems(offset: _items.length);
    setState(() {
      _items.addAll(newItems);
      _isLoading = false;
    });
  }
}
```

### Image Optimization

#### Use Cached Images
```dart
// Use cached_network_image for remote images
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
);
```

#### Optimize Image Sizes
```dart
// Resize images before displaying
Image.asset(
  'assets/image.png',
  width: 100,
  height: 100,
  fit: BoxFit.cover,
);
```

## State Management Optimization

### Riverpod Best Practices

#### Use Providers Efficiently
```dart
// Good - Specific provider
final userNameProvider = Provider<String>((ref) {
  return ref.watch(userProvider).name;
});

// Bad - Watching entire object when only need one field
Consumer(
  builder: (context, ref, child) {
    final user = ref.watch(userProvider); // Rebuilds on any user change
    return Text(user.name);
  },
);
```

#### Use select for Partial Updates
```dart
// Only rebuilds when name changes
Consumer(
  builder: (context, ref, child) {
    final name = ref.watch(userProvider.select((user) => user.name));
    return Text(name);
  },
);
```

### Minimize State Updates
```dart
// Good - Batch updates
void updateMultipleFields() {
  state = state.copyWith(
    field1: newValue1,
    field2: newValue2,
    field3: newValue3,
  );
}

// Bad - Multiple updates
void updateMultipleFields() {
  state = state.copyWith(field1: newValue1);
  state = state.copyWith(field2: newValue2);
  state = state.copyWith(field3: newValue3);
}
```

## Database Optimization

### Hive Performance

#### Use Lazy Boxes for Large Data
```dart
// For large datasets
final lazyBox = await Hive.openLazyBox('large_data');

// Only loads data when accessed
final value = await lazyBox.get('key');
```

#### Batch Operations
```dart
// Good - Batch write
await box.putAll({
  'key1': value1,
  'key2': value2,
  'key3': value3,
});

// Bad - Individual writes
await box.put('key1', value1);
await box.put('key2', value2);
await box.put('key3', value3);
```

#### Index Frequently Queried Fields
```dart
@HiveType(typeId: 1)
class Goal {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2, indexed: true)  // Index for fast queries
  final DateTime targetDate;
}
```

## Async Operations

### Use Isolates for Heavy Computation
```dart
import 'dart:isolate';

Future<List<Result>> processLargeDataset(List<Data> data) async {
  final receivePort = ReceivePort();
  
  await Isolate.spawn(_processInIsolate, receivePort.sendPort);
  
  final sendPort = await receivePort.first as SendPort;
  final responsePort = ReceivePort();
  
  sendPort.send([data, responsePort.sendPort]);
  
  return await responsePort.first as List<Result>;
}

void _processInIsolate(SendPort sendPort) {
  final port = ReceivePort();
  sendPort.send(port.sendPort);
  
  port.listen((message) {
    final data = message[0] as List<Data>;
    final replyPort = message[1] as SendPort;
    
    final results = _heavyComputation(data);
    replyPort.send(results);
  });
}
```

### Debounce User Input
```dart
import 'dart:async';

class SearchController {
  Timer? _debounce;
  
  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }
  
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
```

## Memory Management

### Dispose Resources Properly
```dart
class MyController extends StateNotifier<State> {
  final StreamController _controller = StreamController();
  final Timer _timer;
  
  @override
  void dispose() {
    _controller.close();
    _timer.cancel();
    super.dispose();
  }
}
```

### Use WeakReferences for Caching
```dart
class ImageCache {
  final Map<String, WeakReference<Image>> _cache = {};
  
  Image? getImage(String key) {
    return _cache[key]?.target;
  }
  
  void cacheImage(String key, Image image) {
    _cache[key] = WeakReference(image);
  }
}
```

## Build Performance

### Reduce App Size
```bash
# Build with code shrinking
flutter build apk --release --shrink

# Analyze app size
flutter build apk --analyze-size
```

### Split Debug Info
```bash
# Separate debug symbols
flutter build apk --split-debug-info=debug-info/
```

## Monitoring Performance

### Use Flutter DevTools
```bash
# Launch DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

### Profile Performance
```dart
import 'package:flutter/foundation.dart';

void performanceTest() {
  final stopwatch = Stopwatch()..start();
  
  // Code to measure
  expensiveOperation();
  
  stopwatch.stop();
  debugPrint('Operation took: ${stopwatch.elapsedMilliseconds}ms');
}
```

### Timeline Events
```dart
import 'dart:developer' as developer;

void trackedOperation() {
  developer.Timeline.startSync('ExpensiveOperation');
  
  // Your code here
  expensiveOperation();
  
  developer.Timeline.finishSync();
}
```

## Network Optimization

### Cache Network Responses
```dart
class ApiClient {
  final Map<String, CachedResponse> _cache = {};
  
  Future<Response> get(String url) async {
    final cached = _cache[url];
    if (cached != null && !cached.isExpired) {
      return cached.response;
    }
    
    final response = await http.get(Uri.parse(url));
    _cache[url] = CachedResponse(response, DateTime.now());
    return response;
  }
}
```

### Compress Data
```dart
import 'dart:convert';
import 'dart:io';

Future<void> sendCompressedData(Map<String, dynamic> data) async {
  final jsonString = json.encode(data);
  final compressed = gzip.encode(utf8.encode(jsonString));
  
  // Send compressed data
}
```

## Animation Performance

### Use AnimatedBuilder
```dart
// Good - Only rebuilds animated widget
AnimatedBuilder(
  animation: animation,
  builder: (context, child) {
    return Transform.scale(
      scale: animation.value,
      child: child,
    );
  },
  child: ExpensiveWidget(), // Built once
);
```

### Avoid Opacity for Animations
```dart
// Good - Use AnimatedOpacity
AnimatedOpacity(
  opacity: isVisible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 300),
  child: MyWidget(),
);

// Bad - Direct Opacity widget
Opacity(
  opacity: opacity,
  child: MyWidget(),
);
```

## Best Practices Summary

1. **Use const constructors** wherever possible
2. **Implement pagination** for long lists
3. **Optimize images** - resize and cache
4. **Batch database operations**
5. **Debounce user input**
6. **Dispose resources** properly
7. **Profile regularly** with DevTools
8. **Use isolates** for heavy computation
9. **Cache network responses**
10. **Minimize widget rebuilds**

## Resources

- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Flutter DevTools](https://docs.flutter.dev/development/tools/devtools/overview)
- [Riverpod Performance](https://riverpod.dev/docs/concepts/performance)
