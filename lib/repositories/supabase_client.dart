import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dakika/config.dart';

/// Singleton Supabase client.
class SupabaseClientService {
  static SupabaseClient? _client;

  static SupabaseClient get client {
    if (_client == null) {
      throw StateError('Supabase not initialized. Call init() first.');
    }
    return _client!;
  }

  static Future<void> init() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  static bool get isInitialized => _client != null;
}
