// File: lib/presentation/widgets/common/menu_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/app_logger.dart';
import '../../../providers.dart';
import '../../screens/login/login_viewmodel.dart';
import 'glass_morphism_container.dart';

/// 메뉴 바텀시트
/// 사용자 프로필과 주요 메뉴를 표시합니다.
class MenuBottomSheet extends ConsumerWidget {
  const MenuBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.shadowGray,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: const Border(
              top: BorderSide(color: AppColors.cardBorder, width: 1),
              left: BorderSide(color: AppColors.cardBorder, width: 1),
              right: BorderSide(color: AppColors.cardBorder, width: 1),
            ),
            boxShadow: [
              const BoxShadow(
                color: AppColors.blackOverlay80,
                blurRadius: 30,
                offset: Offset(0, -10),
              ),
              BoxShadow(
                color: AppColors.evilGlow.withAlpha(50),
                blurRadius: 50,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.whiteOverlay30,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // User Profile Section
                    currentUser.when(
                      data: (user) => _UserProfileSection(user: user),
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mysticPurple,
                        ),
                      ),
                      error: (_, __) => const SizedBox(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Menu Items
                    const _MenuItem(
                      icon: Icons.history,
                      title: '지난 타로 기록',
                      subtitle: '과거의 운명을 되돌아보세요',
                      route: '/history',
                    ),
                    
                    const SizedBox(height: 12),
                    
                    const _MenuItem(
                      icon: Icons.analytics,
                      title: '통계 & 분석',
                      subtitle: '당신의 운명 패턴을 분석합니다',
                      route: '/statistics',
                    ),
                    
                    const SizedBox(height: 12),
                    
                    const _MenuItem(
                      icon: Icons.settings,
                      title: '설정',
                      subtitle: '앱 환경을 조정하세요',
                      route: '/settings',
                    ),
                    
                    const SizedBox(height: 12),
                    
                    const _MenuItem(
                      icon: Icons.info_outline,
                      title: '앱 정보',
                      subtitle: 'Moroka - 불길한 속삭임',
                      route: '/about',
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Logout button
                    const _LogoutButton(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 사용자 프로필 섹션
class _UserProfileSection extends StatelessWidget {
  final dynamic user;
  
  const _UserProfileSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return GlassMorphismContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  AppColors.mysticPurple,
                  AppColors.deepViolet,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.mysticPurple.withAlpha(100),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: AppColors.ghostWhite,
            ),
          ).animate().scale(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
          ),
          
          const SizedBox(height: 16),
          
          // User info
          Text(
            user?.displayName ?? '익명의 영혼',
            style: AppTextStyles.displaySmall.copyWith(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? '',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.fogGray,
            ),
          ),
          const SizedBox(height: 16),
          
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                label: '총 리딩',
                value: '${user?.totalReadings ?? 0}',
              ),
              Container(
                width: 1,
                height: 30,
                color: AppColors.divider,
              ),
              _StatItem(
                label: '가입일',
                value: _formatDate(user?.createdAt),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

/// 통계 아이템
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  
  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.displaySmall.copyWith(
            fontSize: 24,
            color: AppColors.textMystic,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.fogGray,
          ),
        ),
      ],
    );
  }
}

/// 메뉴 아이템
class _MenuItem extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        await _vibrate();
        if (context.mounted) {
          Navigator.pop(context);
          context.push(route);
        }
      },
      child: GlassMorphismContainer(
        padding: const EdgeInsets.all(16),
        backgroundColor: AppColors.blackOverlay20,
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
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.fogGray,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.fogGray,
              size: 16,
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }
  
  Future<void> _vibrate() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 50);
      }
    } catch (_) {
      // Fail silently
    }
  }
}

/// 로그아웃 버튼
class _LogoutButton extends ConsumerWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        await _vibrate();
        if (context.mounted) {
          _showLogoutDialog(context, ref);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.bloodMoon.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.bloodMoon,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            '로그아웃',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.crimsonGlow,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 400),
    );
  }
  
  Future<void> _vibrate() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 50);
      }
    } catch (_) {
      // Fail silently
    }
  }
  
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.shadowGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        title: Text(
          '정말 떠나시겠습니까?',
          style: AppTextStyles.displaySmall.copyWith(fontSize: 20),
        ),
        content: Text(
          '운명의 문이 닫히면\n다시 돌아와야 합니다',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.fogGray,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              '머무르기',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textMystic,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              AppLogger.debug('Starting logout process');
              
              // 로딩 표시
              Navigator.pop(dialogContext);
              
              // 로딩 다이얼로그 표시
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const PopScope(
                  canPop: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mysticPurple,
                    ),
                  ),
                ),
              );
              
              try {
                // 광고 서비스 정리
                AppLogger.debug('Cleaning up ads');
                ref.read(adRepositoryProvider).cleanUp();
                
                // 채팅 카운트 초기화
                AppLogger.debug('Resetting chat count');
                ref.read(chatTurnCountProvider.notifier).state = 0;
                
                // 로그아웃 수행
                AppLogger.debug('Performing sign out');
                await ref.read(loginViewModelProvider.notifier).signOut();
                
                // 약간의 딜레이 (리소스 정리 완료 대기)
                await Future.delayed(const Duration(milliseconds: 500));
                
                if (context.mounted) {
                  AppLogger.debug('Navigating to login page');
                  
                  // 모든 다이얼로그와 페이지 닫기
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  
                  // 로그인 페이지로 이동
                  context.go('/login');
                }
              } catch (e, stack) {
                AppLogger.error('Logout error', e, stack);
                
                if (context.mounted) {
                  // 로딩 다이얼로그 닫기
                  Navigator.pop(context);
                  
                  // 에러 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('로그아웃 중 오류가 발생했습니다'),
                      backgroundColor: AppColors.bloodMoon,
                    ),
                  );
                }
              }
            },
            child: Text(
              '떠나기',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.crimsonGlow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}