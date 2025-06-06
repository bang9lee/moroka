import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'package:moroka/core/constants/app_colors.dart';
import 'package:moroka/core/constants/app_text_styles.dart';
import 'package:moroka/core/utils/haptic_utils.dart';
import 'package:moroka/presentation/screens/settings/settings_viewmodel.dart';
import 'package:moroka/presentation/screens/settings/settings_state.dart';
import 'package:moroka/presentation/widgets/common/animated_gradient_background.dart';
import 'package:moroka/presentation/widgets/common/glass_morphism_container.dart';
import 'package:moroka/presentation/widgets/common/custom_loading_indicator.dart';
import 'package:moroka/providers/locale_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> 
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _showLanguageDialog() async {
    final l10n = AppLocalizations.of(context)!;
    
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: GlassMorphismContainer(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.languageTitle,
                      style: AppTextStyles.heading,
                    ),
                    const SizedBox(height: 24),
                    ..._buildLanguageOptions(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildLanguageOptions() {
    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
      {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
      {'code': 'hi', 'name': 'हिन्दी', 'flag': '🇮🇳'},
      {'code': 'ko', 'name': '한국어', 'flag': '🇰🇷'},
      {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
      {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
      {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
      {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
      {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
      {'code': 'th', 'name': 'ไทย', 'flag': '🇹🇭'},
      {'code': 'vi', 'name': 'Tiếng Việt', 'flag': '🇻🇳'},
    ];

    return languages.map((lang) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
          onTap: () {
            HapticUtils.lightImpact();
            ref.read(settingsViewModelProvider.notifier)
                .changeLanguage(lang['code']!);
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.divider.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lang['name']!,
                    style: AppTextStyles.body,
                  ),
                ),
                if (ref.watch(localeProvider)?.languageCode == lang['code'])
                  const Icon(Icons.check, color: AppColors.primary),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<void> _showLogoutConfirmDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.logoutTitle,
            style: AppTextStyles.heading3,
          ),
          content: Text(
            l10n.logoutMessage,
            style: AppTextStyles.body1,
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticUtils.lightImpact();
                Navigator.of(context).pop(false);
              },
              child: Text(
                l10n.logoutCancel,
                style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                HapticUtils.lightImpact();
                Navigator.of(context).pop(true);
              },
              child: Text(
                l10n.logoutConfirm,
                style: AppTextStyles.body1.copyWith(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );

    if (result ?? false) {
      await ref.read(settingsViewModelProvider.notifier).logout();
    }
  }

  Future<void> _showDeleteAccountConfirmDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.dialogDeleteAccountTitle,
            style: AppTextStyles.heading3.copyWith(color: AppColors.error),
          ),
          content: Text(
            l10n.dialogDeleteAccountMessage,
            style: AppTextStyles.body1,
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticUtils.lightImpact();
                Navigator.of(context).pop(false);
              },
              child: Text(
                l10n.logoutCancel,
                style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                HapticUtils.lightImpact();
                Navigator.of(context).pop(true);
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.error.withValues(alpha: 0.1),
              ),
              child: Text(
                l10n.dialogDeleteAccountTitle,
                style: AppTextStyles.body1.copyWith(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );

    if (result ?? false) {
      await ref.read(settingsViewModelProvider.notifier).deleteAccount();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(settingsViewModelProvider);
    
    ref.listen<SettingsState>(
      settingsViewModelProvider,
      (previous, next) {
        if (next.notification != null) {
          _showNotification(next.notification!);
        }
        
        if (next.navigationRoute != null) {
          context.go(next.navigationRoute!);
        }
      },
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            HapticUtils.lightImpact();
            context.pop();
          },
        ),
        title: Text(
          l10n.menuSettings,
          style: AppTextStyles.heading2,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const AnimatedGradientBackground(child: SizedBox.expand()),
          SafeArea(
            child: state.isLoading
                ? const Center(child: CustomLoadingIndicator())
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildSettingsContent(state, l10n),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent(SettingsState state, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(l10n.settingsLanguageTitle),
          const SizedBox(height: 16),
          _buildSettingsTile(
            icon: Icons.language,
            title: l10n.settingsLanguageLabel,
            subtitle: _getCurrentLanguageName(),
            onTap: _showLanguageDialog,
          ),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: l10n.settingsDailyNotification,
            subtitle: l10n.settingsDailyNotificationDesc,
            value: state.notificationsEnabled,
            onChanged: (value) async {
              await ref.read(settingsViewModelProvider.notifier)
                  .toggleNotifications(value);
            },
          ),
          _buildSwitchTile(
            icon: Icons.vibration,
            title: l10n.settingsVibration,
            subtitle: l10n.settingsVibrationDesc,
            value: state.vibrationEnabled,
            onChanged: (value) {
              ref.read(settingsViewModelProvider.notifier)
                  .toggleVibration(value);
            },
          ),
          _buildSwitchTile(
            icon: Icons.animation,
            title: l10n.settingsAnimations,
            subtitle: l10n.settingsAnimationsDesc,
            value: state.animationsEnabled,
            onChanged: (value) {
              ref.read(settingsViewModelProvider.notifier)
                  .toggleAnimations(value);
            },
          ),
          const SizedBox(height: 32),
          _buildSectionTitle(l10n.settingsAccountTitle),
          const SizedBox(height: 16),
          if (state.userEmail != null)
            _buildInfoTile(
              icon: Icons.email_outlined,
              title: l10n.emailLabel,
              value: state.userEmail!,
            ),
          _buildSettingsTile(
            icon: Icons.logout,
            title: l10n.logoutButton,
            titleColor: AppColors.error,
            onTap: _showLogoutConfirmDialog,
          ),
          _buildSettingsTile(
            icon: Icons.delete_forever,
            title: l10n.settingsDeleteAccount,
            titleColor: AppColors.error,
            onTap: _showDeleteAccountConfirmDialog,
          ),
          const SizedBox(height: 32),
          _buildSectionTitle(l10n.moreTitle),
          const SizedBox(height: 16),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: l10n.aboutTitle,
            onTap: () => context.push('/about'),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: AppTextStyles.heading3.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return GlassMorphismContainer(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          HapticUtils.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: titleColor ?? AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body1.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GlassMorphismContainer(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: (newValue) {
                HapticUtils.lightImpact();
                onChanged(newValue);
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return GlassMorphismContainer(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTextStyles.body1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentLanguageName() {
    final currentLocale = ref.watch(localeProvider)?.languageCode ?? 'en';
    final languageMap = {
      'en': 'English',
      'ko': '한국어',
      'ja': '日本語',
      'zh': '中文',
      'es': 'Español',
      'fr': 'Français',
      'de': 'Deutsch',
      'pt': 'Português',
      'hi': 'हिन्दी',
      'th': 'ไทย',
      'vi': 'Tiếng Việt',
    };
    return languageMap[currentLocale] ?? 'English';
  }

  void _showNotification(SettingsNotification notification) {
    final l10n = AppLocalizations.of(context)!;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_getNotificationMessage(notification, l10n)),
        backgroundColor: notification.type == NotificationType.error
            ? AppColors.error
            : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  String _getNotificationMessage(SettingsNotification notification, AppLocalizations l10n) {
    switch (notification.messageKey) {
      case 'languageChanged':
        return l10n.languageChanged;
      case 'notificationsEnabled':
        return l10n.notificationsEnabled;
      case 'notificationsDisabled':
        return l10n.notificationsDisabled;
      case 'vibrationEnabled':
        return l10n.vibrationEnabled;
      case 'vibrationDisabled':
        return l10n.vibrationDisabled;
      case 'animationsEnabled':
        return l10n.animationsEnabled;
      case 'animationsDisabled':
        return l10n.animationsDisabled;
      case 'logoutSuccess':
        return l10n.logoutSuccess;
      case 'deleteAccountSuccess':
        return l10n.deleteAccountSuccess;
      case 'errorOccurred':
        return l10n.errorOccurred;
      case 'notificationPermissionDenied':
        return l10n.notificationPermissionDenied;
      case 'cacheCleared':
        return 'Cache cleared successfully';
      case 'errorClearingCache':
        return 'Error clearing cache';
      case 'dataBackedUp':
        return notification.customMessage ?? l10n.successBackup;
      case 'errorBackingUp':
        return 'Error backing up data';
      case 'dataDeleted':
        return notification.customMessage ?? 'All data deleted';
      case 'errorDeletingData':
        return 'Error deleting data';
      case 'passwordChanged':
        return l10n.successChangePassword;
      case 'wrongPassword':
        return l10n.errorWrongPassword;
      case 'weakPassword':
        return l10n.errorWeakPassword;
      case 'errorChangingPassword':
        return 'Error changing password';
      default:
        return notification.customMessage ?? l10n.errorOccurred;
    }
  }
}