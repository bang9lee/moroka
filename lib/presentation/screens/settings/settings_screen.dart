import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/common/animated_gradient_background.dart';

import 'settings_viewmodel.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> 
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;
  
  // 진동 가능 여부 캐싱
  bool? _hasVibrator;
  
  @override
  void initState() {
    super.initState();
    _checkVibrator();
  }
  
  Future<void> _checkVibrator() async {
    _hasVibrator = await Vibration.hasVibrator();
  }
  
  Future<void> _vibrate() async {
    if (_hasVibrator == true) {
      Vibration.vibrate(duration: 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(settingsViewModelProvider);

    return Scaffold(
      body: AnimatedGradientBackground(
        gradients: const [
          AppColors.darkGradient,
          AppColors.mysticGradient,
        ],
        child: SafeArea(
          child: Column(
            children: [
              const _SettingsHeader(),
              Expanded(
                child: _SettingsList(
                  state: state,
                  onVibrate: _vibrate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 헤더를 별도 위젯으로 분리 (const 최적화)
class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
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
                  '설정',
                  style: AppTextStyles.displaySmall.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  '앱 환경을 조정하세요',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.fogGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 설정 리스트를 별도 위젯으로 분리
class _SettingsList extends ConsumerWidget {
  final SettingsState state;
  final VoidCallback onVibrate;
  
  const _SettingsList({
    required this.state,
    required this.onVibrate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(20),
      // 스크롤 성능 최적화
      physics: const BouncingScrollPhysics(),
      cacheExtent: 500, // 캐시 영역 확대
      children: [
        // Notifications Section
        const _SectionTitle(title: '알림 설정'),
        const SizedBox(height: 16),
        _OptimizedSwitchTile(
          title: '일일 타로 알림',
          subtitle: '매일 아침 오늘의 운세를 알려드립니다',
          value: state.dailyNotification,
          onChanged: (value) {
            ref.read(settingsViewModelProvider.notifier)
                .setDailyNotification(value);
          },
        ),
        const SizedBox(height: 12),
        _OptimizedSwitchTile(
          title: '주간 타로 리포트',
          subtitle: '매주 월요일 주간 운세를 알려드립니다',
          value: state.weeklyReport,
          onChanged: (value) {
            ref.read(settingsViewModelProvider.notifier)
                .setWeeklyReport(value);
          },
        ),
        
        const SizedBox(height: 32),
        
        // Display Section
        const _SectionTitle(title: '화면 설정'),
        const SizedBox(height: 16),
        _OptimizedSwitchTile(
          title: '진동 효과',
          subtitle: '카드 선택 시 진동 피드백',
          value: state.vibrationEnabled,
          onChanged: (value) {
            ref.read(settingsViewModelProvider.notifier)
                .setVibration(value);
          },
        ),
        const SizedBox(height: 12),
        _OptimizedSwitchTile(
          title: '애니메이션 효과',
          subtitle: '화면 전환 애니메이션',
          value: state.animationsEnabled,
          onChanged: (value) {
            ref.read(settingsViewModelProvider.notifier)
                .setAnimations(value);
          },
        ),
        
        const SizedBox(height: 32),
        
        // Data Management Section
        const _SectionTitle(title: '데이터 관리'),
        const SizedBox(height: 16),
        _OptimizedActionTile(
          icon: Icons.cloud_download,
          title: '데이터 백업',
          subtitle: '클라우드에 데이터를 백업합니다',
          onTap: () {
            onVibrate();
            _showBackupDialog(context, ref);
          },
        ),
        const SizedBox(height: 12),
        _OptimizedActionTile(
          icon: Icons.delete_sweep,
          title: '캐시 삭제',
          subtitle: '임시 파일을 삭제하여 공간을 확보합니다',
          onTap: () {
            onVibrate();
            _showClearCacheDialog(context, ref);
          },
        ),
        const SizedBox(height: 12),
        _OptimizedActionTile(
          icon: Icons.delete_forever,
          title: '모든 데이터 삭제',
          subtitle: '모든 타로 기록과 설정을 삭제합니다',
          onTap: () {
            onVibrate();
            _showDeleteAllDialog(context, ref);
          },
          isDestructive: true,
        ),
        
        const SizedBox(height: 32),
        
        // Account Section
        const _SectionTitle(title: '계정'),
        const SizedBox(height: 16),
        _OptimizedActionTile(
          icon: Icons.lock,
          title: '비밀번호 변경',
          subtitle: '계정 보안을 위해 비밀번호를 변경합니다',
          onTap: () {
            onVibrate();
            _showPasswordChangeDialog(context, ref);
          },
        ),
        const SizedBox(height: 12),
        _OptimizedActionTile(
          icon: Icons.exit_to_app,
          title: '계정 삭제',
          subtitle: '영구적으로 계정을 삭제합니다',
          onTap: () {
            onVibrate();
            _showAccountDeleteDialog(context, ref);
          },
          isDestructive: true,
        ),
      ],
    );
  }
}

// 섹션 타이틀 (const 최적화)
class _SectionTitle extends StatelessWidget {
  final String title;
  
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textMystic,
      ),
    );
  }
}

// 최적화된 스위치 타일 (애니메이션 제거)
class _OptimizedSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const _OptimizedSwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Glass morphism 대신 단순한 컨테이너 사용
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blackOverlay20,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.mysticPurple,
            inactiveThumbColor: AppColors.fogGray,
            inactiveTrackColor: AppColors.blackOverlay40,
          ),
        ],
      ),
    );
  }
}

// 최적화된 액션 타일 (애니메이션 제거)
class _OptimizedActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _OptimizedActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDestructive 
              ? AppColors.bloodMoon.withAlpha(20)
              : AppColors.blackOverlay20,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive
                ? AppColors.bloodMoon.withAlpha(100)
                : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.bloodMoon.withAlpha(50)
                    : AppColors.mysticPurple.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDestructive 
                    ? AppColors.crimsonGlow 
                    : AppColors.evilGlow,
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
                      color: isDestructive ? AppColors.crimsonGlow : null,
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
              size: 16,
              color: AppColors.fogGray,
            ),
          ],
        ),
      ),
    );
  }
}

