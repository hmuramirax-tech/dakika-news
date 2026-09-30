import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dakika/repositories/supabase_client.dart';

/// Subscription service — handles mobile money payments via Supabase Edge Functions.
class SubscriptionService {
  final SupabaseClient _client = SupabaseClientService.client;

  /// Initiate a mobile money payment.
  /// Returns a payment URL or transaction ID.
  Future<PaymentResult> initiatePayment({
    required String provider, // 'mtn' or 'airtel'
    required String phoneNumber,
  }) async {
    try {
      final response = await _client.functions.invoke(
        'process-payment',
        body: {
          'provider': provider,
          'phone_number': phoneNumber,
          'amount': 300, // Rwf 300
          'currency': 'RWF',
        },
      );

      return PaymentResult.fromJson(response.data);
    } catch (e) {
      return PaymentResult(
        success: false,
        errorMessage: 'Payment initiation failed: $e',
      );
    }
  }

  /// Check payment status.
  Future<PaymentStatus> checkPaymentStatus(String transactionId) async {
    try {
      final response = await _client.functions.invoke(
        'payment-callback',
        body: {'transaction_id': transactionId},
      );

      return PaymentStatus.fromJson(response.data);
    } catch (e) {
      return PaymentStatus(
        transactionId: transactionId,
        status: 'error',
        errorMessage: e.toString(),
      );
    }
  }

  /// Get current subscription status for the user.
  Future<SubscriptionInfo?> getCurrentSubscription() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final response = await _client
          .from('subscriptions')
          .select()
          .eq('user_id', userId)
          .eq('payment_status', 'completed')
          .maybeSingle();

      if (response == null) return null;

      return SubscriptionInfo.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Cancel subscription.
  Future<bool> cancelSubscription() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      await _client
          .from('subscriptions')
          .update({'payment_status': 'cancelled'})
          .eq('user_id', userId);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? paymentUrl;
  final String? errorMessage;

  PaymentResult({
    required this.success,
    this.transactionId,
    this.paymentUrl,
    this.errorMessage,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
      success: json['success'] ?? false,
      transactionId: json['transaction_id'],
      paymentUrl: json['payment_url'],
      errorMessage: json['error_message'],
    );
  }
}

class PaymentStatus {
  final String transactionId;
  final String status; // 'pending', 'completed', 'failed'
  final String? errorMessage;

  PaymentStatus({
    required this.transactionId,
    required this.status,
    this.errorMessage,
  });

  factory PaymentStatus.fromJson(Map<String, dynamic> json) {
    return PaymentStatus(
      transactionId: json['transaction_id'] ?? '',
      status: json['status'] ?? 'unknown',
      errorMessage: json['error_message'],
    );
  }
}

class SubscriptionInfo {
  final String id;
  final String tier;
  final String paymentStatus;
  final DateTime? startDate;
  final DateTime? endDate;

  SubscriptionInfo({
    required this.id,
    required this.tier,
    required this.paymentStatus,
    this.startDate,
    this.endDate,
  });

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfo(
      id: json['id'],
      tier: json['tier'] ?? 'free',
      paymentStatus: json['payment_status'] ?? 'none',
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
    );
  }

  bool get isActive => paymentStatus == 'completed';
}
