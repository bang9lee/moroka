import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import '../../../../l10n/generated/app_localizations.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../widgets/common/animated_gradient_background.dart';
import '../../../widgets/common/glass_morphism_container.dart';
import 'signup_viewmodel.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;
  late AnimationController _animationController;
  
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = AppColors.ashGray;

  // 중복 확인 관련 상태
  bool _isCheckingName = false;
  bool _isCheckingEmail = false;
  bool? _isNameAvailable;
  bool? _isEmailAvailable;
  String? _nameCheckMessage;
  String? _emailCheckMessage;
  
  // 디바운스 타이머
  Timer? _nameDebounceTimer;
  Timer? _emailDebounceTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
    
    _passwordController.addListener(_updatePasswordStrength);
    _nameController.addListener(_onNameChanged);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    _animationController.dispose();
    _nameDebounceTimer?.cancel();
    _emailDebounceTimer?.cancel();
    super.dispose();
  }

  // 이름 변경 감지 (디바운스 적용)
  void _onNameChanged() {
    _nameDebounceTimer?.cancel();
    
    setState(() {
      _isNameAvailable = null;
      _nameCheckMessage = null;
    });

    if (_nameController.text.trim().length >= 2) {
      setState(() {
        _isCheckingName = true;
      });

      _nameDebounceTimer = Timer(const Duration(milliseconds: 500), () {
        _checkNameAvailability();
      });
    }
  }

  // 이메일 변경 감지 (디바운스 적용)
  void _onEmailChanged() {
    _emailDebounceTimer?.cancel();
    
    setState(() {
      _isEmailAvailable = null;
      _emailCheckMessage = null;
    });

    final email = _emailController.text.trim();
    if (email.isNotEmpty && email.contains('@')) {
      setState(() {
        _isCheckingEmail = true;
      });

      _emailDebounceTimer = Timer(const Duration(milliseconds: 500), () {
        _checkEmailAvailability();
      });
    }
  }

  // 이름 중복 확인
  Future<void> _checkNameAvailability() async {
    final result = await ref.read(signUpViewModelProvider.notifier)
        .checkNameAvailability(_nameController.text.trim());
    
    if (mounted) {
      setState(() {
        _isCheckingName = false;
        _isNameAvailable = result.isAvailable;
        _nameCheckMessage = result.message;
      });
    }
  }

  // 이메일 중복 확인
  Future<void> _checkEmailAvailability() async {
    final result = await ref.read(signUpViewModelProvider.notifier)
        .checkEmailAvailability(_emailController.text.trim());
    
    if (mounted) {
      setState(() {
        _isCheckingEmail = false;
        _isEmailAvailable = result.isAvailable;
        _emailCheckMessage = result.message;
      });
    }
  }

  void _updatePasswordStrength() {
    final l10n = AppLocalizations.of(context)!;
    final password = _passwordController.text;
    
    setState(() {
      if (password.isEmpty) {
        _passwordStrength = 0.0;
        _passwordStrengthText = '';
        _passwordStrengthColor = AppColors.ashGray;
      } else if (password.length < 6) {
        _passwordStrength = 0.25;
        _passwordStrengthText = l10n.passwordWeak;
        _passwordStrengthColor = AppColors.bloodMoon;
      } else if (password.length < 8) {
        _passwordStrength = 0.5;
        _passwordStrengthText = l10n.passwordFair;
        _passwordStrengthColor = AppColors.omenGlow;
      } else if (_isStrongPassword(password)) {
        _passwordStrength = 1.0;
        _passwordStrengthText = l10n.passwordVeryStrong;
        _passwordStrengthColor = AppColors.spiritGlow;
      } else {
        _passwordStrength = 0.75;
        _passwordStrengthText = l10n.passwordStrong;
        _passwordStrengthColor = AppColors.mysticPurple;
      }
    });
  }

  bool _isStrongPassword(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    return password.length >= 8 && 
           hasUppercase && 
           hasLowercase && 
           hasDigits && 
           hasSpecialCharacters;
  }

  Future<void> _proceedToTerms() async {
    // 중복 확인이 완료되었는지 체크
    if (_isNameAvailable == false || _isEmailAvailable == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.agreeToRequired),
          backgroundColor: AppColors.bloodMoon,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    ref.read(signUpViewModelProvider.notifier).setSignUpInfo(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
    );

    if (mounted) {
      context.push('/login/terms');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(signUpViewModelProvider);
    final size = MediaQuery.of(context).size;
    final safeArea = MediaQuery.of(context).padding;
    final availableHeight = size.height - safeArea.top - safeArea.bottom;
    
    ref.listen<SignUpState>(signUpViewModelProvider, (previous, next) {
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
          AppColors.bloodGradient,
          AppColors.mysticGradient,
        ],
        child: SafeArea(
          child: Stack(
            children: [
              // Back Button
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.blackOverlay40,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.whiteOverlay10,
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.ghostWhite,
                      size: 20,
                    ),
                    padding: const EdgeInsets.all(8),
                  ),
                ).animate()
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: -0.2, end: 0),
              ),
              
              // Main Content
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(height: availableHeight * 0.1),
                      
                      // Logo and Title Section
                      _buildLogoSection(l10n),
                      
                      SizedBox(height: availableHeight * 0.08),
                      
                      // Form Section
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Name Field with validation
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInputField(
                                  controller: _nameController,
                                  label: l10n.nickname,
                                  hint: l10n.nickname,
                                  icon: Icons.person_outline,
                                  delay: 200,
                                  suffixIcon: _buildValidationIcon(_isCheckingName, _isNameAvailable),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return l10n.errorNameEmpty;
                                    }
                                    if (value.length < 2) {
                                      return l10n.errorNameTooShort;
                                    }
                                    if (_isNameAvailable == false) {
                                      return null; // Message shown separately below
                                    }
                                    return null;
                                  },
                                ),
                                if (_nameCheckMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12, top: 4),
                                    child: Text(
                                      _nameCheckMessage!,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: _isNameAvailable == true 
                                            ? AppColors.spiritGlow 
                                            : AppColors.bloodMoon,
                                        fontSize: 12,
                                      ),
                                    ).animate().fadeIn(),
                                  ),
                              ],
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Email Field with validation
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInputField(
                                  controller: _emailController,
                                  label: l10n.emailLabel,
                                  hint: l10n.emailPlaceholder,
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  delay: 300,
                                  suffixIcon: _buildValidationIcon(_isCheckingEmail, _isEmailAvailable),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return l10n.errorEmailEmpty;
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value)) {
                                      return l10n.errorEmailInvalid;
                                    }
                                    if (_isEmailAvailable == false) {
                                      return null; // Message shown separately below
                                    }
                                    return null;
                                  },
                                ),
                                if (_emailCheckMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12, top: 4),
                                    child: Text(
                                      _emailCheckMessage!,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: _isEmailAvailable == true 
                                            ? AppColors.spiritGlow 
                                            : AppColors.bloodMoon,
                                        fontSize: 12,
                                      ),
                                    ).animate().fadeIn(),
                                  ),
                              ],
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Password Field
                            _buildInputField(
                              controller: _passwordController,
                              label: l10n.passwordLabel,
                              hint: l10n.passwordPlaceholder,
                              icon: Icons.lock_outline,
                              obscureText: _obscurePassword,
                              delay: 400,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
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
                            ),
                            
                            // Password Strength Indicator
                            if (_passwordController.text.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _buildPasswordStrength(),
                            ],
                            
                            const SizedBox(height: 20),
                            
                            // Confirm Password Field
                            _buildInputField(
                              controller: _passwordConfirmController,
                              label: l10n.confirmPassword,
                              hint: l10n.confirmPassword,
                              icon: Icons.lock_outline,
                              obscureText: _obscurePasswordConfirm,
                              delay: 500,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePasswordConfirm
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.fogGray,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePasswordConfirm = !_obscurePasswordConfirm;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.errorConfirmPassword;
                                }
                                if (value != _passwordController.text) {
                                  return l10n.errorPasswordsDontMatch;
                                }
                                return null;
                              },
                            ),
                            
                            SizedBox(height: availableHeight * 0.06),
                            
                            // Submit Button
                            _buildSubmitButton(state, l10n),
                            
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
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

  Widget _buildLogoSection(AppLocalizations l10n) {
    return Column(
      children: [
        // Logo Container
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.mysticPurple.withAlpha(100),
                AppColors.mysticPurple.withAlpha(50),
                Colors.transparent,
              ],
              radius: 1.5,
            ),
          ),
          child: Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.shadowGray,
                border: Border.all(
                  color: AppColors.mysticPurple,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.person_add,
                color: AppColors.mysticPurple,
                size: 32,
              ),
            ),
          ),
        ).animate()
            .scale(
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
              duration: 800.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(),
        
        const SizedBox(height: 24),
        
        // Title
        Text(
          l10n.signupTitle,
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColors.ghostWhite,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ).animate()
            .fadeIn(delay: 300.ms)
            .slideY(begin: 0.3, end: 0),
        
        const SizedBox(height: 8),
        
        // Subtitle
        Text(
          l10n.signupSubtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.fogGray,
            fontSize: 14,
          ),
        ).animate()
            .fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    required int delay,
  }) {
    return GlassMorphismContainer(
      padding: const EdgeInsets.all(4),
      borderRadius: 16,
      backgroundColor: AppColors.blackOverlay20,
      borderColor: AppColors.whiteOverlay10,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.ghostWhite,
          fontSize: 15,
        ),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.fogGray,
            fontSize: 14,
          ),
          hintText: hint,
          hintStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.ashGray,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.fogGray,
            size: 20,
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.mysticPurple,
              width: 1.5,
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
              width: 1.5,
            ),
          ),
          errorStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.bloodMoon,
            fontSize: 12,
          ),
        ),
      ),
    ).animate()
        .fadeIn(delay: delay.ms)
        .slideX(begin: 0.1, end: 0);
  }

  // 중복 확인 아이콘 빌더
  Widget? _buildValidationIcon(bool isChecking, bool? isAvailable) {
    if (isChecking) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.mysticPurple,
        ),
      );
    }
    
    if (isAvailable == true) {
      return const Icon(
        Icons.check_circle,
        color: AppColors.spiritGlow,
        size: 20,
      ).animate()
          .scale(
            begin: const Offset(0, 0),
            end: const Offset(1, 1),
            duration: 300.ms,
            curve: Curves.elasticOut,
          );
    }
    
    if (isAvailable == false) {
      return const Icon(
        Icons.cancel,
        color: AppColors.bloodMoon,
        size: 20,
      ).animate()
          .scale(
            begin: const Offset(0, 0),
            end: const Offset(1, 1),
            duration: 300.ms,
            curve: Curves.elasticOut,
          );
    }
    
    return null;
  }

  Widget _buildPasswordStrength() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _passwordStrength,
                    backgroundColor: AppColors.blackOverlay60,
                    valueColor: AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _passwordStrengthText,
                style: AppTextStyles.bodySmall.copyWith(
                  color: _passwordStrengthColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
        .fadeIn()
        .slideY(begin: -0.2, end: 0);
  }

  Widget _buildSubmitButton(SignUpState state, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: state.isLoading ? null : _proceedToTerms,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.ghostWhite,
          disabledBackgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: state.isLoading
                ? LinearGradient(
                    colors: [
                      AppColors.ashGray.withAlpha(100),
                      AppColors.ashGray.withAlpha(100),
                    ],
                  )
                : const LinearGradient(
                    colors: [
                      AppColors.crimsonGlow,
                      AppColors.evilGlow,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: state.isLoading
                ? []
                : [
                    BoxShadow(
                      color: AppColors.crimsonGlow.withAlpha(50),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: Container(
            alignment: Alignment.center,
            child: state.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.ghostWhite,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.nextStep,
                        style: AppTextStyles.buttonLarge.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ).animate()
        .fadeIn(delay: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }
}