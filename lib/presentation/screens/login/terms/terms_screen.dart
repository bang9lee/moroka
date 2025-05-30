import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../widgets/common/animated_gradient_background.dart';
import '../../../widgets/common/glass_morphism_container.dart';
import '../signup/signup_viewmodel.dart';
import 'terms_viewmodel.dart';

class TermsScreen extends ConsumerStatefulWidget {
  const TermsScreen({super.key});

  @override
  ConsumerState<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends ConsumerState<TermsScreen>
    with TickerProviderStateMixin {
  bool _allAccepted = false;
  bool _serviceTermsAccepted = false;
  bool _privacyPolicyAccepted = false;
  bool _marketingAccepted = false;
  
  late AnimationController _animationController;
  late AnimationController _checkAnimationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    
    _checkAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _checkAnimationController.dispose();
    super.dispose();
  }

  void _updateAllAccepted() {
    setState(() {
      _allAccepted = _serviceTermsAccepted && _privacyPolicyAccepted;
    });
    
    if (_allAccepted) {
      _checkAnimationController.forward();
    } else {
      _checkAnimationController.reverse();
    }
  }

  void _toggleAll(bool? value) {
    setState(() {
      _allAccepted = value ?? false;
      _serviceTermsAccepted = _allAccepted;
      _privacyPolicyAccepted = _allAccepted;
      _marketingAccepted = _allAccepted;
    });
    
    if (_allAccepted) {
      _checkAnimationController.forward();
    } else {
      _checkAnimationController.reverse();
    }
  }

