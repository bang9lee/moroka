import 'package:flutter/material.dart';

import '../../core/utils/app_logger.dart';
import '../services/admob_service.dart';

/// 광고 리포지토리
/// AdMob 서비스를 추상화하고 광고 관련 비즈니스 로직을 처리합니다.
class AdRepository {
  final AdmobService _admobService;
  
  // 광고 표시 카운터
  int _interstitialShowCount = 0;
  int _rewardedShowCount = 0;
  
  AdRepository(this._admobService);
  
  /// 광고 초기화
  Future<void> initializeAds() async {
    try {
      AppLogger.debug('Initializing ads in repository');
      await _admobService.initialize();
      
      // 초기 광고 로드
      _admobService.loadInterstitialAd();
      _admobService.loadRewardedAd();
      
      AppLogger.debug('Ads initialized successfully in repository');
    } catch (e) {
      AppLogger.error('Failed to initialize ads in repository', e);
      // 광고 초기화 실패해도 앱은 계속 실행
    }
  }
  
  /// 전면 광고 표시
  /// @param force 강제 표시 여부 (기본값: false)
  Future<void> showInterstitialAd({bool force = false}) async {
    try {
      // 광고가 준비되지 않았으면 건너뛰기
      if (!_admobService.isInterstitialReady) {
        AppLogger.debug('Interstitial ad not ready, skipping');
        preloadAds();
        return;
      }
      
      // 수정: force가 true이거나, 결과 채팅 화면에서는 항상 광고 표시
      // 기존 로직 제거하고 바로 표시
      
      AppLogger.debug('Showing interstitial ad');
      await _admobService.showInterstitialAd();
      _interstitialShowCount++;
      
      // 다음 광고 미리 로드
      Future.delayed(const Duration(seconds: 2), () {
        preloadAds();
      });
    } catch (e) {
      AppLogger.error('Failed to show interstitial ad', e);
    }
  }
  
  /// 보상형 광고 표시
  /// @param onRewarded 보상을 받았을 때 실행할 콜백
  /// @return 광고 표시 성공 여부
  Future<bool> showRewardedAd({VoidCallback? onRewarded}) async {
    try {
      // 광고가 준비되지 않았으면 false 반환
      if (!_admobService.isRewardedReady) {
        AppLogger.debug('Rewarded ad not ready');
        preloadAds();
        return false;
      }
      
      AppLogger.debug('Showing rewarded ad');
      final rewarded = await _admobService.showRewardedAd();
      
      if (rewarded) {
        _rewardedShowCount++;
        AppLogger.debug('User earned reward (total: $_rewardedShowCount)');
        // 보상 콜백 실행
        onRewarded?.call();
      }
      
      // 다음 광고 미리 로드
      Future.delayed(const Duration(seconds: 2), () {
        preloadAds();
      });
      
      return rewarded;
    } catch (e) {
      AppLogger.error('Failed to show rewarded ad', e);
      return false;
    }
  }
  
  /// 광고 준비 상태 확인
  bool get isInterstitialReady => _admobService.isInterstitialReady;
  bool get isRewardedReady => _admobService.isRewardedReady;
  
  /// 광고 미리 로드
  void preloadAds() {
    AppLogger.debug('Preloading ads');
    
    if (!_admobService.isInterstitialReady) {
      _admobService.loadInterstitialAd();
    }
    
    if (!_admobService.isRewardedReady) {
      _admobService.loadRewardedAd();
    }
  }
  
  /// 광고 정리 (로그아웃 시 호출)
  void cleanUp() {
    AppLogger.debug('Cleaning up ad repository');
    
    // 카운터 초기화
    _interstitialShowCount = 0;
    _rewardedShowCount = 0;
    
    // AdMob 서비스 정리
    _admobService.cleanUp();
  }
  
  /// 광고 서비스 재시작
  void restart() {
    AppLogger.debug('Restarting ad repository');
    
    // 카운터는 유지
    _admobService.restart();
  }
  
  /// 리소스 해제
  void dispose() {
    cleanUp();
    _admobService.dispose();
  }
  
  /// 통계 정보 가져오기
  Map<String, dynamic> getStatistics() {
    return {
      'interstitial_shown': _interstitialShowCount,
      'rewarded_shown': _rewardedShowCount,
      'interstitial_ready': _admobService.isInterstitialReady,
      'rewarded_ready': _admobService.isRewardedReady,
    };
  }
}