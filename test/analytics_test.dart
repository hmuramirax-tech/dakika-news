import 'package:flutter_test/flutter_test.dart';
import 'package:dakika/services/analytics_service.dart';

void main() {
  group('Analytics Service', () {
    test('AnalyticsService can be instantiated', () {
      final service = AnalyticsService();
      expect(service, isNotNull);
    });
  });
}
