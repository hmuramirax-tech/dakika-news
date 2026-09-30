import 'package:flutter_test/flutter_test.dart';
import 'package:dakika/repositories/search_repository.dart';

void main() {
  group('Search Repository', () {
    test('SearchRepository can be instantiated', () {
      final repo = SearchRepository();
      expect(repo, isNotNull);
    });
  });
}
