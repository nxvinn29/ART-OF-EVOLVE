import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/core/utils/iterable_extensions.dart';

void main() {
  group('IterableExtensions', () {
    test('sum should calculate correctly', () {
      expect([1, 2, 3].sum, 6);
      expect([1.5, 2.5].sum, 4.0);
      expect(<int>[].sum, 0);
      expect(<double>[].sum, 0.0);
    });

    test('average should calculate correctly', () {
      expect([1, 2, 3].average, 2.0);
      expect([10, 20].average, 15.0);
      expect(<int>[].average, 0.0);
    });

    test('groupBy should group elements correctly', () {
      final list = [
        {'id': 1, 'category': 'A'},
        {'id': 2, 'category': 'B'},
        {'id': 3, 'category': 'A'},
      ];
      final grouped = list.groupBy((e) => e['category']);
      expect(grouped['A']?.length, 2);
      expect(grouped['B']?.length, 1);
    });
  });
}
