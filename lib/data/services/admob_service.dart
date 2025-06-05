// File: lib/data/services/admob_service.dart
import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/utils/app_logger.dart';
import '../../config/env_config.dart';

/// AdMob 광고 서비스
/// 전면 광고와 보상형 광고를 관리합니다.
class AdmobService {
  // Singleton instance
  static final AdmobService _instance = AdmobService._internal();
  factory AdmobService() => _instance;
  AdmobService._internal();

  // Ad Unit IDs - 환경별로 자동 설정
  static String get _interstitialAdId => EnvConfig.interstitialAdUnitId;
  static String get _rewardedAdId => EnvConfig.rewardedAdUnitId;
  
  // Ad instances
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  
  // Ad state
  bool _isInterstitialAdReady = false;
  bool _isRewardedAdReady = false;
  bool _isDisposed = false;
  bool _isInitialized = false;
  
  // Retry counters
  int _interstitialRetryCount = 0;
  int _rewardedRetryCount = 0;
  static const int _maxRetries = 3;
  
  // Getters
  bool get isInterstitialReady => _isInterstitialAdReady && !_isDisposed;
  bool get isRewardedReady => _isRewardedAdReady && !_isDisposed;
  
  /// AdMob 초기화
  Future<void> initialize() async {
    if (_isInitialized) {
      AppLogger.debug('AdMob already initialized');
      return;
    }
    
    try {
      // 초기화 전 딜레이 (앱 시작 시 안정성 향상)
      await Future.delayed(const Duration(seconds: 2));
      
      final initializationStatus = await MobileAds.instance.initialize();
      
      // 초기화 상태 로깅
      initializationStatus.adapterStatuses.forEach((key, value) {
        AppLogger.debug('Adapter status for $key: ${value.state}');
      });
      
      _isInitialized = true;
      AppLogger.debug('AdMob initialized successfully');
      
      // Request configuration 설정
      MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
          testDeviceIds: <String>[], // 테스트 기기 ID 추가 가능
        ),
      );
      
