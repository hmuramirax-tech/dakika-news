import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dakika/models/models.dart';
import 'package:dakika/repositories/supabase_client.dart';

/// Repository for user profile operations.
class ProfileRepository {
  final SupabaseClient _client = SupabaseClientService.client;

  /// Get current user's profile.
  Future<Profile?> getCurrentProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return Profile.fromJson(response);
  }

  /// Create or update profile.
  Future<void> upsertProfile({
    String? phone,
    String? displayName,
    String? language,
    String? displayDensity,
    bool? dataSaver,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final data = <String, dynamic>{
      'id': userId,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (phone != null) data['phone'] = phone;
    if (displayName != null) data['display_name'] = displayName;
    if (language != null) data['language'] = language;
    if (displayDensity != null) data['display_density'] = displayDensity;
    if (dataSaver != null) data['data_saver'] = dataSaver;

    await _client.from('profiles').upsert(data);
  }

  /// Update subscription tier.
  Future<void> updateSubscriptionTier(String tier) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _client.from('profiles').update({
      'subscription_tier': tier,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }

  /// Update display density preference.
  Future<void> updateDisplayDensity(String density) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _client.from('profiles').update({
      'display_density': density,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }
}
