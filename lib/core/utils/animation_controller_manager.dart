import 'package:flutter/material.dart';

/// AnimationController 메모리 최적화를 위한 매니저 클래스
/// - 애니메이션 컨트롤러 풀링
/// - 앱 상태에 따른 자동 일시정지/재개
/// - 메모리 누수 방지
class AnimationControllerManager with WidgetsBindingObserver {
  static final AnimationControllerManager _instance = AnimationControllerManager._internal();
  factory AnimationControllerManager() => _instance;
  AnimationControllerManager._internal();

  // 활성 컨트롤러 관리
  final Map<String, AnimationController> _activeControllers = {};
  final Map<String, AnimationStatusListener> _statusListeners = {};
  
  // 재사용 가능한 컨트롤러 풀
  final List<AnimationController> _controllerPool = [];
  static const int _maxPoolSize = 10;
  
  // 앱 상태
  AppLifecycleState? _appLifecycleState;
  
  /// 매니저 초기화
  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }
  
  /// 매니저 정리
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeAllControllers();
  }
  
  /// 애니메이션 컨트롤러 생성 또는 재사용
  AnimationController createController({
    required String tag,
    required TickerProvider vsync,
    required Duration duration,
    Duration? reverseDuration,
    double? value,
    double lowerBound = 0.0,
    double upperBound = 1.0,
    AnimationBehavior animationBehavior = AnimationBehavior.normal,
  }) {
    // 기존 컨트롤러가 있으면 정리
    if (_activeControllers.containsKey(tag)) {
      disposeController(tag);
    }
    
    AnimationController controller;
    
    // 풀에서 재사용 가능한 컨트롤러 찾기
    if (_controllerPool.isNotEmpty) {
      controller = _controllerPool.removeLast();
      controller.duration = duration;
      controller.reverseDuration = reverseDuration;
      controller.value = value ?? lowerBound;
    } else {
      // 새 컨트롤러 생성
      controller = AnimationController(
        vsync: vsync,
        duration: duration,
        reverseDuration: reverseDuration,
        value: value,
        lowerBound: lowerBound,
        upperBound: upperBound,
        animationBehavior: animationBehavior,
      );
    }
    
    _activeControllers[tag] = controller;
    
    // 앱이 백그라운드 상태면 자동 일시정지
    if (_appLifecycleState == AppLifecycleState.paused ||
        _appLifecycleState == AppLifecycleState.hidden) {
      controller.stop();
    }
    
    return controller;
  }
  
  /// 반복 애니메이션 컨트롤러 생성
  AnimationController createRepeatingController({
    required String tag,
    required TickerProvider vsync,
    required Duration duration,
    bool reverse = false,
  }) {
    final controller = createController(
      tag: tag,
      vsync: vsync,
      duration: duration,
    );
    
    // 상태 리스너 추가
    void statusListener(AnimationStatus status) {
      if (_appLifecycleState == AppLifecycleState.resumed) {
        if (status == AnimationStatus.completed) {
          if (reverse) {
            controller.reverse();
          } else {
            controller.forward(from: 0.0);
          }
        } else if (reverse && status == AnimationStatus.dismissed) {
          controller.forward();
        }
      }
    }
    
    _statusListeners[tag] = statusListener;
    controller.addStatusListener(statusListener);
    
    // 초기 실행
    if (_appLifecycleState == AppLifecycleState.resumed) {
      controller.forward();
    }
    
    return controller;
  }
  
  /// 특정 컨트롤러 가져오기
  AnimationController? getController(String tag) {
    return _activeControllers[tag];
  }
  
  /// 특정 컨트롤러 정리
  void disposeController(String tag) {
    final controller = _activeControllers.remove(tag);
    if (controller != null) {
      // 상태 리스너 제거
      final listener = _statusListeners.remove(tag);
      if (listener != null) {
        controller.removeStatusListener(listener);
      }
      
      controller.stop();
      controller.reset();
      
      // 풀이 가득 차지 않았으면 재사용을 위해 저장
      if (_controllerPool.length < _maxPoolSize) {
        _controllerPool.add(controller);
      } else {
        controller.dispose();
      }
    }
  }
  
  /// 모든 컨트롤러 정리
  void _disposeAllControllers() {
    // 활성 컨트롤러 정리
    for (final controller in _activeControllers.values) {
      controller.dispose();
    }
    _activeControllers.clear();
    _statusListeners.clear();
    
    // 풀 정리
    for (final controller in _controllerPool) {
      controller.dispose();
    }
    _controllerPool.clear();
  }
  
  /// 모든 애니메이션 일시정지
  void pauseAll() {
    for (final controller in _activeControllers.values) {
      if (controller.isAnimating) {
        controller.stop();
      }
    }
  }
  
  /// 모든 애니메이션 재개
  void resumeAll() {
    for (final entry in _activeControllers.entries) {
      final controller = entry.value;
      final tag = entry.key;
      
      // 반복 애니메이션이면 재시작
      if (_statusListeners.containsKey(tag)) {
        controller.forward();
      }
    }
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;
    
    switch (state) {
      case AppLifecycleState.resumed:
        resumeAll();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        pauseAll();
        break;
      case AppLifecycleState.inactive:
        // iOS에서 다른 앱으로 전환 시
        break;
    }
  }
}

/// AnimationController를 사용하는 위젯을 위한 Mixin
mixin ManagedAnimationControllerMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  final AnimationControllerManager _manager = AnimationControllerManager();
  final List<String> _controllerTags = [];
  
  /// 관리되는 애니메이션 컨트롤러 생성
  AnimationController createManagedController({
    required String tag,
    required Duration duration,
    Duration? reverseDuration,
    double? value,
  }) {
    _controllerTags.add(tag);
    return _manager.createController(
      tag: tag,
      vsync: this,
      duration: duration,
      reverseDuration: reverseDuration,
      value: value,
    );
  }
  
  /// 관리되는 반복 애니메이션 컨트롤러 생성
  AnimationController createManagedRepeatingController({
    required String tag,
    required Duration duration,
    bool reverse = false,
  }) {
    _controllerTags.add(tag);
    return _manager.createRepeatingController(
      tag: tag,
      vsync: this,
      duration: duration,
      reverse: reverse,
    );
  }
  
  @override
  void dispose() {
    // 이 위젯이 생성한 모든 컨트롤러 정리
    for (final tag in _controllerTags) {
      _manager.disposeController(tag);
    }
    _controllerTags.clear();
    super.dispose();
  }
}