  Future<void> _proceedToEmailVerification() async {
    if (!_serviceTermsAccepted || !_privacyPolicyAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('필수 약관에 동의해주세요'),
          backgroundColor: AppColors.bloodMoon,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // 약관 동의 정보 저장
    ref.read(signUpViewModelProvider.notifier).setTermsAccepted(
      serviceTerms: _serviceTermsAccepted,
      privacyPolicy: _privacyPolicyAccepted,
      marketing: _marketingAccepted,
    );

    // 회원가입 진행
    final signUpState = ref.read(signUpViewModelProvider);
    if (signUpState.email != null && signUpState.password != null) {
      await ref.read(termsViewModelProvider.notifier).signUpWithEmail(
        email: signUpState.email!,
        password: signUpState.password!,
        displayName: signUpState.displayName!,
      );
    }
  }

  void _showTermsDetail(String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TermsDetailSheet(type: type),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(termsViewModelProvider);
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    
    ref.listen<TermsState>(termsViewModelProvider, (previous, next) {
      if (next.isSignUpComplete && !next.isLoading) {
        // 이메일 인증 화면으로 이동
        context.go('/login/email-verification');
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
          AppColors.darkGradient,
          AppColors.bloodGradient,
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
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.08,
                          vertical: 16,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight * 0.08),
                            _buildHeader(),
                            SizedBox(height: screenHeight * 0.04),
                            _buildTermsSection(state),
                            const SizedBox(height: 24),
                            _buildSubmitButton(state),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Contract icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.bloodMoon.withAlpha(50),
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
                color: AppColors.blackOverlay60,
                border: Border.all(
                  color: AppColors.bloodMoon,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.article_outlined,
                size: 30,
                color: AppColors.ghostWhite,
              ),
            ),
          ),
        ).animate(controller: _animationController)
            .scale(
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
              duration: 800.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(),
        
        const SizedBox(height: 20),
        
        Text(
          '영혼의 계약',
          style: AppTextStyles.displaySmall.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.ghostWhite,
          ),
        ).animate(controller: _animationController)
            .fadeIn(delay: 300.ms)
            .slideY(begin: 0.3, end: 0),
        
        const SizedBox(height: 8),
        
        Text(
          '서비스 이용을 위한 약관에 동의해주세요',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.fogGray,
            fontSize: 14,
          ),
        ).animate(controller: _animationController)
            .fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildTermsSection(TermsState state) {
    return GlassMorphismContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      backgroundColor: AppColors.blackOverlay40,
      borderColor: AppColors.whiteOverlay10,
      child: Column(
        children: [
          // 전체 동의
          Container(
            decoration: BoxDecoration(
              color: _allAccepted 
                  ? AppColors.mysticPurple.withAlpha(10)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _allAccepted
                    ? AppColors.mysticPurple.withAlpha(30)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: _buildTermsItem(
              title: '전체 동의',
              isRequired: false,
              isChecked: _allAccepted,
              onChanged: _toggleAll,
              isAllAgree: true,
            ),
          ).animate(controller: _animationController)
              .fadeIn(delay: 600.ms)
              .slideX(begin: -0.1, end: 0),
          
          const SizedBox(height: 20),
          
          // Divider
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.whiteOverlay20,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 필수 약관들
          Column(
            children: [
              // 서비스 이용약관
              _buildTermsItem(
                title: '서비스 이용약관',
                isRequired: true,
                isChecked: _serviceTermsAccepted,
                onChanged: (value) {
                  setState(() {
                    _serviceTermsAccepted = value ?? false;
                  });
                  _updateAllAccepted();
                },
                onDetailTap: () => _showTermsDetail('service'),
              ).animate(controller: _animationController)
                  .fadeIn(delay: 700.ms)
                  .slideX(begin: -0.1, end: 0),
              
              const SizedBox(height: 12),
              
              // 개인정보 처리방침
              _buildTermsItem(
                title: '개인정보 처리방침',
                isRequired: true,
                isChecked: _privacyPolicyAccepted,
                onChanged: (value) {
                  setState(() {
                    _privacyPolicyAccepted = value ?? false;
                  });
                  _updateAllAccepted();
                },
                onDetailTap: () => _showTermsDetail('privacy'),
              ).animate(controller: _animationController)
                  .fadeIn(delay: 800.ms)
                  .slideX(begin: -0.1, end: 0),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 선택 약관 구분선
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.blackOverlay60,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '선택 동의',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.fogGray,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 1,
                    color: AppColors.whiteOverlay10,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 마케팅 정보 수신
          _buildTermsItem(
            title: '마케팅 정보 수신 동의',
            isRequired: false,
            isOptional: true,
            isChecked: _marketingAccepted,
            onChanged: (value) {
              setState(() {
                _marketingAccepted = value ?? false;
              });
              _updateAllAccepted();
            },
            onDetailTap: () => _showTermsDetail('marketing'),
          ).animate(controller: _animationController)
              .fadeIn(delay: 900.ms)
              .slideX(begin: -0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildTermsItem({
    required String title,
    required bool isRequired,
    required bool isChecked,
    required Function(bool?) onChanged,
    VoidCallback? onDetailTap,
    bool isAllAgree = false,
    bool isOptional = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!isChecked),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              // Custom checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isChecked 
                      ? (isAllAgree ? AppColors.mysticPurple : 
                         isOptional ? AppColors.spiritGlow : AppColors.bloodMoon)
                      : AppColors.blackOverlay40,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isChecked
                        ? (isAllAgree ? AppColors.mysticPurple : 
                           isOptional ? AppColors.spiritGlow : AppColors.bloodMoon)
                        : AppColors.whiteOverlay30,
                    width: 2,
                  ),
                ),
                child: isChecked
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.ghostWhite,
                      ).animate()
                        .scale(
                          begin: const Offset(0, 0),
                          end: const Offset(1, 1),
                          duration: 200.ms,
                          curve: Curves.easeOutBack,
                        )
                    : null,
              ),
              
              const SizedBox(width: 12),
              
              // Title
              Expanded(
                child: Row(
                  children: [
                    if (isRequired && !isAllAgree) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.bloodMoon.withAlpha(20),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.bloodMoon.withAlpha(50),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '필수',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.bloodMoon,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ] else if (isOptional) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.spiritGlow.withAlpha(20),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.spiritGlow.withAlpha(50),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '선택',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.spiritGlow,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.ghostWhite,
                        fontWeight: isAllAgree ? FontWeight.w600 : FontWeight.w500,
                        fontSize: isAllAgree ? 15 : 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Detail button
              if (onDetailTap != null && !isAllAgree)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.blackOverlay40,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: onDetailTap,
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.fogGray,
                    ),
                    padding: const EdgeInsets.all(0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(TermsState state) {
    final isEnabled = _serviceTermsAccepted && _privacyPolicyAccepted && !state.isLoading;
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? _proceedToEmailVerification : null,
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
            gradient: LinearGradient(
              colors: isEnabled
                  ? const [AppColors.crimsonGlow, AppColors.evilGlow]
                  : [AppColors.ashGray.withAlpha(100), AppColors.fogGray.withAlpha(100)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: AppColors.crimsonGlow.withAlpha(50),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
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
                      Icon(
                        Icons.check_circle_outline,
                        size: 20,
                        color: isEnabled ? AppColors.ghostWhite : AppColors.fogGray,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '동의하고 시작하기',
                        style: AppTextStyles.buttonLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: isEnabled ? AppColors.ghostWhite : AppColors.fogGray,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ).animate(controller: _animationController)
        .fadeIn(delay: 1000.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

// 약관 상세 보기 시트
class _TermsDetailSheet extends StatelessWidget {
  final String type;
  
  const _TermsDetailSheet({required this.type});
  
  String get _title {
    switch (type) {
      case 'service':
        return '서비스 이용약관';
      case 'privacy':
        return '개인정보 처리방침';
      case 'marketing':
        return '마케팅 정보 수신 동의';
      default:
        return '';
    }
  }
  
  String get _content {
    switch (type) {
      case 'service':
        return '''
제 1 조 (목적)
이 약관은 MOROKA(이하 "서비스")가 제공하는 타로 점술 서비스의 이용과 관련하여 서비스와 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

제 2 조 (정의)
1. "서비스"란 MOROKA가 제공하는 모든 타로 관련 서비스를 의미합니다.
2. "이용자"란 이 약관에 따라 서비스가 제공하는 서비스를 받는 자를 의미합니다.

제 3 조 (약관의 효력 및 변경)
1. 이 약관은 서비스를 이용하고자 하는 모든 이용자에게 그 효력이 발생합니다.
2. 서비스는 필요한 경우 관련 법령을 위배하지 않는 범위에서 이 약관을 변경할 수 있습니다.

제 4 조 (서비스의 제공)
1. 서비스는 타로 카드 해석 및 상담 서비스를 제공합니다.
2. 서비스는 연중무휴, 1일 24시간 제공함을 원칙으로 합니다.

제 5 조 (이용자의 의무)
1. 이용자는 서비스 이용 시 타인의 권리를 침해하거나 관련 법령을 위반하는 행위를 하여서는 안 됩니다.
2. 이용자는 자신의 계정 정보를 안전하게 관리할 책임이 있습니다.
        ''';
      case 'privacy':
        return '''
1. 개인정보의 수집 및 이용 목적
MOROKA는 다음의 목적을 위하여 개인정보를 수집 및 이용합니다:
- 회원 가입 및 관리
- 서비스 제공 및 운영
- 서비스 개선 및 신규 서비스 개발

2. 수집하는 개인정보의 항목
- 필수항목: 이메일 주소, 비밀번호, 닉네임
- 선택항목: 생년월일, 성별

3. 개인정보의 보유 및 이용기간
- 회원 탈퇴 시까지
- 단, 관련 법령에 따라 보존할 필요가 있는 경우 해당 기간 동안 보관

4. 개인정보의 파기
- 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.

5. 이용자의 권리
- 이용자는 언제든지 자신의 개인정보를 조회하거나 수정할 수 있습니다.
- 이용자는 언제든지 개인정보의 수집 및 이용 동의를 철회할 수 있습니다.
        ''';
      case 'marketing':
        return '''
1. 수집 및 이용 목적
- 신규 서비스 및 이벤트 안내
- 맞춤형 서비스 제공
- 마케팅 및 광고에 활용

2. 수집 항목
- 이메일 주소
- 서비스 이용 기록

3. 보유 및 이용 기간
- 동의 철회 시까지

4. 동의 거부 권리
- 마케팅 정보 수신 동의는 선택사항이며, 동의하지 않아도 서비스 이용에 제한이 없습니다.
- 동의 후에도 언제든지 수신 거부 의사를 밝힐 수 있습니다.
        ''';
      default:
        return '';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.obsidianBlack,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.whiteOverlay20,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _title,
                        style: AppTextStyles.displaySmall.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.ghostWhite,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    _content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              
              // Close button
              Container(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mysticPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      '확인',
                      style: AppTextStyles.buttonLarge.copyWith(
                        color: AppColors.ghostWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}