import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'dart:math' as math;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../widgets/common/animated_gradient_background.dart';
import '../../../widgets/common/glass_morphism_container.dart';
import 'email_verification_viewmodel.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends ConsumerState<EmailVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  
  Timer? _checkTimer;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
    
    // Start email verification check timer
    _startEmailVerificationCheck();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    _checkTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startEmailVerificationCheck() {
    _checkTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      ref.read(emailVerificationViewModelProvider.notifier).checkEmailVerified();
    });
  }

  void _startResendCooldown() {
    setState(() {
      _resendCooldown = 60;
    });
    
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _resendCooldown--;
      });
      
      if (_resendCooldown <= 0) {
        timer.cancel();
      }
    });
  }

  Future<void> _resendEmail() async {
    await ref.read(emailVerificationViewModelProvider.notifier).resendVerificationEmail();
    _startResendCooldown();
  }

  Future<void> _handleLogout() async {
    // Stop timers
    _checkTimer?.cancel();
    _cooldownTimer?.cancel();
    
    // Sign out
    await ref.read(emailVerificationViewModelProvider.notifier).signOut();
    
    // Navigate to login screen
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emailVerificationViewModelProvider);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;
    
    ref.listen<EmailVerificationState>(emailVerificationViewModelProvider, (previous, next) {
      if (next.isVerified) {
        // Navigate to main screen on verification complete
        _checkTimer?.cancel();
        context.go('/main');
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.bloodMoon,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });

    return Scaffold(
      body: AnimatedGradientBackground(
        gradients: const [
          AppColors.mysticGradient,
          AppColors.spiritGradient,
        ],
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(screenSize.width * 0.06),
                  child: Column(
                    children: [
                      SizedBox(height: isSmallScreen ? 30 : 50),
                      _buildEmailAnimation(isSmallScreen),
                      const SizedBox(height: 30),
                      _buildContent(state, isSmallScreen),
                      const SizedBox(height: 30),
                      _buildActions(state),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48),
          Text(
            l10n.emailVerification,
            style: AppTextStyles.displaySmall.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(
              Icons.logout,
              color: AppColors.ghostWhite,
              size: 22,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.blackOverlay40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: AppColors.whiteOverlay10,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailAnimation(bool isSmallScreen) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Rotating magic circle
        AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationController.value * 2 * 3.14159,
              child: Container(
                width: isSmallScreen ? 180 : 220,
                height: isSmallScreen ? 180 : 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.spiritGlow.withAlpha(50),
                    width: 2,
                  ),
                ),
                child: CustomPaint(
                  painter: _MagicCirclePainter(),
                ),
              ),
            );
          },
        ),
        
        // Pulsing center
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: isSmallScreen ? 100 : 130,
                height: isSmallScreen ? 100 : 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.spiritGlow.withAlpha(150),
                      AppColors.mysticPurple.withAlpha(100),
                      AppColors.spiritGlow.withAlpha(0),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.spiritGlow.withAlpha(80),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.email_outlined,
                  size: 50,
                  color: AppColors.ghostWhite,
                ),
              ),
            );
          },
        ),
      ],
    ).animate(controller: _animationController)
        .scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1, 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
        )
        .fadeIn(duration: const Duration(milliseconds: 600));
  }

  Widget _buildContent(EmailVerificationState state, bool isSmallScreen) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          l10n.checkYourEmail,
          style: AppTextStyles.mysticTitle.copyWith(
            fontSize: isSmallScreen ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: AppColors.ghostWhite,
          ),
        ).animate(controller: _animationController)
            .fadeIn(delay: const Duration(milliseconds: 400))
            .slideY(begin: 0.3, end: 0),
        
        const SizedBox(height: 20),
        
        GlassMorphismContainer(
          padding: const EdgeInsets.all(20),
          borderRadius: 20,
          backgroundColor: AppColors.blackOverlay40,
          borderColor: AppColors.whiteOverlay10,
          child: Column(
            children: [
              const Icon(
                Icons.mark_email_unread,
                size: 42,
                color: AppColors.spiritGlow,
              ).animate(
                onPlay: (controller) => controller.repeat(),
              ).shimmer(
                duration: const Duration(seconds: 2),
                color: AppColors.ghostWhite.withAlpha(100),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                state.userEmail ?? 'your@email.com',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.spiritGlow,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Text(
                l10n.verificationEmailSent,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              
              // Loading indicator
              if (state.isChecking) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: AppColors.spiritGlow,
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.verifyingEmail,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.fogGray,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ).animate(controller: _animationController)
            .fadeIn(delay: const Duration(milliseconds: 600))
            .slideY(begin: 0.1, end: 0),
        
        const SizedBox(height: 20),
        
        // Tips
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.blackOverlay20,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.whiteOverlay10,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 18,
                color: AppColors.omenGlow,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.noEmailReceived,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.omenGlow,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.checkSpamFolder,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate(controller: _animationController)
            .fadeIn(delay: const Duration(milliseconds: 800)),
      ],
    );
  }

  Widget _buildActions(EmailVerificationState state) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Resend email button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: (_resendCooldown > 0 || state.isLoading) ? null : _resendEmail,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.spiritGlow,
              side: BorderSide(
                color: (_resendCooldown > 0 || state.isLoading) 
                    ? AppColors.ashGray 
                    : AppColors.spiritGlow,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.refresh, size: 18),
                const SizedBox(width: 10),
                Text(
                  _resendCooldown > 0 
                      ? l10n.resendIn(_resendCooldown)
                      : l10n.resendVerificationEmail,
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: (_resendCooldown > 0 || state.isLoading)
                        ? AppColors.ashGray
                        : AppColors.spiritGlow,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ).animate(controller: _animationController)
            .fadeIn(delay: const Duration(milliseconds: 1000))
            .slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 12),
        
        // Already verified button
        TextButton(
          onPressed: () {
            ref.read(emailVerificationViewModelProvider.notifier).checkEmailVerified();
          },
          child: Text(
            l10n.alreadyVerified,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMystic,
              decoration: TextDecoration.underline,
              fontSize: 13,
            ),
          ),
        ).animate(controller: _animationController)
            .fadeIn(delay: const Duration(milliseconds: 1100)),
      ],
    );
  }
}

// Magic circle painter
class _MagicCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.spiritGlow.withAlpha(30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Draw multiple concentric circles
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, radius * (i / 3), paint);
    }
    
    // Draw mystical symbols
    final symbolPaint = Paint()
      ..color = AppColors.spiritGlow.withAlpha(50)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final x = center.dx + (radius * 0.8) * math.cos(angle);
      final y = center.dy + (radius * 0.8) * math.sin(angle);
      
      canvas.drawCircle(Offset(x, y), 3, symbolPaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}