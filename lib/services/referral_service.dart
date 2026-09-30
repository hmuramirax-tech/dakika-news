import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dakika/repositories/supabase_client.dart';

/// Service for managing referral program.
class ReferralService {
  final SupabaseClient _client = SupabaseClientService.client;

  /// Generate a unique referral code for the current user.
  Future<String> generateReferralCode() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Generate a short, memorable code from user ID
    final code = _generateCodeFromUserId(userId);

    // Store in profiles table
    await _client.from('profiles').update({
      'referral_code': code,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);

    return code;
  }

  /// Get current user's referral code.
  Future<String?> getMyReferralCode() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from('profiles')
        .select('referral_code')
        .eq('id', userId)
        .maybeSingle();

    return response?['referral_code'];
  }

  /// Apply a referral code (called during onboarding).
  Future<bool> applyReferralCode(String code) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Find the referrer
    final referrer = await _client
        .from('profiles')
        .select('id')
        .eq('referral_code', code)
        .maybeSingle();

    if (referrer == null) return false;

    // Can't refer yourself
    if (referrer['id'] == userId) return false;

    // Record the referral
    await _client.from('referrals').insert({
      'referrer_id': referrer['id'],
      'referred_id': userId,
      'status': 'pending',
      'reward_given': false,
    });

    return true;
  }

  /// Get referral stats for current user.
  Future<Map<String, dynamic>> getReferralStats() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client
        .from('referrals')
        .select('id, status, reward_given, created_at')
        .eq('referrer_id', userId);

    final referrals = response as List;
    final total = referrals.length;
    final completed = referrals.where((r) => r['status'] == 'completed').length;
    final pending = referrals.where((r) => r['status'] == 'pending').length;
    final rewardsGiven = referrals.where((r) => r['reward_given'] == true).length;

    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'rewards_given': rewardsGiven,
      'referral_link': 'https://onenews.app/ref/${await getMyReferralCode() ?? ''}',
    };
  }

  /// Get list of referred users.
  Future<List<Map<String, dynamic>>> getReferredUsers() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client
        .from('referrals')
        .select('id, status, created_at, profiles(display_name, phone)')
        .eq('referrer_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  String _generateCodeFromUserId(String userId) {
    // Take first 8 characters of userId and convert to base36
    final hash = userId.hashCode.abs();
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    var code = '';
    var n = hash;

    for (var i = 0; i < 6; i++) {
      code += chars[n % chars.length];
      n = n ~/ chars.length;
    }

    return code;
  }
}
