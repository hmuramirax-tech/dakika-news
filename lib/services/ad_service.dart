import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dakika/config.dart';

/// Ad service — manages AdMob banner and interstitial ads.
/// Free tier: max 5 ads per session. Premium: no ads.
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  int _adCount = 0;
  static const int _maxAdsPerSession = 5;

  // Test ad unit IDs — replace with production IDs
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  bool get canShowAd => _adCount < _maxAdsPerSession;

  /// Initialize the ad SDK.
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  /// Load a banner ad.
  BannerAd loadBannerAd() {
    final bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
    bannerAd.load();
    return bannerAd;
  }

  /// Load an interstitial ad.
  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          debugPrint('Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Show the interstitial ad if loaded.
  void showInterstitialAd() {
    if (_interstitialAd != null && canShowAd) {
      _interstitialAd!.show();
      _adCount++;
      _interstitialAd = null;
      // Pre-load the next one
      loadInterstitialAd();
    }
  }

  /// Get the current ad count for the session.
  int get adCount => _adCount;

  /// Reset ad count (call on app start).
  void resetAdCount() {
    _adCount = 0;
  }

  /// Dispose of all ads.
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }
}
