import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dakika/repositories/supabase_client.dart';

/// Repository for authentication operations.
class AuthRepository {
  final SupabaseClient _client = SupabaseClientService.client;

  /// Sign in with phone number (sends OTP).
  Future<void> signInWithPhone(String phone) async {
    await _client.auth.signInWithOtp(phone: phone);
  }

  /// Verify OTP code.
  Future<AuthResponse> verifyOtp(String phone, String token) async {
    return await _client.auth.verifyOtp(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  /// Sign out.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Get current user.
  User? get currentUser => _client.auth.currentUser;

  /// Check if user is signed in.
  bool get isSignedIn => _client.auth.currentUser != null;

  /// Get auth state changes stream.
  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;
}
