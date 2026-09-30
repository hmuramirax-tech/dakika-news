import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dakika/models/models.dart';
import 'package:dakika/repositories/supabase_client.dart';

/// Repository for digest-related database operations.
class DigestRepository {
  final SupabaseClient _client = SupabaseClientService.client;

  /// Get the latest digest for a specific period.
  Future<Digest?> getLatestDigest(String period) async {
    final today = DateTime.now();
    final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final response = await _client
        .from('digests')
        .select()
        .eq('date', dateStr)
        .eq('period', period)
        .order('created_at', ascending: false)
        .maybeSingle();

    if (response == null) return null;
    return Digest.fromJson(response);
  }

  /// Get digest for a specific date and period.
  Future<Digest?> getDigest(DateTime date, String period) async {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final response = await _client
        .from('digests')
        .select()
        .eq('date', dateStr)
        .eq('period', period)
        .maybeSingle();

    if (response == null) return null;
    return Digest.fromJson(response);
  }

  /// Get all digests for a date.
  Future<List<Digest>> getDigestsForDate(DateTime date) async {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final response = await _client
        .from('digests')
        .select()
        .eq('date', dateStr)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Digest.fromJson(json))
        .toList();
  }
}
