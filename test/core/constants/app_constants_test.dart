import 'package:flutter_test/flutter_test.dart';
import 'package:art_of_evolve/src/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('appName is correct', () {
      expect(AppConstants.appName, 'Art of Evolve');
    });

    test('fontFamily is correct', () {
      expect(AppConstants.fontFamily, 'Plus Jakarta Sans');
    });
  });
}
