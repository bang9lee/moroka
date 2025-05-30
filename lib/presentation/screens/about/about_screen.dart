import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  String _version = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _loadAppInfo();
    _logoController.repeat();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        gradients: const [
          AppColors.darkGradient,
          AppColors.mysticGradient,
        ],
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
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
                      decoration: BoxDecoration(
                        color: AppColors.whiteOverlay10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.ghostWhite,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '앱 정보',
                            style: AppTextStyles.displaySmall.copyWith(
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Moroka - 불길한 속삭임',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.fogGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Logo Section
                    Center(
                      child: AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _logoController.value * 2 * 3.14159,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.evilGlow,
                                    AppColors.mysticPurple,
                                    AppColors.deepViolet,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.evilGlow.withAlpha(100),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.remove_red_eye,
                                size: 60,
                                color: AppColors.ghostWhite,
                              ),
                            ),
                          );
                        },
                      ),
                    ).animate().scale(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutBack,
                        ),

                    const SizedBox(height: 32),

                    // App Name & Version
                    Text(
                      'MOROKA',
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 36,
                        letterSpacing: 8,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 300))
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 8),

                    Text(
                      '불길한 속삭임',
                      style: AppTextStyles.mysticTitle.copyWith(
                        fontSize: 20,
                        color: AppColors.textMystic,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 400))
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 16),

                    Text(
                      'Version $_version ($_buildNumber)',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.fogGray,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 500)),

                    const SizedBox(height: 40),

                    // Description
                    GlassMorphismContainer(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            size: 40,
                            color: AppColors.evilGlow,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '운명의 카드가 당신을 기다립니다',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Moroka는 고대의 신비로운 타로 카드를 통해 당신의 운명을 읽어드립니다. '
                            '78장의 카드 하나하나에 담긴 우주의 메시지를 AI 타로 마스터가 해석해 드립니다.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.fogGray,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 600))
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 24),

                    // Features
                    _buildFeatureCard(
                      icon: Icons.style,
                      title: '78장의 전통 타로 카드',
                      description: '메이저 아르카나 22장과 마이너 아르카나 56장의 완전한 덱',
                      delay: 700,
                    ),

                    const SizedBox(height: 12),

                    _buildFeatureCard(
                      icon: Icons.dashboard,
                      title: '5가지 전문 배열법',
                      description: '원카드부터 켈틱 크로스까지 다양한 리딩 방법 제공',
                      delay: 800,
                    ),

                    const SizedBox(height: 12),

                    _buildFeatureCard(
                      icon: Icons.psychology,
                      title: 'AI 타로 마스터',
                      description: '100년 경력의 타로 마스터처럼 깊이 있는 해석 제공',
                      delay: 900,
                    ),

                    const SizedBox(height: 12),

                    _buildFeatureCard(
                      icon: Icons.chat,
                      title: '대화형 상담',
                      description: '카드에 대해 궁금한 점을 자유롭게 질문하세요',
                      delay: 1000,
                    ),

                    const SizedBox(height: 40),

                    // Links
                    _buildLinkTile(
                      icon: Icons.privacy_tip,
                      title: '개인정보 처리방침',
                      onTap: () => _launchUrl('https://moroka.app/privacy'),
                    ),

                    const SizedBox(height: 12),

                    _buildLinkTile(
                      icon: Icons.description,
                      title: '이용약관',
                      onTap: () => _launchUrl('https://moroka.app/terms'),
                    ),

                    const SizedBox(height: 12),

                    _buildLinkTile(
                      icon: Icons.mail,
                      title: '문의하기',
                      onTap: () => _launchUrl('mailto:support@moroka.app'),
                    ),

                    const SizedBox(height: 40),

                    // Developer Info
                    GlassMorphismContainer(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: AppColors.blackOverlay20,
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'Today`s Studio',
                            style: AppTextStyles.displaySmall.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '© 2025 Today`s Studio. All rights reserved.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.ashGray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 1100)),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required int delay,
  }) {
    return GlassMorphismContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.mysticPurple.withAlpha(50),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.evilGlow,
              size: 24,
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.fogGray,
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
        .slideY(
          begin: 0.1,
          end: 0,
          delay: Duration(milliseconds: delay),
          duration: const Duration(milliseconds: 400),
        );
  }

  Widget _buildLinkTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassMorphismContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.whiteOverlay10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.textMystic,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.fogGray,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 400))
        .slideX(begin: 0.1, end: 0);
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('URL을 열 수 없습니다: $urlString'),
            backgroundColor: AppColors.bloodMoon,
          ),
        );
      }
    }
  }
}
