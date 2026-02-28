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

    test('distinctBy should return unique elements by key', () {
      final list = [
        {'id': 1, 'name': 'A'},
        {'id': 2, 'name': 'B'},
        {'id': 3, 'name': 'A'},
      ];
      final distinct = list.distinctBy((e) => e['name']).toList();
      expect(distinct.length, 2);
      expect(distinct[0]['id'], 1);
      expect(distinct[1]['id'], 2);
    });

    test('chunked should split iterable into correctly sized chunks', () {
      final list = [1, 2, 3, 4, 5];
      final chunks = list.chunked(2).toList();
      expect(chunks.length, 3);
      expect(chunks[0], [1, 2]);
      expect(chunks[1], [3, 4]);
      expect(chunks[2], [5]);
    });

    test('chunked should throw error for non-positive size', () {
      expect(() => [1, 2].chunked(0).toList(), throwsArgumentError);
      expect(() => [1, 2].chunked(-1).toList(), throwsArgumentError);
    });

    test('random should return an element from the list', () {
      final list = [1, 2, 3, 4, 5];
      final randomElement = list.random;
      expect(list.contains(randomElement), true);
    });

    test('random should throw error for empty list', () {
      expect(() => <int>[].random, throwsStateError);
    });

    test('sumBy should calculate sum correctly using selector', () {
      final list = [
        {'value': 10},
        {'value': 20},
        {'value': 30},
      ];
      expect(list.sumBy((e) => e['value'] as num), 60);
      expect(<Map<String, int>>[].sumBy((e) => e['value'] as num), 0);
    });

    test('averageBy should calculate average correctly using selector', () {
      final list = [
        {'value': 10},
        {'value': 20},
        {'value': 30},
      ];
      expect(list.averageBy((e) => e['value'] as num), 20.0);
      expect(<Map<String, int>>[].averageBy((e) => e['value'] as num), 0.0);
    });
  });
}
