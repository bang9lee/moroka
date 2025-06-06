# 프로덕션 배포 전 수정사항

## 1. 🔴 **치명적 보안 문제 - API 키 노출**

### 문제점
- `lib/firebase_options.dart` 파일에 Firebase API 키가 하드코딩되어 있음
- 이 파일이 Git에 커밋되어 노출됨

### 해결방법

#### 1.1 환경변수 설정
```bash
# .env 파일 생성
cat > .env << 'EOF'
# Firebase Web
FIREBASE_WEB_API_KEY=your_web_api_key
FIREBASE_WEB_APP_ID=your_web_app_id
FIREBASE_WEB_MESSAGING_SENDER_ID=your_messaging_sender_id
FIREBASE_WEB_PROJECT_ID=your_project_id
FIREBASE_WEB_AUTH_DOMAIN=your_auth_domain
FIREBASE_WEB_STORAGE_BUCKET=your_storage_bucket

# Firebase Android
FIREBASE_ANDROID_API_KEY=your_android_api_key
FIREBASE_ANDROID_APP_ID=your_android_app_id

# Firebase iOS
FIREBASE_IOS_API_KEY=your_ios_api_key
FIREBASE_IOS_APP_ID=your_ios_app_id
FIREBASE_IOS_BUNDLE_ID=your_bundle_id
EOF

# .gitignore에 추가
echo ".env" >> .gitignore
echo "lib/firebase_options.dart" >> .gitignore
```

#### 1.2 flutter_dotenv 패키지 추가
```bash
flutter pub add flutter_dotenv
```

#### 1.3 main.dart 수정
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 환경변수 로드
  await dotenv.load(fileName: ".env");
  
  // 기존 초기화 코드...
}
```

## 2. 🟡 **메모리 누수 수정**

### 2.1 AnimationController 수정
파일: `lib/presentation/widgets/common/animated_gradient_background.dart`

```dart
class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground> 
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  AnimationController? _particleController;
  late Animation<double> _gradientAnimation;
  List<Particle>? _particles;
  
  // 리스너를 별도 메서드로 분리
  void Function(AnimationStatus)? _statusListener;
  
  @override
  void initState() {
    super.initState();
    
    // 리스너 초기화
    _statusListener = (status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _currentGradientIndex = (_currentGradientIndex + 1) % _gradientList.length;
        });
        if (mounted) {
          _gradientController.forward(from: 0);
        }
      }
    };
    
    _initializeAnimations();
    if (widget.showParticles) {
      _initializeParticles();
    }
  }
  
  @override
  void dispose() {
    // 리스너 제거
    if (_statusListener != null) {
      _gradientController.removeStatusListener(_statusListener!);
    }
    _gradientController.dispose();
    _particleController?.dispose();
    _particles?.clear();
    super.dispose();
  }
}
```

### 2.2 이미지 캐시 메모리 제한 설정
파일: `lib/data/services/cache_service.dart`

```dart
class CacheService {
  static const int maxMemoryCacheSize = 100 * 1024 * 1024; // 100MB
  static const Duration cacheDuration = Duration(days: 7);
  
  late DefaultCacheManager _imageCacheManager;
  
  CacheService() {
    _imageCacheManager = DefaultCacheManager();
    
    // 메모리 캐시 크기 제한
    PaintingBinding.instance.imageCache.maximumSizeBytes = maxMemoryCacheSize;
    PaintingBinding.instance.imageCache.maximumSize = 100; // 최대 100개 이미지
  }
}
```

### 2.3 Completer 에러 처리
파일: `lib/data/services/admob_service.dart`

```dart
Future<bool> showRewardedAd() async {
  final completer = Completer<bool>();
  
  try {
    // 기존 코드...
  } catch (e) {
    // 모든 에러 경로에서 completer 완료 보장
    if (!completer.isCompleted) {
      completer.complete(false);
    }
    rethrow;
  }
  
  // 타임아웃 추가
  return completer.future.timeout(
    const Duration(seconds: 30),
    onTimeout: () => false,
  );
}
```

## 3. 🟡 **성능 개선**

### 3.1 불필요한 rebuild 제거
파일: `lib/presentation/widgets/common/animated_gradient_background.dart`

```dart
// AnimatedBuilder 사용으로 변경
@override
Widget build(BuildContext context) {
  return Stack(
    children: [
      // AnimatedBuilder로 감싸서 필요한 부분만 rebuild
      AnimatedBuilder(
        animation: _gradientAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _getAnimatedColors(),
              ),
            ),
          );
        },
      ),
      // 파티클은 별도로 처리
      if (widget.showParticles && _particleController != null)
        AnimatedBuilder(
          animation: _particleController!,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlePainter(
                particles: _particles!,
                progress: _particleController!.value,
              ),
              size: Size.infinite,
            );
          },
        ),
    ],
  );
}
```

### 3.2 ParticlePainter shouldRepaint 수정
```dart
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final double _lastProgress;
  
  ParticlePainter({
    required this.particles,
    required this.progress,
  }) : _lastProgress = progress;
  
  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    // 실제 변경사항이 있을 때만 다시 그리기
    return oldDelegate._lastProgress != progress ||
           oldDelegate.particles.length != particles.length;
  }
}
```

### 3.3 리스트 위젯에 Key 추가
파일: `lib/presentation/screens/history/history_screen.dart`

```dart
ListView.builder(
  itemCount: readings.length,
  itemBuilder: (context, index) {
    final reading = readings[index];
    return HistoryItemWidget(
      key: ValueKey(reading.id), // Key 추가
      reading: reading,
      onTap: () => _viewReading(context, reading),
      onDelete: () => _deleteReading(context, ref, reading.id),
    );
  },
)
```

## 4. 🟡 **추가 보안 강화**

### 4.1 Certificate Pinning (선택사항)
```yaml
# pubspec.yaml
dependencies:
  dio_certificate_pinning: ^5.0.0
```

### 4.2 앱 무결성 검증 (선택사항)
```dart
// Android: Play Integrity API
// iOS: App Attest
```

## 5. 📝 **배포 체크리스트**

- [ ] `.env` 파일 생성 및 API 키 설정
- [ ] `.gitignore` 업데이트
- [ ] `firebase_options.dart` Git에서 제거
- [ ] AnimationController 메모리 누수 수정
- [ ] 이미지 캐시 메모리 제한 설정
- [ ] ParticlePainter shouldRepaint 수정
- [ ] 리스트 위젯에 Key 추가
- [ ] 프로덕션 빌드 테스트
- [ ] Firebase Functions 배포
- [ ] 앱 버전 업데이트

## 6. 🚀 **배포 명령어**

```bash
# 1. 클린 빌드
flutter clean
flutter pub get

# 2. 코드 생성
flutter gen-l10n
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Android 빌드 (AAB)
flutter build appbundle --release

# 4. iOS 빌드
flutter build ios --release

# 5. Functions 배포
cd functions && firebase deploy --only functions

# 6. Play Store / App Store 업로드
```