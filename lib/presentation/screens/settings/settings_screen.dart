import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/locale_provider.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/accessible_icon_button.dart';

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
    final l10n = AppLocalizations.of(context)!;
    
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
            child: AccessibleIconButton(
              onPressed: () => context.pop(),
              icon: Icons.arrow_back,
              semanticLabel: l10n.back,
              color: AppColors.ghostWhite,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.menuSettings,
                  style: AppTextStyles.displaySmall.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.menuSettingsDesc,
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
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    
    return ListView(
      padding: const EdgeInsets.all(20),
      // 스크롤 성능 최적화
      physics: const BouncingScrollPhysics(),
      cacheExtent: 500, // 캐시 영역 확대
      children: [
        // Language Section
        _SectionTitle(title: l10n.settingsLanguageTitle),
        const SizedBox(height: 16),
        _LanguageSelector(
          currentLocale: currentLocale,
          onVibrate: onVibrate,
        ),
        
        const SizedBox(height: 32),
        
        // Notifications Section
        _SectionTitle(title: l10n.settingsNotificationTitle),
        const SizedBox(height: 16),
        _OptimizedSwitchTile(
          title: l10n.settingsDailyNotification,
          subtitle: l10n.settingsDailyNotificationDesc,
          value: state.dailyNotification,
          onChanged: (value) {
            ref.read(settingsViewModelProvider.notifier)
                .setDailyNotification(value);
          },
        ),
        const SizedBox(height: 12),
        _OptimizedSwitchTile(
          title: l10n.settingsWeeklyReport,
          subtitle: l10n.settingsWeeklyReportDesc,
          value: state.weeklyReport,
          onChanged: (value) {
            ref.read(settingsViewModelProvider.notifier)
                .setWeeklyReport(value);
          },
        ),
        
        const SizedBox(height: 32),
        
        // Display Section
        _SectionTitle(title: l10n.settingsDisplayTitle),
        const SizedBox(height: 16),
        _OptimizedSwitchTile(
          title: l10n.settingsVibration,
          subtitle: l10n.settingsVibrationDesc,
          value: state.vibrationEnabled,
          onChanged: (value) {
            ref.read(settingsViewModelProvider.notifier)
                .setVibration(value);
          },
        ),
        const SizedBox(height: 12),
        _OptimizedSwitchTile(
          title: l10n.settingsAnimations,
          subtitle: l10n.settingsAnimationsDesc,
          value: state.animationsEnabled,
          onChanged: (value) {
            ref.read(settingsViewModelProvider.notifier)
                .setAnimations(value);
          },
        ),
        
        const SizedBox(height: 32),
        
        // Data Management Section
        _SectionTitle(title: l10n.settingsDataTitle),
        const SizedBox(height: 16),
        _OptimizedActionTile(
          icon: Icons.cloud_download,
          title: l10n.settingsBackupData,
          subtitle: l10n.settingsBackupDataDesc,
          onTap: () {
            onVibrate();
            _showBackupDialog(context, ref);
          },
        ),
        const SizedBox(height: 12),
        _OptimizedActionTile(
          icon: Icons.delete_sweep,
          title: l10n.settingsClearCache,
          subtitle: l10n.settingsClearCacheDesc,
          onTap: () {
            onVibrate();
            _showClearCacheDialog(context, ref);
          },
        ),
        const SizedBox(height: 12),
        _OptimizedActionTile(
          icon: Icons.delete_forever,
          title: l10n.settingsDeleteData,
          subtitle: l10n.settingsDeleteDataDesc,
          onTap: () {
            onVibrate();
            _showDeleteAllDialog(context, ref);
          },
          isDestructive: true,
        ),
        
        const SizedBox(height: 32),
        
        // Account Section
        _SectionTitle(title: l10n.settingsAccountTitle),
        const SizedBox(height: 16),
        _OptimizedActionTile(
          icon: Icons.lock,
          title: l10n.settingsChangePassword,
          subtitle: l10n.settingsChangePasswordDesc,
          onTap: () {
            onVibrate();
            _showPasswordChangeDialog(context, ref);
          },
        ),
        const SizedBox(height: 12),
        _OptimizedActionTile(
          icon: Icons.exit_to_app,
          title: l10n.settingsDeleteAccount,
          subtitle: l10n.settingsDeleteAccountDesc,
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
          Semantics(
            label: '$title: ${value ? AppLocalizations.of(context)!.on : AppLocalizations.of(context)!.off}',
            toggled: value,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.mysticPurple,
              inactiveThumbColor: AppColors.fogGray,
              inactiveTrackColor: AppColors.blackOverlay40,
            ),
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
    return Semantics(
      label: '$title. $subtitle',
      button: true,
      child: GestureDetector(
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
      ),
    );
  }
}

// Dialog helper functions
void _showBackupDialog(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.shadowGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      title: Text(
        l10n.dialogBackupTitle,
        style: AppTextStyles.dialogTitle,
      ),
      content: Text(
        l10n.dialogBackupMessage,
        style: AppTextStyles.dialogContent.copyWith(
          color: AppColors.fogGray,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.cancel,
            style: AppTextStyles.dialogButton.copyWith(
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
                  SnackBar(content: Text(l10n.successBackup)),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.errorBackup(e.toString())),
                    backgroundColor: AppColors.bloodMoon,
                  ),
                );
              }
            }
          },
          child: Text(
            l10n.backup,
            style: AppTextStyles.dialogButton.copyWith(
              color: AppColors.mysticPurple,
            ),
          ),
        ),
      ],
    ),
  );
}

