import '../services/admob_service.dart';

class AdRepository {
  final AdmobService _admobService;
  
  AdRepository(this._admobService);
  
  Future<void> initializeAds() async {
    await _admobService.initialize();
    _admobService.loadInterstitialAd();
    _admobService.loadRewardedAd();
  }
  
  void showInterstitialAd() {
    _admobService.showInterstitialAd();
  }
  
  Future<bool> showRewardedAd() async {
    return await _admobService.showRewardedAd();
  }
  
  bool get isInterstitialReady => _admobService.isInterstitialReady;
  bool get isRewardedReady => _admobService.isRewardedReady;
  
  void preloadAds() {
    if (!_admobService.isInterstitialReady) {
      _admobService.loadInterstitialAd();
    }
    if (!_admobService.isRewardedReady) {
      _admobService.loadRewardedAd();
    }
  }
}