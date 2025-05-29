import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/app_colors.dart';

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
  late AnimationController _controller;
  late AnimationController _particleController;
  
  int _currentGradientIndex = 0;
  final List<Particle> _particles = [];
  
  late final List<List<Color>> _gradientList;

  @override
  void initState() {
    super.initState();
    
    _gradientList = widget.gradients ?? [
      AppColors.darkGradient,
      AppColors.bloodGradient,
      AppColors.mysticGradient,
    ];
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentGradientIndex = (_currentGradientIndex + 1) % _gradientList.length;
        });
        _controller.forward(from: 0);
      }
    });
    
    _controller.forward();
    
    if (widget.enableParticles) {
      _generateParticles();
    }
  }

  void _generateParticles() {
    final random = math.Random();
    for (int i = 0; i < 20; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 3 + 1,
          speed: random.nextDouble() * 0.02 + 0.01,
          opacity: random.nextDouble() * 0.3 + 0.1,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _gradientList[_currentGradientIndex],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
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

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;

  ParticlePainter({
    required this.particles,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    for (var particle in particles) {
      particle.y -= particle.speed;
      if (particle.y < -0.1) {
        particle.y = 1.1;
        particle.x = math.Random().nextDouble();
      }
      
      final opacity = (particle.opacity * 255).toInt();
      paint.color = Color.fromARGB(opacity, 255, 255, 255);
      
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}