void _showClearCacheDialog(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  
  // Get cache statistics
  final cacheStats = await ref.read(settingsViewModelProvider.notifier).getCacheStatistics();
  
  if (!context.mounted) return;
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.shadowGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      title: Text(
        l10n.dialogClearCacheTitle,
        style: AppTextStyles.dialogTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dialogClearCacheMessage,
            style: AppTextStyles.dialogContent.copyWith(
              color: AppColors.fogGray,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.blackOverlay20,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cache Statistics',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.mysticPurple,
                  ),
                ),
                const SizedBox(height: 8),
                _buildCacheStatRow('AI Interpretations', '${cacheStats['aiInterpretations'] ?? 0}'),
                _buildCacheStatRow('Reading Histories', '${cacheStats['readingHistories'] ?? 0}'),
                _buildCacheStatRow('Cached Images', '${cacheStats['cachedImages'] ?? 0}'),
                _buildCacheStatRow('Total Size', '${cacheStats['totalSizeMB'] ?? '0.00'} MB'),
              ],
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
                SnackBar(content: Text(l10n.successClearCache)),
              );
            }
          },
          child: Text(
            l10n.delete,
            style: AppTextStyles.dialogButton.copyWith(
              color: AppColors.mysticPurple,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildCacheStatRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.fogGray,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.ghostWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

void _showDeleteAllDialog(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.shadowGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      title: Text(
        l10n.dialogDeleteDataTitle,
        style: AppTextStyles.dialogTitle.copyWith(
          color: AppColors.crimsonGlow,
        ),
      ),
      content: Text(
        l10n.dialogDeleteDataMessage,
        style: AppTextStyles.dialogContent.copyWith(
          color: AppColors.fogGray,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.cancel,
            style: AppTextStyles.dialogButton.copyWith(
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
                  SnackBar(content: Text(l10n.successDeleteData)),
                );
                context.go('/login');
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.errorDeleteData(e.toString())),
                    backgroundColor: AppColors.bloodMoon,
                  ),
                );
              }
            }
          },
          child: Text(
            l10n.delete,
            style: AppTextStyles.dialogButton.copyWith(
              color: AppColors.crimsonGlow,
            ),
          ),
        ),
      ],
    ),
  );
}

