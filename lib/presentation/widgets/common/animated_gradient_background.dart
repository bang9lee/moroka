import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// 애니메이션 그라데이션 배경 위젯
/// 메모리 효율적인 파티클 시스템과 그라데이션 애니메이션 제공
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<List<Color>>? gradients;
  final Duration animationDuration;
  final bool enableParticles;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.gradients,
    this.animationDuration = const Duration(seconds: 10),
    this.enableParticles = true,
  });

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  AnimationController? _particleController;
  late Animation<double> _gradientAnimation;
  
  int _currentGradientIndex = 0;
  List<Particle>? _particles;
  
  late final List<List<Color>> _gradientList;

  @override
  void initState() {
    super.initState();
    
    _gradientList = widget.gradients ?? [
      AppColors.darkGradient,
      AppColors.bloodGradient,
      AppColors.mysticGradient,
    ];
    
    _initializeAnimations();
    
    if (widget.enableParticles) {
      _initializeParticles();
    }
  }

  void _initializeAnimations() {
    _gradientController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _gradientAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOut,
    ));
    
    _gradientController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentGradientIndex = (_currentGradientIndex + 1) % _gradientList.length;
        });
        _gradientController.forward(from: 0);
      }
    });
    
    _gradientController.forward();
  }

  void _initializeParticles() {
    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _particles = List<Particle>.generate(
      AppConstants.maxParticles,
      (_) => Particle.random(),
    );
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _particleController?.dispose();
    _particles?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated gradient background
        AnimatedBuilder(
          animation: _gradientAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _gradientList[_currentGradientIndex],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            );
          },
        ),
        
        // Particle system (if enabled)
        if (widget.enableParticles && _particles != null && _particleController != null)
          AnimatedBuilder(
            animation: _particleController!,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  particles: _particles!,
                  animation: _particleController!.value,
                ),
                size: Size.infinite,
              );
            },
          ),
        
        // Overlay gradient for depth
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                Colors.transparent,
                AppColors.blackOverlay40,
                AppColors.blackOverlay60,
              ],
              stops: [0.0, 0.7, 1.0],
            ),
          ),
        ),
        
        // Child widget
        widget.child,
      ],
    );
  }
}

/// 파티클 데이터 클래스
class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;
  final double initialX;
  
  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  }) : initialX = x;
  
  /// 랜덤 파티클 생성
  factory Particle.random() {
    final random = math.Random();
    final x = random.nextDouble();
    return Particle(
      x: x,
      y: random.nextDouble(),
      size: random.nextDouble() * 3 + 1,
      speed: random.nextDouble() * 0.02 + 0.01,
      opacity: random.nextDouble() * 0.3 + 0.1,
    );
  }
  
  /// 파티클 위치 업데이트
  void update() {
    y -= speed;
    if (y < -0.1) {
      y = 1.1;
      x = initialX + (math.Random().nextDouble() - 0.5) * 0.1;
      x = x.clamp(0.0, 1.0);
    }
  }
}

/// 파티클 렌더링을 위한 CustomPainter
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  static final _paint = Paint()..style = PaintingStyle.fill;
  
  const ParticlePainter({
    required this.particles,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      particle.update();
      
      final opacity = (particle.opacity * 255).toInt();
      _paint.color = Color.fromARGB(opacity, 255, 255, 255);
      
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}