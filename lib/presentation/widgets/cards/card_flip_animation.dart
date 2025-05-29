import 'package:flutter/material.dart';
import 'dart:math' as math;

class CardFlipAnimation extends StatelessWidget {
  final Widget front;
  final Widget back;
  final AnimationController controller;
  final Duration duration;

  const CardFlipAnimation({
    super.key,
    required this.front,
    required this.back,
    required this.controller,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final isShowingFront = controller.value < 0.5;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(controller.value * math.pi),
          child: isShowingFront
              ? front
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: back,
                ),
        );
      },
    );
  }
}