void _showPasswordChangeDialog(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;
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
        l10n.dialogChangePasswordTitle,
        style: AppTextStyles.dialogTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PasswordField(
            controller: currentPasswordController,
            label: l10n.currentPassword,
          ),
          const SizedBox(height: 16),
          _PasswordField(
            controller: newPasswordController,
            label: l10n.newPassword,
          ),
          const SizedBox(height: 16),
          _PasswordField(
            controller: confirmPasswordController,
            label: l10n.confirmNewPassword,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.cancel,
            style: AppTextStyles.dialogButton.copyWith(
              color: AppColors.textMystic,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (newPasswordController.text != 
                confirmPasswordController.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.errorPasswordMismatch),
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
                  SnackBar(content: Text(l10n.successChangePassword)),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.errorChangePassword(e.toString())),
                    backgroundColor: AppColors.bloodMoon,
                  ),
                );
              }
            }
          },
          child: Text(
            l10n.change,
            style: AppTextStyles.dialogButton.copyWith(
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
  final l10n = AppLocalizations.of(context)!;
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.shadowGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      title: Text(
        l10n.dialogDeleteAccountTitle,
        style: AppTextStyles.dialogTitle.copyWith(
          color: AppColors.crimsonGlow,
        ),
      ),
      content: Text(
        l10n.dialogDeleteAccountMessage,
        style: AppTextStyles.dialogContent.copyWith(
          color: AppColors.fogGray,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.cancel,
            style: AppTextStyles.dialogButton.copyWith(
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
                  SnackBar(content: Text(l10n.successDeleteAccount)),
                );
                context.go('/login');
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.errorDeleteAccount(e.toString())),
                    backgroundColor: AppColors.bloodMoon,
                  ),
                );
              }
            }
          },
          child: Text(
            l10n.delete,
            style: AppTextStyles.dialogButton.copyWith(
              color: AppColors.crimsonGlow,
            ),
          ),
        ),
      ],
    ),
  );
}

// Language Selector Widget
class _LanguageSelector extends ConsumerWidget {
  final Locale? currentLocale;
  final VoidCallback onVibrate;
  
  const _LanguageSelector({
    required this.currentLocale,
    required this.onVibrate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final systemLocale = View.of(context).platformDispatcher.locale;
    final effectiveLocale = currentLocale ?? systemLocale;
    
    return Semantics(
      label: '${l10n.settingsLanguageLabel}: ${localeNames[effectiveLocale.languageCode] ?? effectiveLocale.languageCode}',
      button: true,
      child: GestureDetector(
        onTap: () {
          onVibrate();
          _showLanguageDialog(context, ref, effectiveLocale);
        },
        child: Container(
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.mysticPurple.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.language,
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
                    l10n.settingsLanguageLabel,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localeNames[effectiveLocale.languageCode] ?? effectiveLocale.languageCode,
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
      ),
    );
  }
  
  void _showLanguageDialog(BuildContext context, WidgetRef ref, Locale currentLocale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.shadowGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        title: Text(
          AppLocalizations.of(context)!.settingsLanguageDesc,
          style: AppTextStyles.dialogTitle,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: supportedLocales.length,
            itemBuilder: (context, index) {
              final locale = supportedLocales[index];
              final isSelected = locale.languageCode == currentLocale.languageCode;
              
              return Semantics(
                label: localeNames[locale.languageCode] ?? locale.languageCode,
                selected: isSelected,
                child: RadioListTile<Locale>(
                  value: locale,
                  groupValue: currentLocale,
                  onChanged: (Locale? value) {
                    if (value != null) {
                      ref.read(localeProvider.notifier).setLocale(value);
                      Navigator.pop(context);
                    }
                  },
                  title: Text(
                    localeNames[locale.languageCode] ?? locale.languageCode,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: isSelected ? AppColors.mysticPurple : AppColors.ghostWhite,
                    ),
                  ),
                  activeColor: AppColors.mysticPurple,
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.logoutCancel,
              style: AppTextStyles.dialogButton.copyWith(
                color: AppColors.textMystic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}