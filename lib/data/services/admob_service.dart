import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService {
  // Test Ad IDs (Replace with your actual Ad IDs in production)
  static const String _testInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewardedAdId = 'ca-app-pub-3940256099942544/5224354917';
  
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  
  bool _isInterstitialAdReady = false;
  bool _isRewardedAdReady = false;
  
  // Initialize ads
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }
  
  // Load Interstitial Ad
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _testInterstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialAdReady = false;
              loadInterstitialAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isInterstitialAdReady = false;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdReady = false;
        },
      ),
    );
  }
  
  // Show Interstitial Ad
  void showInterstitialAd() {
    if (_isInterstitialAdReady) {
      _interstitialAd?.show();
    }
  }
  
  // Load Rewarded Ad
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _testRewardedAdId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isRewardedAdReady = false;
              loadRewardedAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isRewardedAdReady = false;
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isRewardedAdReady = false;
        },
      ),
    );
  }
  
  // Show Rewarded Ad
  Future<bool> showRewardedAd() async {
    if (!_isRewardedAdReady) return false;
    
    bool rewarded = false;
    await _rewardedAd?.show(
      onUserEarnedReward: (ad, reward) {
        rewarded = true;
      },
    );
    
    return rewarded;
  }
  
  // Check if ads are ready
  bool get isInterstitialReady => _isInterstitialAdReady;
  bool get isRewardedReady => _isRewardedAdReady;
  
  // Dispose
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}