// Dialog helper functions
void _showBackupDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.shadowGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      title: Text(
        '데이터 백업',
        style: AppTextStyles.displaySmall.copyWith(fontSize: 20),
      ),
      content: Text(
        '클라우드에 데이터를 백업하시겠습니까?',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.fogGray,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            '취소',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.textMystic,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            try {
              await ref.read(settingsViewModelProvider.notifier).backupData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('백업이 완료되었습니다')),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('백업 실패: ${e.toString()}'),
                    backgroundColor: AppColors.bloodMoon,
                  ),
                );
              }
            }
          },
          child: Text(
            '백업',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.mysticPurple,
            ),
          ),
        ),
      ],
    ),
  );
}

void _showClearCacheDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.shadowGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      title: Text(
        '캐시 삭제',
        style: AppTextStyles.displaySmall.copyWith(fontSize: 20),
      ),
      content: Text(
        '임시 파일을 삭제하시겠습니까?',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.fogGray,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            '취소',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.textMystic,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await ref.read(settingsViewModelProvider.notifier).clearCache();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('캐시가 삭제되었습니다')),
              );
            }
          },
          child: Text(
            '삭제',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.mysticPurple,
            ),
          ),
        ),
      ],
    ),
  );
}

void _showDeleteAllDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.shadowGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      title: Text(
        '모든 데이터 삭제',
        style: AppTextStyles.displaySmall.copyWith(
          fontSize: 20,
          color: AppColors.crimsonGlow,
        ),
      ),
      content: Text(
        '모든 타로 기록과 설정이 영구적으로 삭제됩니다.\n이 작업은 되돌릴 수 없습니다.',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.fogGray,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            '취소',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.textMystic,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            try {
              await ref.read(settingsViewModelProvider.notifier)
                  .deleteAllData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('모든 데이터가 삭제되었습니다')),
                );
                context.go('/login');
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('삭제 실패: ${e.toString()}'),
                    backgroundColor: AppColors.bloodMoon,
                  ),
                );
              }
            }
          },
          child: Text(
            '삭제',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.crimsonGlow,
            ),
          ),
        ),
      ],
    ),
  );
}

void _showPasswordChangeDialog(BuildContext context, WidgetRef ref) {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.shadowGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      title: Text(
        '비밀번호 변경',
        style: AppTextStyles.displaySmall.copyWith(fontSize: 20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PasswordField(
            controller: currentPasswordController,
            label: '현재 비밀번호',
          ),
          const SizedBox(height: 16),
          _PasswordField(
            controller: newPasswordController,
            label: '새 비밀번호',
          ),
          const SizedBox(height: 16),
          _PasswordField(
            controller: confirmPasswordController,
            label: '새 비밀번호 확인',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            '취소',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.textMystic,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (newPasswordController.text != 
                confirmPasswordController.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('새 비밀번호가 일치하지 않습니다'),
                  backgroundColor: AppColors.bloodMoon,
                ),
              );
              return;
            }
            
            try {
              await ref.read(settingsViewModelProvider.notifier)
                  .changePassword(
                currentPassword: currentPasswordController.text,
                newPassword: newPasswordController.text,
              );
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('비밀번호가 변경되었습니다')),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('비밀번호 변경 실패: ${e.toString()}'),
                    backgroundColor: AppColors.bloodMoon,
                  ),
                );
              }
            }
          },
          child: Text(
            '변경',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.mysticPurple,
            ),
          ),
        ),
      ],
    ),
  );
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  
  const _PasswordField({
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(color: AppColors.ghostWhite),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.fogGray),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mysticPurple),
        ),
      ),
    );
  }
}

void _showAccountDeleteDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.shadowGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      title: Text(
        '계정 삭제',
        style: AppTextStyles.displaySmall.copyWith(
          fontSize: 20,
          color: AppColors.crimsonGlow,
        ),
      ),
      content: Text(
        '계정을 삭제하면 모든 데이터가 영구적으로 삭제됩니다.\n이 작업은 되돌릴 수 없습니다.',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.fogGray,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            '취소',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.textMystic,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            try {
              await ref.read(settingsViewModelProvider.notifier)
                  .deleteAccount();
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('계정이 삭제되었습니다')),
                );
                context.go('/login');
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('계정 삭제 실패: ${e.toString()}'),
                    backgroundColor: AppColors.bloodMoon,
                  ),
                );
              }
            }
          },
          child: Text(
            '삭제',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.crimsonGlow,
            ),
          ),
        ),
      ],
    ),
  );
}