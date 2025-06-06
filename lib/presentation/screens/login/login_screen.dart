import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_morphism_container.dart';
import 'login_viewmodel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _floatingAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
    
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(loginViewModelProvider.notifier).signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  Future<void> _signInWithGoogle() async {
    await ref.read(loginViewModelProvider.notifier).signInWithGoogle();
  }

  String _localizeError(BuildContext context, String errorKey) {
    final l10n = AppLocalizations.of(context)!;
    
    // Check if error contains additional info (like errorLoginFailed|code)
    if (errorKey.contains('|')) {
      final parts = errorKey.split('|');
      final key = parts[0];
      final code = parts[1];
      
      if (key == 'errorLoginFailed') {
        return '${l10n.errorLoginFailed}: $code';
      }
    }
    
    // Map error keys to localized messages
    switch (errorKey) {
      case 'errorEmailEmpty':
        return l10n.errorEmailEmpty;
      case 'errorPasswordEmpty':
        return l10n.errorPasswordEmpty;
      case 'errorUserNotFound':
        return l10n.errorUserNotFound;
      case 'errorWrongPassword':
        return l10n.errorWrongPassword;
      case 'errorEmailInvalid':
        return l10n.errorEmailInvalid;
      case 'errorUserDisabled':
        return l10n.errorUserDisabled;
      case 'errorTooManyRequests':
        return l10n.errorTooManyRequests;
      case 'errorInvalidCredential':
        return l10n.errorInvalidCredential;
      case 'errorLoginFailed':
        return l10n.errorLoginFailed;
      case 'errorGoogleLoginFailed':
        return l10n.errorGoogleLoginFailed;
      case 'errorLogoutFailed':
        return l10n.errorLogoutFailed;
      case 'errorPasswordResetFailed':
        return l10n.errorPasswordResetFailed;
      case 'errorUserDataLoad':
        return l10n.errorUserDataLoad;
      default:
        return errorKey; // Fallback to key if not found
    }
  }

  void _showPasswordResetDialog() {
    final l10n = AppLocalizations.of(context)!;
    final emailController = TextEditingController(text: _emailController.text);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.shadowGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.whiteOverlay10,
            width: 1,
          ),
        ),
        title: Text(
          l10n.passwordResetTitle,
          style: AppTextStyles.dialogTitle,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.passwordResetMessage,
              style: AppTextStyles.dialogContent.copyWith(
                color: AppColors.fogGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.ghostWhite,
              ),
              decoration: InputDecoration(
                hintText: l10n.emailPlaceholder,
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.ashGray,
                ),
                filled: true,
                fillColor: AppColors.blackOverlay40,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.whiteOverlay10,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.mysticPurple,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: AppTextStyles.dialogButton.copyWith(
                color: AppColors.fogGray,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                Navigator.pop(context);
                await ref.read(loginViewModelProvider.notifier)
                    .sendPasswordResetEmail(email);
                
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.passwordResetSuccess),
                    backgroundColor: AppColors.spiritGlow,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            child: Text(
              l10n.send,
              style: AppTextStyles.dialogButton.copyWith(
                color: AppColors.mysticPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;
    
    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      if (next.needsEmailVerification) {
        context.go('/login/email-verification');
      } else if (next.user != null && !next.isLoading) {
        context.go('/main');
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_localizeError(context, next.error!)),
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
      resizeToAvoidBottomInset: true,
      body: AnimatedGradientBackground(
        gradients: const [
          AppColors.mysticGradient,
          AppColors.darkGradient,
        ],
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              constraints: BoxConstraints(
                minHeight: screenHeight - 
                           MediaQuery.of(context).padding.top - 
                           MediaQuery.of(context).padding.bottom,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.08,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 상단 여백 - 화면 높이에 따라 조절
                    SizedBox(height: screenHeight * (isKeyboardOpen ? 0.03 : 0.08)),
                    
                    // Logo Section
                    SizedBox(
                      height: screenHeight * (isKeyboardOpen ? 0.12 : 0.15),
                      child: _buildLogo(),
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Welcome Text
                    _buildWelcomeText(),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Login Form
                    _buildLoginForm(state),
                    
                    SizedBox(height: screenHeight * 0.025),
                    
                    // Divider
                    _buildDivider(),
                    
                    SizedBox(height: screenHeight * 0.025),
                    
                    // Social Login
                    _buildSocialLogin(state),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Sign Up Prompt
                    _buildSignUpPrompt(),
                    
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: Center(
            child: Container(
              width: 100,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mysticPurple.withAlpha(80),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/logo/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.deepViolet,
                            AppColors.mysticPurple,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        size: 40,
                        color: AppColors.ghostWhite,
                      ),
                    );
                  },
                ),
              ),
            ),
          ).animate(controller: _animationController)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: const Duration(milliseconds: 600)),
        );
      },
    );
  }

  Widget _buildWelcomeText() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          l10n.appBrandName,
          style: AppTextStyles.mysticTitle.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            color: AppColors.ghostWhite,
          ),
        ).animate(controller: _animationController)
            .fadeIn(delay: const Duration(milliseconds: 400))
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 8),
        Text(
          l10n.appBrandTagline,
          style: AppTextStyles.whisper.copyWith(
            color: AppColors.fogGray,
            fontSize: 14,
          ),
        ).animate(controller: _animationController)
            .fadeIn(delay: const Duration(milliseconds: 600)),
      ],
    );
  }

  Widget _buildLoginForm(LoginState state) {
    final l10n = AppLocalizations.of(context)!;
    return GlassMorphismContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      backgroundColor: AppColors.blackOverlay40,
      borderColor: AppColors.whiteOverlay10,
      child: Column(
        children: [
          _buildTextField(
            controller: _emailController,
            label: l10n.emailLabel,
            hint: l10n.emailPlaceholder,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.errorEmailEmpty;
              }
              if (!value.contains('@')) {
                return l10n.errorEmailInvalid;
              }
              return null;
            },
          ).animate(controller: _animationController)
              .fadeIn(delay: const Duration(milliseconds: 800))
              .slideX(begin: -0.1, end: 0),
          
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: _passwordController,
            label: l10n.passwordLabel,
            hint: l10n.passwordPlaceholder,
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword 
                    ? Icons.visibility_off_outlined 
                    : Icons.visibility_outlined,
                color: AppColors.fogGray,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.errorPasswordEmpty;
              }
              if (value.length < 6) {
                return l10n.errorPasswordShort;
              }
              return null;
            },
          ).animate(controller: _animationController)
              .fadeIn(delay: const Duration(milliseconds: 900))
              .slideX(begin: -0.1, end: 0),
          
          const SizedBox(height: 8),
          
          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _showPasswordResetDialog,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Text(
                l10n.forgotPassword,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMystic,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Login button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : _signInWithEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.ghostWhite,
                disabledBackgroundColor: AppColors.ashGray.withAlpha(50),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.mysticPurple,
                      AppColors.deepViolet,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: state.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.ghostWhite,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.login, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              l10n.login,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ).animate(controller: _animationController)
              .fadeIn(delay: const Duration(milliseconds: 1000))
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1, 1),
              ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.whiteOverlay10,
                  AppColors.whiteOverlay20,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.or,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.fogGray,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.whiteOverlay20,
                  AppColors.whiteOverlay10,
                ],
              ),
            ),
          ),
        ),
      ],
    ).animate(controller: _animationController)
        .fadeIn(delay: const Duration(milliseconds: 1100));
  }

  Widget _buildSocialLogin(LoginState state) {
    return GlassMorphismContainer(
      padding: EdgeInsets.zero,
      borderRadius: 16,
      backgroundColor: AppColors.blackOverlay40,
      borderColor: AppColors.whiteOverlay20,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: state.isLoading ? null : _signInWithGoogle,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/icons/google.png',
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: AppColors.ghostWhite,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'G',
                          style: TextStyle(
                            color: AppColors.obsidianBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.continueWithGoogle,
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.ghostWhite,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(controller: _animationController)
        .fadeIn(delay: const Duration(milliseconds: 1200))
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
        );
  }

  Widget _buildSignUpPrompt() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.noAccount,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.fogGray,
            fontSize: 13,
          ),
        ),
        TextButton(
          onPressed: () => context.push('/login/signup'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: Text(
            l10n.signUp,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMystic,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ).animate(controller: _animationController)
        .fadeIn(delay: const Duration(milliseconds: 1300));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.ghostWhite,
        fontSize: 14,
      ),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.fogGray,
          fontSize: 13,
        ),
        hintText: hint,
        hintStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.ashGray,
          fontSize: 13,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.fogGray,
          size: 18,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.blackOverlay20,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.whiteOverlay10,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.mysticPurple,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.bloodMoon,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.bloodMoon,
            width: 2,
          ),
        ),
        errorStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.bloodMoon,
          fontSize: 11,
        ),
      ),
    );
  }
}