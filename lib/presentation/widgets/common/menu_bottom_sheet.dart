import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers.dart';
import '../../screens/login/login_viewmodel.dart';
import 'glass_morphism_container.dart';

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
                      data: (user) => GlassMorphismContainer(
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
                                _buildStat('총 리딩', '${user?.totalReadings ?? 0}'),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: AppColors.divider,
                                ),
                                _buildStat('가입일', _formatDate(user?.createdAt)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const SizedBox(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Menu Items
                    _buildMenuItem(
                      icon: Icons.history,
                      title: '지난 타로 기록',
                      subtitle: '과거의 운명을 되돌아보세요',
                      onTap: () async {
                        await _vibrate();
                        if (context.mounted) {
                          Navigator.pop(context);
                          context.push('/history');
                        }
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildMenuItem(
                      icon: Icons.analytics,
                      title: '통계 & 분석',
                      subtitle: '당신의 운명 패턴을 분석합니다',
                      onTap: () async {
                        await _vibrate();
                        if (context.mounted) {
                          Navigator.pop(context);
                          context.push('/statistics');
                        }
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildMenuItem(
                      icon: Icons.settings,
                      title: '설정',
                      subtitle: '앱 환경을 조정하세요',
                      onTap: () async {
                        await _vibrate();
                        if (context.mounted) {
                          Navigator.pop(context);
                          context.push('/settings');
                        }
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: '앱 정보',
                      subtitle: 'Moroka - 불길한 속삭임',
                      onTap: () async {
                        await _vibrate();
                        if (context.mounted) {
                          Navigator.pop(context);
                          context.push('/about');
                        }
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Logout button
                    GestureDetector(
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildStat(String label, String value) {
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
  
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
  
  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
  
  Future<void> _vibrate() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 50);
    }
  }
  
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.pop(context),
            child: Text(
              '머무르기',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textMystic,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(loginViewModelProvider.notifier).signOut();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                context.go('/login');
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