      // 초기 광고 로드 (약간의 딜레이 후)
      Future.delayed(const Duration(seconds: 1), () {
        loadInterstitialAd();
        loadRewardedAd();
      });
    } catch (e, stack) {
      AppLogger.error('Failed to initialize AdMob', e, stack);
      _isInitialized = false;
    }
  }
  
  /// 전면 광고 로드
  void loadInterstitialAd() {
    if (_isDisposed || !_isInitialized) {
      AppLogger.debug('Cannot load interstitial ad: disposed=$_isDisposed, initialized=$_isInitialized');
      return;
    }
    
    if (_interstitialRetryCount >= _maxRetries) {
      AppLogger.debug('Max retries reached for interstitial ad');
      return;
    }
    
    AppLogger.debug('Loading interstitial ad (attempt ${_interstitialRetryCount + 1})');
    
    InterstitialAd.load(
      adUnitId: _interstitialAdId,
      request: const AdRequest(
        keywords: ['game', 'tarot', 'fortune'],
        nonPersonalizedAds: false,
      ),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          if (_isDisposed) {
            ad.dispose();
            return;
          }
          
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _interstitialRetryCount = 0;  // Reset retry count
          AppLogger.debug('Interstitial ad loaded successfully');
          
          // 광고 콜백 설정
          _setupInterstitialCallbacks();
        },
        onAdFailedToLoad: (LoadAdError error) {
          AppLogger.error('Failed to load interstitial ad: ${error.message}', error);
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          _interstitialRetryCount++;
          
          // 재시도 로직
          if (!_isDisposed && _interstitialRetryCount < _maxRetries) {
            final retryDelay = Duration(seconds: 10 * _interstitialRetryCount);
            Future.delayed(retryDelay, () {
              loadInterstitialAd();
            });
          }
        },
      ),
    );
  }
  
  /// 전면 광고 콜백 설정
  void _setupInterstitialCallbacks() {
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        AppLogger.debug('Interstitial ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        AppLogger.debug('Interstitial ad dismissed');
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialAdReady = false;
        
        // 다음 광고 미리 로드
        if (!_isDisposed) {
          Future.delayed(const Duration(seconds: 2), () {
            loadInterstitialAd();
          });
        }
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        AppLogger.error('Failed to show interstitial ad: ${error.message}', error);
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialAdReady = false;
        
        // 재로드
        if (!_isDisposed) {
          Future.delayed(const Duration(seconds: 2), () {
            loadInterstitialAd();
          });
        }
      },
      onAdImpression: (InterstitialAd ad) {
        AppLogger.debug('Interstitial ad impression recorded');
      },
    );
  }
  
  /// 전면 광고 표시
  Future<void> showInterstitialAd() async {
    if (!isInterstitialReady) {
      AppLogger.debug('Interstitial ad not ready');
      // 광고가 준비되지 않았으면 다시 로드 시도
      loadInterstitialAd();
      return;
    }
    
    try {
      await _interstitialAd?.show();
      AppLogger.debug('Showing interstitial ad');
    } catch (e) {
      AppLogger.error('Error showing interstitial ad', e);
      _interstitialAd?.dispose();
      _interstitialAd = null;
      _isInterstitialAdReady = false;
      
      // 다시 로드
      loadInterstitialAd();
    }
  }
  
  /// 보상형 광고 로드
  void loadRewardedAd() {
    if (_isDisposed || !_isInitialized) {
      AppLogger.debug('Cannot load rewarded ad: disposed=$_isDisposed, initialized=$_isInitialized');
      return;
    }
    
    if (_rewardedRetryCount >= _maxRetries) {
      AppLogger.debug('Max retries reached for rewarded ad');
      return;
    }
    
    AppLogger.debug('Loading rewarded ad (attempt ${_rewardedRetryCount + 1})');
    
    RewardedAd.load(
      adUnitId: _rewardedAdId,
      request: const AdRequest(
        keywords: ['game', 'tarot', 'fortune'],
        nonPersonalizedAds: false,
      ),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          if (_isDisposed) {
            ad.dispose();
            return;
          }
          
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          _rewardedRetryCount = 0;  // Reset retry count
          AppLogger.debug('Rewarded ad loaded successfully');
        },
        onAdFailedToLoad: (LoadAdError error) {
          AppLogger.error('Failed to load rewarded ad: ${error.message}', error);
          _rewardedAd = null;
          _isRewardedAdReady = false;
          _rewardedRetryCount++;
          
          // 재시도 로직
          if (!_isDisposed && _rewardedRetryCount < _maxRetries) {
            final retryDelay = Duration(seconds: 10 * _rewardedRetryCount);
            Future.delayed(retryDelay, () {
              loadRewardedAd();
            });
          }
        },
      ),
    );
  }
  
  
  /// 보상형 광고 표시
  Future<bool> showRewardedAd() async {
    if (!isRewardedReady) {
      AppLogger.debug('Rewarded ad not ready');
      // 광고가 준비되지 않았으면 다시 로드 시도
      loadRewardedAd();
      return false;
    }
    
    // Use a Completer to properly handle the async callback
    final completer = Completer<bool>();
    bool rewarded = false;
    
    try {
      // Set up one-time callback for this specific ad show
      _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) {
          AppLogger.debug('Rewarded ad showed full screen content');
        },
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          AppLogger.debug('Rewarded ad dismissed, rewarded: $rewarded');
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdReady = false;
          
          // Complete with the reward status
          if (!completer.isCompleted) {
            completer.complete(rewarded);
          }
          
          // 다음 광고 미리 로드
          if (!_isDisposed) {
            Future.delayed(const Duration(seconds: 2), () {
              loadRewardedAd();
            });
          }
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          AppLogger.error('Failed to show rewarded ad: ${error.message}', error);
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdReady = false;
          
          // Complete with false on error
          if (!completer.isCompleted) {
            completer.complete(false);
          }
          
          // 재로드
          if (!_isDisposed) {
            Future.delayed(const Duration(seconds: 2), () {
              loadRewardedAd();
            });
          }
        },
        onAdImpression: (RewardedAd ad) {
          AppLogger.debug('Rewarded ad impression recorded');
        },
      );
      
      await _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          AppLogger.debug('User earned reward: ${reward.amount} ${reward.type}');
          rewarded = true;
        },
      );
      
      // Wait for the ad to be dismissed
      return await completer.future;
    } catch (e) {
      AppLogger.error('Error showing rewarded ad', e);
      _rewardedAd?.dispose();
      _rewardedAd = null;
      _isRewardedAdReady = false;
      
      // Complete with false on exception
      if (!completer.isCompleted) {
        completer.complete(false);
      }
      
      // 다시 로드
      loadRewardedAd();
      return false;
    }
  }
  
  /// 광고 상태 확인
  void checkAdStatus() {
    AppLogger.debug('Ad Status - Interstitial: $_isInterstitialAdReady, Rewarded: $_isRewardedAdReady');
  }
  
  /// 광고 리소스 정리
  void cleanUp() {
    AppLogger.debug('Cleaning up AdMob resources');
    
    _isDisposed = true;
    
    try {
      // 전면 광고 정리
      _interstitialAd?.dispose();
      _interstitialAd = null;
      _isInterstitialAdReady = false;
      
      // 보상형 광고 정리
      _rewardedAd?.dispose();
      _rewardedAd = null;
      _isRewardedAdReady = false;
      
      // 카운터 리셋
      _interstitialRetryCount = 0;
      _rewardedRetryCount = 0;
      
      AppLogger.debug('AdMob cleanup completed');
    } catch (e) {
      AppLogger.error('Error during AdMob cleanup', e);
    }
  }
  
  /// 리소스 해제
  void dispose() {
    cleanUp();
  }
  
  /// 서비스 재시작
  void restart() {
    if (!_isInitialized) {
      AppLogger.debug('Cannot restart - AdMob not initialized');
      return;
    }
    
    AppLogger.debug('Restarting AdMob service');
    _isDisposed = false;
    _interstitialRetryCount = 0;
    _rewardedRetryCount = 0;
    
    Future.delayed(const Duration(seconds: 1), () {
      loadInterstitialAd();
      loadRewardedAd();
    });
  }
}