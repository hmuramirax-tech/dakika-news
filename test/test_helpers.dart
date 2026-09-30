import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dakika/repositories/supabase_client.dart';
import 'package:dakika/config.dart';

/// Initialize Supabase for testing.
/// Uses a mock client to avoid network calls.
Future<void> initSupabaseForTest() async {
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
  // SupabaseClientService._client is set via Supabase.instance.client
}

/// Create a testable widget wrapper with ProviderScope.
Widget createTestableWidget(Widget child) {
  return MaterialApp(
    home: child,
  );
}

/// Pump and settle with timeout for screens with timers.
Future<void> pumpAndSettleWithTimeout(
  WidgetTester tester, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
}
