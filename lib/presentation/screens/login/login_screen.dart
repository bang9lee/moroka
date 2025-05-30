import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/common/animated_gradient_background.dart';
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
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isSignUp = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late AnimationController _switchAnimationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
    
    _switchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _animationController.dispose();
    _switchAnimationController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
    _switchAnimationController.forward(from: 0);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isSignUp) {
      await ref.read(loginViewModelProvider.notifier).signUpWithEmail(
            email: _emailController.text,
            password: _passwordController.text,
            displayName: _nameController.text,
          );
    } else {
      await ref.read(loginViewModelProvider.notifier).signInWithEmail(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    
    // Listen for successful login
    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      if (next.user != null && !next.isLoading) {
        context.go('/main');
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.bloodMoon,
          ),
        );
      }
    });

    return Scaffold(
      body: AnimatedGradientBackground(
        gradients: _isSignUp 
            ? [AppColors.bloodGradient, AppColors.mysticGradient]
            : [AppColors.mysticGradient, AppColors.darkGradient],
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo - 로고 이미지 사용, 배경 제거
                    Image.asset(
                      'assets/images/logo/logo.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // 로고 이미지가 없을 경우 기본 디자인
                        return Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.mysticPurple,
                                AppColors.deepViolet,
                                AppColors.obsidianBlack,
                              ],
                            ),
                            border: Border.all(
                              color: AppColors.evilGlow,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.remove_red_eye_outlined,
                            size: 80,
                            color: AppColors.ghostWhite,
                          ),
                        );
                      },
                    ).animate(
                      onPlay: (controller) => controller.repeat(),
                    ).shimmer(
                      duration: const Duration(seconds: 3),
                      color: AppColors.spiritGlow,
                    ).animate(controller: _animationController)
                        .scale(duration: const Duration(milliseconds: 600)),
                    
                    const SizedBox(height: 32),
                    
                    // Title
                    Text(
                      _isSignUp ? '운명의 계약' : '다시 돌아오셨군요',
                      style: AppTextStyles.mysticTitle.copyWith(
                        fontSize: 32,
                        color: AppColors.ghostWhite,
                      ),
                    ).animate(controller: _switchAnimationController)
                        .fadeIn()
                        .slideY(begin: 0.2, end: 0),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      _isSignUp 
                          ? '당신의 영혼을 등록하세요' 
                          : '당신을 기다리고 있었습니다',
                      style: AppTextStyles.whisper.copyWith(
                        color: AppColors.fogGray,
                      ),
                    ).animate(controller: _switchAnimationController)
                        .fadeIn(delay: const Duration(milliseconds: 200)),
                    
                    const SizedBox(height: 48),
                    
                    // Form fields
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.blackOverlay40,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.whiteOverlay20,
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.blackOverlay40,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Name field (sign up only)
                          if (_isSignUp) ...[
                            _buildTextField(
                              controller: _nameController,
                              label: '이름',
                              icon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '이름을 입력해주세요';
                                }
                                return null;
                              },
                            ).animate(controller: _switchAnimationController)
                                .fadeIn()
                                .slideX(begin: -0.2, end: 0),
                            const SizedBox(height: 16),
                          ],
                          
                          // Email field
                          _buildTextField(
                            controller: _emailController,
                            label: '이메일',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '이메일을 입력해주세요';
                              }
                              if (!value.contains('@')) {
                                return '올바른 이메일 형식이 아닙니다';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Password field
                          _buildTextField(
                            controller: _passwordController,
                            label: '비밀번호',
                            icon: Icons.lock,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword 
                                    ? Icons.visibility_off 
                                    : Icons.visibility,
                                color: AppColors.fogGray,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '비밀번호를 입력해주세요';
                              }
                              if (value.length < 6) {
                                return '비밀번호는 6자 이상이어야 합니다';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: state.isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.crimsonGlow,
                                disabledBackgroundColor: AppColors.ashGray,
                              ),
                              child: state.isLoading
                                  ? const CircularProgressIndicator(
                                      color: AppColors.ghostWhite,
                                    )
                                  : Text(
                                      _isSignUp ? '영혼 등록' : '입장하기',
                                      style: AppTextStyles.buttonLarge,
                                    ),
                            ),
                          ).animate(controller: _animationController)
                              .fadeIn(delay: const Duration(milliseconds: 600))
                              .slideY(begin: 0.2, end: 0),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AppColors.whiteOverlay20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.fogGray,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AppColors.whiteOverlay20,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Google sign in
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: SignInButton(
                        Buttons.google,
                        text: _isSignUp 
                            ? "Google로 시작하기" 
                            : "Google로 로그인",
                        onPressed: state.isLoading 
                            ? () {} 
                            : () => ref
                                .read(loginViewModelProvider.notifier)
                                .signInWithGoogle(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ).animate(controller: _animationController)
                        .fadeIn(delay: const Duration(milliseconds: 800))
                        .slideY(begin: 0.2, end: 0),
                    
                    const SizedBox(height: 32),
                    
                    // Toggle auth mode
                    TextButton(
                      onPressed: _toggleAuthMode,
                      child: Text(
                        _isSignUp 
                            ? '이미 계정이 있으신가요? 로그인' 
                            : '처음이신가요? 회원가입',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textMystic,
                        ),
                      ),
                    ).animate(controller: _animationController)
                        .fadeIn(delay: const Duration(milliseconds: 1000)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
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
      ),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.fogGray,
        ),
        prefixIcon: Icon(icon, color: AppColors.fogGray),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.blackOverlay40,
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
            color: AppColors.evilGlow,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.bloodMoon,
            width: 2,
          ),
        ),
      ),
    );
  }
}