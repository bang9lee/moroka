import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../l10n/generated/app_localizations.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_morphism_container.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _contentController;
  late AnimationController _shimmerController;
  String _version = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _loadAppInfo();
    _logoController.forward();
    _contentController.forward();
  }

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedGradientBackground(
        gradients: const [
          AppColors.darkGradient,
          AppColors.mysticGradient,
        ],
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, l10n),
              Expanded(
                child: _buildContent(screenSize, l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.shadowGray.withAlpha(200),
            AppColors.shadowGray.withAlpha(0),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.blackOverlay40,
              borderRadius: BorderRadius.circular(14),
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
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aboutTitle,
                  style: AppTextStyles.displaySmall.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'MOROKA - oracle of shadows',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.fogGray,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideY(begin: -0.2, end: 0);
  }

  Widget _buildContent(Size screenSize, AppLocalizations l10n) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Logo Section
          _buildLogoSection(),
          const SizedBox(height: 32),

          // App Info Section
          _buildAppInfoSection(l10n),
          const SizedBox(height: 40),

          // Description Section
          _buildDescriptionSection(),
          const SizedBox(height: 32),

          // Features Section
          _buildFeaturesSection(l10n),
          const SizedBox(height: 40),

          // Legal Section
          _buildLegalSection(l10n),
          const SizedBox(height: 40),

          // Contact Section
          _buildContactSection(l10n),
          const SizedBox(height: 40),

          // Developer Section
          _buildDeveloperSection(l10n),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect
          AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              return Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.mysticPurple.withAlpha(
                        (100 * (0.5 + 0.5 * _shimmerController.value)).toInt(),
                      ),
                      AppColors.mysticPurple.withAlpha(20),
                      Colors.transparent,
                    ],
                    stops: const [0.3, 0.6, 1.0],
                  ),
                ),
              );
            },
          ),
          // Logo container
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blackOverlay60,
              border: Border.all(
                color: AppColors.mysticPurple.withAlpha(100),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.mysticPurple.withAlpha(50),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo/icon.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(controller: _logoController)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
        )
        .fadeIn();
  }

  Widget _buildAppInfoSection(AppLocalizations l10n) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: const [
                    AppColors.mysticPurple,
                    AppColors.evilGlow,
                    AppColors.mysticPurple,
                  ],
                  stops: [
                    0.0,
                    0.5 + 0.5 * _shimmerController.value,
                    1.0,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Text(
                l10n.appBrandName,
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 42,
                  letterSpacing: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          'oracle of shadows',
          style: AppTextStyles.mysticTitle.copyWith(
            fontSize: 22,
            color: AppColors.fogGray,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.blackOverlay40,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.whiteOverlay10,
              width: 1,
            ),
          ),
          child: Text(
            'Version $_version (Build $_buildNumber)',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 300))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildDescriptionSection() {
    return GlassMorphismContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      backgroundColor: AppColors.blackOverlay40,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.mysticPurple.withAlpha(50),
                  AppColors.deepViolet.withAlpha(30),
                ],
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 32,
              color: AppColors.evilGlow,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.aboutTagline,
            style: AppTextStyles.displaySmall.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.aboutDescription,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.8,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 400))
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildFeaturesSection(AppLocalizations l10n) {
    final features = [
      {
        'icon': Icons.style_outlined,
        'title': l10n.feature78Cards,
        'description': l10n.feature78CardsDesc,
        'gradient': [AppColors.mysticPurple, AppColors.deepViolet],
      },
      {
        'icon': Icons.dashboard_outlined,
        'title': l10n.feature5Spreads,
        'description': l10n.feature5SpreadsDesc,
        'gradient': [AppColors.evilGlow, AppColors.mysticPurple],
      },
      {
        'icon': Icons.psychology_outlined,
        'title': l10n.featureAI,
        'description': l10n.featureAIDesc,
        'gradient': [AppColors.crimsonGlow, AppColors.bloodMoon],
      },
      {
        'icon': Icons.chat_bubble_outline,
        'title': l10n.featureChat,
        'description': l10n.featureChatDesc,
        'gradient': [AppColors.spiritGlow, AppColors.omenGlow],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            l10n.featuresTitle,
            style: AppTextStyles.displaySmall.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...features.asMap().entries.map((entry) {
          final index = entry.key;
          final feature = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildFeatureCard(
              icon: feature['icon'] as IconData,
              title: feature['title'] as String,
              description: feature['description'] as String,
              gradient: feature['gradient'] as List<Color>,
              delay: 500 + (index * 100),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required List<Color> gradient,
    required int delay,
  }) {
    return GlassMorphismContainer(
      padding: const EdgeInsets.all(16),
      backgroundColor: AppColors.blackOverlay20,
      borderRadius: 16,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient.map((c) => c.withAlpha(50)).toList(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: gradient[0],
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: delay),
          duration: const Duration(milliseconds: 400),
        )
        .slideX(
          begin: -0.05,
          end: 0,
          delay: Duration(milliseconds: delay),
          duration: const Duration(milliseconds: 400),
        );
  }

  Widget _buildLegalSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            l10n.termsAndPolicies,
            style: AppTextStyles.displaySmall.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildLegalTile(
          icon: Icons.article_outlined,
          title: l10n.termsOfService,
          onTap: () => _showLegalDocument('service'),
        ),
        const SizedBox(height: 12),
        _buildLegalTile(
          icon: Icons.privacy_tip_outlined,
          title: l10n.privacyPolicy,
          onTap: () => _showLegalDocument('privacy'),
        ),
        const SizedBox(height: 12),
        _buildLegalTile(
          icon: Icons.campaign_outlined,
          title: l10n.marketingConsent,
          onTap: () => _showLegalDocument('marketing'),
        ),
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 900));
  }

  Widget _buildContactSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            l10n.customerSupport,
            style: AppTextStyles.displaySmall.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildContactTile(
          icon: Icons.mail_outline,
          title: l10n.emailSupport,
          subtitle: 'chchleeshop@gmail.com',
          onTap: () => _launchUrl('chchleeshop@gmail.com'),
        ),
        const SizedBox(height: 12),
        _buildContactTile(
          icon: Icons.language,
          title: l10n.website,
          subtitle: 'www.moroka.app',
          onTap: () => _launchUrl('https://moroka.app'),
        ),
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 1000));
  }

  Widget _buildDeveloperSection(AppLocalizations l10n) {
    return GlassMorphismContainer(
      padding: const EdgeInsets.all(24),
      backgroundColor: AppColors.blackOverlay20,
      borderRadius: 24,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.mysticPurple.withAlpha(30),
                  Colors.transparent,
                ],
              ),
            ),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo/logo2.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mysticPurple.withAlpha(50),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.companyName,
            style: AppTextStyles.displaySmall.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.companyTagline,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.blackOverlay40,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.whiteOverlay10,
                width: 1,
              ),
            ),
            child: Text(
              l10n.copyright,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.ashGray,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 1100)).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          delay: const Duration(milliseconds: 1100),
        );
  }

  Widget _buildLegalTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: GlassMorphismContainer(
          padding: const EdgeInsets.all(16),
          backgroundColor: AppColors.blackOverlay20,
          borderRadius: 16,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.whiteOverlay10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.textMystic,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.fogGray.withAlpha(150),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: GlassMorphismContainer(
          padding: const EdgeInsets.all(16),
          backgroundColor: AppColors.blackOverlay20,
          borderRadius: 16,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.whiteOverlay10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.spiritGlow,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new,
                size: 18,
                color: AppColors.fogGray.withAlpha(150),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLegalDocument(String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LegalDocumentSheet(type: type),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('URL을 열 수 없습니다: $urlString'),
            backgroundColor: AppColors.bloodMoon,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }
}

// 약관 상세 보기 시트
class _LegalDocumentSheet extends StatelessWidget {
  final String type;

  const _LegalDocumentSheet({required this.type});

  String get _title {
    switch (type) {
      case 'service':
        return '서비스 이용약관';
      case 'privacy':
        return '개인정보 처리방침';
      case 'marketing':
        return '마케팅 정보 수신';
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

제 6 조 (개인정보보호)
서비스의 개인정보보호에 관한 사항은 별도로 정한 개인정보처리방침에 따릅니다.

제 7 조 (서비스 이용의 제한)
서비스는 다음 각 호에 해당하는 경우 이용자의 서비스 이용을 제한할 수 있습니다.
1. 타인의 정보를 도용한 경우
2. 서비스의 운영을 고의로 방해한 경우
3. 기타 관련 법령이나 이 약관을 위반한 경우

제 8 조 (책임의 한계)
1. 서비스는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 책임이 면제됩니다.
2. 서비스는 이용자의 귀책사유로 인한 서비스 이용의 장애에 대하여 책임을 지지 않습니다.

제 9 조 (분쟁해결)
1. 서비스와 이용자 간에 발생한 분쟁은 상호 협의하여 해결합니다.
2. 협의가 되지 않을 경우에는 민사소송법상의 관할법원에 소를 제기할 수 있습니다.

부칙
이 약관은 2025년 7월 3일부터 시행됩니다.
        ''';
      case 'privacy':
        return '''
MOROKA 개인정보처리방침

1. 개인정보의 수집 및 이용 목적
MOROKA는 다음의 목적을 위하여 개인정보를 수집 및 이용합니다:
- 회원 가입 및 관리
- 서비스 제공 및 운영
- 서비스 개선 및 신규 서비스 개발
- 마케팅 및 광고에 활용

2. 수집하는 개인정보의 항목
가. 필수항목
- 이메일 주소
- 비밀번호 (암호화하여 저장)
- 닉네임

나. 선택항목
- 생년월일
- 성별

다. 서비스 이용 과정에서 자동 수집되는 정보
- 서비스 이용 기록
- 접속 로그
- 쿠키
- 접속 IP 정보

3. 개인정보의 보유 및 이용기간
- 회원 탈퇴 시까지
- 단, 관련 법령에 따라 보존할 필요가 있는 경우 해당 기간 동안 보관
  * 계약 또는 청약철회 등에 관한 기록: 5년
  * 대금결제 및 재화 등의 공급에 관한 기록: 5년
  * 소비자의 불만 또는 분쟁처리에 관한 기록: 3년

4. 개인정보의 제3자 제공
MOROKA는 원칙적으로 이용자의 개인정보를 제3자에게 제공하지 않습니다. 다만, 다음의 경우에는 예외로 합니다.
- 이용자가 사전에 동의한 경우
- 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우

5. 개인정보의 파기
- 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.
- 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다.
- 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.

6. 개인정보의 안전성 확보 조치
MOROKA는 개인정보보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다.
- 개인정보 취급 직원의 최소화 및 교육
- 개인정보에 대한 접근 제한
- 접속기록의 보관 및 위변조 방지
- 개인정보의 암호화
- 보안프로그램 설치 및 주기적 점검·갱신

7. 이용자의 권리
- 이용자는 언제든지 자신의 개인정보를 조회하거나 수정할 수 있습니다.
- 이용자는 언제든지 개인정보의 수집 및 이용 동의를 철회할 수 있습니다.
- 만 14세 미만 아동의 경우 개인정보 수집 및 이용을 제한합니다.

8. 개인정보 보호책임자
Today's Studio
이메일: chchleeshop@gmail.com

9. 개인정보처리방침의 변경
이 개인정보처리방침은 2025년 7월 3일부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.
        ''';
      case 'marketing':
        return '''
마케팅 정보 수신 동의

1. 수집 및 이용 목적
- 신규 서비스 및 이벤트 안내
- 맞춤형 서비스 제공
- 마케팅 및 광고에 활용
- 서비스 이용 통계 및 분석

2. 수집 항목
- 이메일 주소
- 서비스 이용 기록
- 접속 빈도 및 시간

3. 보유 및 이용 기간
- 동의 철회 시까지
- 회원 탈퇴 시 즉시 파기

4. 마케팅 정보 수신 방법
- 이메일
- 앱 푸시 알림

5. 동의 거부 권리 및 불이익
- 마케팅 정보 수신 동의는 선택사항이며, 동의하지 않아도 서비스 이용에 제한이 없습니다.
- 동의 후에도 언제든지 수신 거부 의사를 밝힐 수 있습니다.
- 수신 거부 시 맞춤형 서비스 및 이벤트 정보를 받아보실 수 없습니다.

6. 수신 동의 철회 방법
- 앱 내 설정 메뉴에서 변경
- 고객센터(chchleeshop@gmail.com)로 요청
- 수신된 이메일 하단의 '수신거부' 링크 클릭

7. 개인정보 처리 위탁
마케팅 정보 발송을 위해 다음과 같이 개인정보 처리를 위탁합니다:
- 수탁업체: (주)이메일서비스
- 위탁업무: 이메일 발송 대행
- 보유 및 이용기간: 위탁계약 종료 시까지

8. 문의처
마케팅 정보 수신과 관련된 문의사항은 아래로 연락주시기 바랍니다.
- 이메일: chchleeshop@gmail.com
- 고객센터: chchleeshop@gmail.com

본 동의는 MOROKA 서비스 이용 중 언제든지 철회할 수 있으며, 철회 시 즉시 마케팅 정보 발송이 중단됩니다.
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
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.whiteOverlay20,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.whiteOverlay10,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _title,
                            style: AppTextStyles.displaySmall.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.lastModified,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.whiteOverlay10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.ghostWhite,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    _content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.8,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              // Bottom button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.obsidianBlack,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.whiteOverlay10,
                      width: 1,
                    ),
                  ),
                ),
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
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.confirm,
                      style: AppTextStyles.buttonLarge.copyWith(
                        color: AppColors.ghostWhite,
                        fontSize: 16,
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
