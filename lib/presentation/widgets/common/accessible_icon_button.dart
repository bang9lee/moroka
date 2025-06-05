import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 접근성이 개선된 아이콘 버튼 위젯
/// 시맨틱 라벨과 적절한 터치 영역을 제공
class AccessibleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final Color? color;
  final double size;
  final EdgeInsetsGeometry padding;
  final String? tooltip;
  final bool excludeFromSemantics;

  const AccessibleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.color,
    this.size = 24.0,
    this.padding = const EdgeInsets.all(8.0),
    this.tooltip,
    this.excludeFromSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    // 최소 터치 영역 확보 (48x48)
    final minTouchTarget = Size(
      math.max(48.0, size + padding.horizontal),
      math.max(48.0, size + padding.vertical),
    );

    Widget button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(minTouchTarget.width / 2),
        child: Container(
          width: minTouchTarget.width,
          height: minTouchTarget.height,
          padding: padding,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: size,
            color: color,
            semanticLabel: semanticLabel,
          ),
        ),
      ),
    );

    // 툴팁이 있는 경우 추가
    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    // 시맨틱스 래핑
    return Semantics(
      button: true,
      label: semanticLabel,
      enabled: onPressed != null,
      excludeSemantics: excludeFromSemantics,
      child: button,
    );
  }
}

/// 접근성이 개선된 텍스트 버튼
class AccessibleTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final String? semanticLabel;

  const AccessibleTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = style ?? theme.textTheme.labelLarge;
    
    return Semantics(
      button: true,
      label: semanticLabel ?? text,
      enabled: onPressed != null,
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 48, // 최소 터치 영역
              minWidth: 64,
            ),
            padding: padding,
            alignment: Alignment.center,
            child: Text(
              text,
              style: effectiveStyle,
            ),
          ),
        ),
      ),
    );
  }
}

/// 접근성이 개선된 플로팅 액션 버튼
class AccessibleFloatingActionButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? heroTag;
  final double elevation;
  final String? tooltip;

  const AccessibleFloatingActionButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.semanticLabel,
    this.backgroundColor,
    this.foregroundColor,
    this.heroTag,
    this.elevation = 6.0,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    Widget fab = FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      heroTag: heroTag,
      elevation: elevation,
      child: child,
    );

    // 툴팁 추가
    if (tooltip != null) {
      fab = Tooltip(
        message: tooltip!,
        child: fab,
      );
    }

    // 시맨틱스 강화
    return Semantics(
      button: true,
      label: semanticLabel,
      enabled: onPressed != null,
      child: fab,
    );
  }
}