enum NotificationType { success, error, info }

class SettingsNotification {
  final NotificationType type;
  final String messageKey;
  final String? customMessage;

  const SettingsNotification({
    required this.type,
    required this.messageKey,
    this.customMessage,
  });
}

class SettingsState {
  final bool isLoading;
  final bool notificationsEnabled;
  final bool dailyNotification;
  final bool weeklyReport;
  final bool vibrationEnabled;
  final bool animationsEnabled;
  final String? userEmail;
  final String? errorMessage;
  final String? successMessage;
  final bool isChangingPassword;
  final bool isDeletingAccount;
  final bool isBackingUp;
  final bool isClearingCache;
  final bool isDeletingData;
  final Map<String, dynamic>? cacheStatistics;
  final SettingsNotification? notification;
  final String? navigationRoute;

  const SettingsState({
    this.isLoading = false,
    this.notificationsEnabled = false,
    this.dailyNotification = false,
    this.weeklyReport = false,
    this.vibrationEnabled = true,
    this.animationsEnabled = true,
    this.userEmail,
    this.errorMessage,
    this.successMessage,
    this.isChangingPassword = false,
    this.isDeletingAccount = false,
    this.isBackingUp = false,
    this.isClearingCache = false,
    this.isDeletingData = false,
    this.cacheStatistics,
    this.notification,
    this.navigationRoute,
  });

  SettingsState copyWith({
    bool? isLoading,
    bool? notificationsEnabled,
    bool? dailyNotification,
    bool? weeklyReport,
    bool? vibrationEnabled,
    bool? animationsEnabled,
    String? userEmail,
    String? errorMessage,
    String? successMessage,
    bool? isChangingPassword,
    bool? isDeletingAccount,
    bool? isBackingUp,
    bool? isClearingCache,
    bool? isDeletingData,
    Map<String, dynamic>? cacheStatistics,
    SettingsNotification? notification,
    String? navigationRoute,
    bool clearNotification = false,
    bool clearNavigationRoute = false,
    bool clearErrorMessage = false,
    bool clearSuccessMessage = false,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyNotification: dailyNotification ?? this.dailyNotification,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      userEmail: userEmail ?? this.userEmail,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      isChangingPassword: isChangingPassword ?? this.isChangingPassword,
      isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      isBackingUp: isBackingUp ?? this.isBackingUp,
      isClearingCache: isClearingCache ?? this.isClearingCache,
      isDeletingData: isDeletingData ?? this.isDeletingData,
      cacheStatistics: cacheStatistics ?? this.cacheStatistics,
      notification: clearNotification ? null : (notification ?? this.notification),
      navigationRoute: clearNavigationRoute ? null : (navigationRoute ?? this.navigationRoute),
    );
  }
}