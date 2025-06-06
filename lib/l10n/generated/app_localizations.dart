import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_th.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale.fromSubtags(languageCode: 'en', scriptCode: 'fallback'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('th'),
    Locale('vi'),
    Locale('zh')
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Moroka'**
  String get appName;

  /// Application tagline
  ///
  /// In en, this message translates to:
  /// **'Oracle of Shadows'**
  String get appTagline;

  /// Full application title
  ///
  /// In en, this message translates to:
  /// **'Moroka - Ominous Whispers'**
  String get appTitle;

  /// First onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'The Gate of Fate Opens'**
  String get onboardingTitle1;

  /// First onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Ancient wisdom meets modern technology\nto whisper your future'**
  String get onboardingDesc1;

  /// Second onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Truth in the Darkness'**
  String get onboardingTitle2;

  /// Second onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Tarot cards never lie\nThey only show the truth you can handle'**
  String get onboardingDesc2;

  /// Third onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'AI Reads Your Destiny'**
  String get onboardingTitle3;

  /// Third onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Artificial intelligence interprets your cards\nand guides your path through deep conversation'**
  String get onboardingDesc3;

  /// Fourth onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Are You Ready?'**
  String get onboardingTitle4;

  /// Fourth onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Every choice has its price\nIf you\'re ready to face your destiny...'**
  String get onboardingDesc4;

  /// Login screen title
  ///
  /// In en, this message translates to:
  /// **'You Have Returned'**
  String get loginTitle;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'We have been waiting for you'**
  String get loginSubtitle;

  /// Signup screen title
  ///
  /// In en, this message translates to:
  /// **'Contract of Fate'**
  String get signupTitle;

  /// Signup screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Register your soul'**
  String get signupSubtitle;

  /// Email input label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Password input label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Name input label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get loginButton;

  /// Signup button text
  ///
  /// In en, this message translates to:
  /// **'Register Soul'**
  String get signupButton;

  /// Google login button text
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get googleLogin;

  /// Google signup button text
  ///
  /// In en, this message translates to:
  /// **'Start with Google'**
  String get googleSignup;

  /// Link to login screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// Link to signup screen
  ///
  /// In en, this message translates to:
  /// **'First time? Sign up'**
  String get dontHaveAccount;

  /// Question asking user's current mood
  ///
  /// In en, this message translates to:
  /// **'How are you feeling now?'**
  String get moodQuestion;

  /// Button to select tarot spread
  ///
  /// In en, this message translates to:
  /// **'Select Tarot Spread'**
  String get selectSpreadButton;

  /// Mood: anxious
  ///
  /// In en, this message translates to:
  /// **'Anxious'**
  String get moodAnxious;

  /// Mood: lonely
  ///
  /// In en, this message translates to:
  /// **'Lonely'**
  String get moodLonely;

  /// Mood: curious
  ///
  /// In en, this message translates to:
  /// **'Curious'**
  String get moodCurious;

  /// Mood: fearful
  ///
  /// In en, this message translates to:
  /// **'Fearful'**
  String get moodFearful;

  /// Mood: hopeful
  ///
  /// In en, this message translates to:
  /// **'Hopeful'**
  String get moodHopeful;

  /// Mood: confused
  ///
  /// In en, this message translates to:
  /// **'Confused'**
  String get moodConfused;

  /// Mood: desperate
  ///
  /// In en, this message translates to:
  /// **'Desperate'**
  String get moodDesperate;

  /// Mood: expectant
  ///
  /// In en, this message translates to:
  /// **'Expectant'**
  String get moodExpectant;

  /// Mood: mystical
  ///
  /// In en, this message translates to:
  /// **'Mystical'**
  String get moodMystical;

  /// Spread selection screen title
  ///
  /// In en, this message translates to:
  /// **'Select Spread'**
  String get spreadSelectionTitle;

  /// Spread selection screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose a spread based on your current feelings'**
  String get spreadSelectionSubtitle;

  /// Beginner difficulty label
  ///
  /// In en, this message translates to:
  /// **'1-3 cards'**
  String get spreadDifficultyBeginner;

  /// Intermediate difficulty label
  ///
  /// In en, this message translates to:
  /// **'5-7 cards'**
  String get spreadDifficultyIntermediate;

  /// Advanced difficulty label
  ///
  /// In en, this message translates to:
  /// **'10 cards'**
  String get spreadDifficultyAdvanced;

  /// One card spread name
  ///
  /// In en, this message translates to:
  /// **'One Card'**
  String get spreadOneCard;

  /// Three card spread name
  ///
  /// In en, this message translates to:
  /// **'Three Cards'**
  String get spreadThreeCard;

  /// Celtic cross spread name
  ///
  /// In en, this message translates to:
  /// **'Celtic Cross'**
  String get spreadCelticCross;

  /// Relationship spread name
  ///
  /// In en, this message translates to:
  /// **'Relationship Spread'**
  String get spreadRelationship;

  /// Yes/No spread name
  ///
  /// In en, this message translates to:
  /// **'Yes/No'**
  String get spreadYesNo;

  /// Card selection screen title
  ///
  /// In en, this message translates to:
  /// **'Select the cards of fate'**
  String get selectCardTitle;

  /// Current mood label
  ///
  /// In en, this message translates to:
  /// **'Your current mood: '**
  String get currentMoodLabel;

  /// Current spread label
  ///
  /// In en, this message translates to:
  /// **'Selected spread: '**
  String get currentSpreadLabel;

  /// Message shown while shuffling
  ///
  /// In en, this message translates to:
  /// **'The threads of fate are intertwining...'**
  String get shufflingMessage;

  /// Card selection instruction
  ///
  /// In en, this message translates to:
  /// **'Follow your intuition and select the cards'**
  String get selectCardInstruction;

  /// Number of cards selected
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String cardsSelected(int count);

  /// Number of cards remaining to select
  ///
  /// In en, this message translates to:
  /// **'Select {count} more'**
  String cardsRemaining(int count);

  /// Label for today's card reading
  ///
  /// In en, this message translates to:
  /// **'Today\'s Card'**
  String get todaysCard;

  /// Label for three card spread
  ///
  /// In en, this message translates to:
  /// **'Three Card Spread'**
  String get threeCardSpread;

  /// Label for celtic cross spread
  ///
  /// In en, this message translates to:
  /// **'Celtic Cross Spread'**
  String get celticCrossSpread;

  /// Celtic Cross spread cross section label
  ///
  /// In en, this message translates to:
  /// **'Cross - Current Situation'**
  String get crossSection;

  /// Celtic Cross spread staff section label
  ///
  /// In en, this message translates to:
  /// **'Staff - Future Development'**
  String get staffSection;

  /// Label for relationship spread
  ///
  /// In en, this message translates to:
  /// **'Relationship Spread'**
  String get relationshipSpread;

  /// Label for yes/no spread
  ///
  /// In en, this message translates to:
  /// **'Yes/No Spread'**
  String get yesNoSpread;

  /// Generic label for spread reading
  ///
  /// In en, this message translates to:
  /// **'Spread Reading'**
  String get spreadReading;

  /// Instruction to tap card for more information
  ///
  /// In en, this message translates to:
  /// **'Tap card for details'**
  String get tapCardForDetails;

  /// Title for AI interpretation section
  ///
  /// In en, this message translates to:
  /// **'AI Interpretation'**
  String get interpretationSectionTitle;

  /// Description for one card reading
  ///
  /// In en, this message translates to:
  /// **'Single Card Reading'**
  String get oneCardReading;

  /// Description for three card reading
  ///
  /// In en, this message translates to:
  /// **'Past, Present, Future Reading'**
  String get threeCardReading;

  /// Description for celtic cross reading
  ///
  /// In en, this message translates to:
  /// **'10-Card In-Depth Analysis'**
  String get celticCrossReading;

  /// Description for relationship reading
  ///
  /// In en, this message translates to:
  /// **'Relationship Analysis'**
  String get relationshipReading;

  /// Description for yes/no reading
  ///
  /// In en, this message translates to:
  /// **'Yes or No Answer'**
  String get yesNoReading;

  /// Chat input hint
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessageHint;

  /// Button to continue tarot reading
  ///
  /// In en, this message translates to:
  /// **'Get deeper advice'**
  String get continueReading;

  /// Prompt to watch ad for continued reading
  ///
  /// In en, this message translates to:
  /// **'To hear the voice from deeper abyss,\nyou must check messages from another world.'**
  String get watchAdPrompt;

  /// Message shown while AI interprets cards
  ///
  /// In en, this message translates to:
  /// **'Interpreting the messages from the cards...'**
  String get interpretingSpread;

  /// Menu item: history
  ///
  /// In en, this message translates to:
  /// **'Past Tarot Records'**
  String get menuHistory;

  /// Menu item description: history
  ///
  /// In en, this message translates to:
  /// **'Look back at your past destinies'**
  String get menuHistoryDesc;

  /// Loading message for history screen
  ///
  /// In en, this message translates to:
  /// **'Loading history...'**
  String get loadingHistory;

  /// Menu item: statistics
  ///
  /// In en, this message translates to:
  /// **'Statistics & Analysis'**
  String get menuStatistics;

  /// Menu item description: statistics
  ///
  /// In en, this message translates to:
  /// **'Analyze your destiny patterns'**
  String get menuStatisticsDesc;

  /// Menu item: settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// Menu item description: settings
  ///
  /// In en, this message translates to:
  /// **'Adjust app environment'**
  String get menuSettingsDesc;

  /// Menu item: about
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menuAbout;

  /// Menu item description: about
  ///
  /// In en, this message translates to:
  /// **'Moroka - Oracle of Shadows'**
  String get menuAboutDesc;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// Logout dialog title
  ///
  /// In en, this message translates to:
  /// **'Are you really leaving?'**
  String get logoutTitle;

  /// Logout dialog message
  ///
  /// In en, this message translates to:
  /// **'When the gate of fate closes\nyou must return again'**
  String get logoutMessage;

  /// Logout dialog cancel button
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get logoutCancel;

  /// Logout dialog confirm button
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get logoutConfirm;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// Error: email field empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get errorEmailEmpty;

  /// Error: email format invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get errorEmailInvalid;

  /// Error: password field empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get errorPasswordEmpty;

  /// Error: password too short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get errorPasswordShort;

  /// Error: name field empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get errorNameEmpty;

  /// Error: login failed
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get errorLoginFailed;

  /// Error: signup failed
  ///
  /// In en, this message translates to:
  /// **'Signup failed'**
  String get errorSignupFailed;

  /// Error: Google login failed
  ///
  /// In en, this message translates to:
  /// **'Google login failed'**
  String get errorGoogleLoginFailed;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Please check your network connection'**
  String get errorNetworkFailed;

  /// Error loading user data
  ///
  /// In en, this message translates to:
  /// **'Unable to load user data'**
  String get errorUserDataLoad;

  /// User not found error
  ///
  /// In en, this message translates to:
  /// **'Email not registered'**
  String get errorUserNotFound;

  /// Wrong password error
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get errorWrongPassword;

  /// User disabled error
  ///
  /// In en, this message translates to:
  /// **'Account has been disabled'**
  String get errorUserDisabled;

  /// Too many requests error
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later'**
  String get errorTooManyRequests;

  /// Invalid credential error
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get errorInvalidCredential;

  /// Logout failed error
  ///
  /// In en, this message translates to:
  /// **'Error occurred during logout'**
  String get errorLogoutFailed;

  /// Password reset failed error
  ///
  /// In en, this message translates to:
  /// **'Failed to send password reset email'**
  String get errorPasswordResetFailed;

  /// Error: not enough cards selected
  ///
  /// In en, this message translates to:
  /// **'Please select more cards'**
  String get errorNotEnoughCards;

  /// Success: login
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get successLogin;

  /// Success: signup
  ///
  /// In en, this message translates to:
  /// **'Your soul has been registered'**
  String get successSignup;

  /// Success: logout
  ///
  /// In en, this message translates to:
  /// **'Farewell'**
  String get successLogout;

  /// Success: all cards selected
  ///
  /// In en, this message translates to:
  /// **'All cards have been selected'**
  String get successCardsSelected;

  /// Language settings section title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// Language selector label
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get settingsLanguageLabel;

  /// Language selector description
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get settingsLanguageDesc;

  /// Notification settings section title
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get settingsNotificationTitle;

  /// Daily notification setting
  ///
  /// In en, this message translates to:
  /// **'Daily Tarot Notification'**
  String get settingsDailyNotification;

  /// Daily notification description
  ///
  /// In en, this message translates to:
  /// **'Get your daily fortune every morning'**
  String get settingsDailyNotificationDesc;

  /// Weekly report setting
  ///
  /// In en, this message translates to:
  /// **'Weekly Tarot Report'**
  String get settingsWeeklyReport;

  /// Weekly report description
  ///
  /// In en, this message translates to:
  /// **'Get your weekly fortune every Monday'**
  String get settingsWeeklyReportDesc;

  /// Display settings section title
  ///
  /// In en, this message translates to:
  /// **'Display Settings'**
  String get settingsDisplayTitle;

  /// Vibration setting
  ///
  /// In en, this message translates to:
  /// **'Vibration Effects'**
  String get settingsVibration;

  /// Vibration description
  ///
  /// In en, this message translates to:
  /// **'Vibration feedback when selecting cards'**
  String get settingsVibrationDesc;

  /// Animation setting
  ///
  /// In en, this message translates to:
  /// **'Animation Effects'**
  String get settingsAnimations;

  /// Animation description
  ///
  /// In en, this message translates to:
  /// **'Screen transition animations'**
  String get settingsAnimationsDesc;

  /// Data management section title
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get settingsDataTitle;

  /// Backup data setting
  ///
  /// In en, this message translates to:
  /// **'Data Backup'**
  String get settingsBackupData;

  /// Backup data description
  ///
  /// In en, this message translates to:
  /// **'Backup your data to the cloud'**
  String get settingsBackupDataDesc;

  /// Clear cache setting
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get settingsClearCache;

  /// Clear cache description
  ///
  /// In en, this message translates to:
  /// **'Delete temporary files to free up space'**
  String get settingsClearCacheDesc;

  /// Delete all data setting
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get settingsDeleteData;

  /// Delete data description
  ///
  /// In en, this message translates to:
  /// **'Delete all tarot records and settings'**
  String get settingsDeleteDataDesc;

  /// Account section title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountTitle;

  /// Change password setting
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settingsChangePassword;

  /// Change password description
  ///
  /// In en, this message translates to:
  /// **'Change your password for account security'**
  String get settingsChangePasswordDesc;

  /// Delete account setting
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// Delete account description
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account'**
  String get settingsDeleteAccountDesc;

  /// Backup dialog title
  ///
  /// In en, this message translates to:
  /// **'Data Backup'**
  String get dialogBackupTitle;

  /// Backup dialog message
  ///
  /// In en, this message translates to:
  /// **'Backup your data to the cloud?'**
  String get dialogBackupMessage;

  /// Clear cache dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get dialogClearCacheTitle;

  /// Clear cache dialog message
  ///
  /// In en, this message translates to:
  /// **'Delete temporary files?'**
  String get dialogClearCacheMessage;

  /// Delete data dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get dialogDeleteDataTitle;

  /// Delete data dialog message
  ///
  /// In en, this message translates to:
  /// **'All tarot records and settings will be permanently deleted.\nThis action cannot be undone.'**
  String get dialogDeleteDataMessage;

  /// Change password dialog title
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get dialogChangePasswordTitle;

  /// Delete account dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get dialogDeleteAccountTitle;

  /// Delete account dialog message
  ///
  /// In en, this message translates to:
  /// **'Deleting your account will permanently delete all data.\nThis action cannot be undone.'**
  String get dialogDeleteAccountMessage;

  /// Current password label
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// New password label
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Confirm new password label
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Backup button
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Change button
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Backup success message
  ///
  /// In en, this message translates to:
  /// **'Data backed up successfully'**
  String get successBackup;

  /// Clear cache success message
  ///
  /// In en, this message translates to:
  /// **'Cache cleared'**
  String get successClearCache;

  /// Delete data success message
  ///
  /// In en, this message translates to:
  /// **'All data deleted'**
  String get successDeleteData;

  /// Password change success message
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get successChangePassword;

  /// Delete account success message
  ///
  /// In en, this message translates to:
  /// **'Account deleted'**
  String get successDeleteAccount;

  /// Backup error message
  ///
  /// In en, this message translates to:
  /// **'Backup failed: {error}'**
  String errorBackup(String error);

  /// Delete data error message
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {error}'**
  String errorDeleteData(String error);

  /// Change password error message
  ///
  /// In en, this message translates to:
  /// **'Password change failed: {error}'**
  String errorChangePassword(String error);

  /// Delete account error message
  ///
  /// In en, this message translates to:
  /// **'Account deletion failed: {error}'**
  String errorDeleteAccount(String error);

  /// Password mismatch error
  ///
  /// In en, this message translates to:
  /// **'New passwords do not match'**
  String get errorPasswordMismatch;

  /// Password reset dialog title
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get passwordResetTitle;

  /// Password reset message
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email address.\nWe\'ll send you a password reset link.'**
  String get passwordResetMessage;

  /// Password reset success message
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get passwordResetSuccess;

  /// Send button
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Email placeholder
  ///
  /// In en, this message translates to:
  /// **'your@email.com'**
  String get emailPlaceholder;

  /// Password placeholder
  ///
  /// In en, this message translates to:
  /// **'6+ characters'**
  String get passwordPlaceholder;

  /// Forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Or divider
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// Google login button
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No account text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// Sign up link
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// App brand name
  ///
  /// In en, this message translates to:
  /// **'MOROKA'**
  String get appBrandName;

  /// App brand tagline
  ///
  /// In en, this message translates to:
  /// **'oracle of shadows'**
  String get appBrandTagline;

  /// About screen title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// About screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Cards of fate await you'**
  String get aboutSubtitle;

  /// About screen tagline
  ///
  /// In en, this message translates to:
  /// **'The cards of fate await you'**
  String get aboutTagline;

  /// About screen description
  ///
  /// In en, this message translates to:
  /// **'MOROKA reads your destiny through ancient mystical tarot cards. Our AI Tarot Master interprets the cosmic messages contained in each of the 78 cards.\n\nDiscover the truth that shines in the darkness, and the special message meant just for you.'**
  String get aboutDescription;

  /// Features section title
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get featuresTitle;

  /// 78 cards feature
  ///
  /// In en, this message translates to:
  /// **'78 Traditional Tarot Cards'**
  String get feature78Cards;

  /// 78 cards feature description
  ///
  /// In en, this message translates to:
  /// **'Complete deck with 22 Major Arcana and 56 Minor Arcana'**
  String get feature78CardsDesc;

  /// 5 spreads feature
  ///
  /// In en, this message translates to:
  /// **'5 Professional Spreads'**
  String get feature5Spreads;

  /// 5 spreads feature description
  ///
  /// In en, this message translates to:
  /// **'Various reading methods from One Card to Celtic Cross'**
  String get feature5SpreadsDesc;

  /// AI feature
  ///
  /// In en, this message translates to:
  /// **'AI Tarot Master'**
  String get featureAI;

  /// AI feature description
  ///
  /// In en, this message translates to:
  /// **'Deep interpretations like a tarot master with 100 years of experience'**
  String get featureAIDesc;

  /// Chat feature
  ///
  /// In en, this message translates to:
  /// **'Interactive Consultation'**
  String get featureChat;

  /// Chat feature description
  ///
  /// In en, this message translates to:
  /// **'Ask questions freely about your cards'**
  String get featureChatDesc;

  /// Terms section title
  ///
  /// In en, this message translates to:
  /// **'Terms & Policies'**
  String get termsAndPolicies;

  /// Terms of service
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Privacy policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Marketing consent
  ///
  /// In en, this message translates to:
  /// **'Marketing Information'**
  String get marketingConsent;

  /// Customer support section
  ///
  /// In en, this message translates to:
  /// **'Customer Support'**
  String get customerSupport;

  /// Email support
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get emailSupport;

  /// Website
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// Cannot open URL error
  ///
  /// In en, this message translates to:
  /// **'Cannot open URL: {url}'**
  String cannotOpenUrl(String url);

  /// Last modified date
  ///
  /// In en, this message translates to:
  /// **'Last modified: July 3, 2025'**
  String get lastModified;

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Company name
  ///
  /// In en, this message translates to:
  /// **'Today\'s Studio'**
  String get companyName;

  /// Company tagline
  ///
  /// In en, this message translates to:
  /// **'Creating mystical experiences'**
  String get companyTagline;

  /// Copyright notice
  ///
  /// In en, this message translates to:
  /// **'© 2025 Today\'s Studio. All rights reserved.'**
  String get copyright;

  /// Anonymous user name
  ///
  /// In en, this message translates to:
  /// **'Anonymous Soul'**
  String get anonymousSoul;

  /// Total readings label
  ///
  /// In en, this message translates to:
  /// **'Total Readings'**
  String get totalReadings;

  /// Join date label
  ///
  /// In en, this message translates to:
  /// **'Join Date'**
  String get joinDate;

  /// Logout error
  ///
  /// In en, this message translates to:
  /// **'Error occurred during logout'**
  String get errorLogout;

  /// Terms screen title
  ///
  /// In en, this message translates to:
  /// **'Soul Contract'**
  String get soulContract;

  /// Terms agreement message
  ///
  /// In en, this message translates to:
  /// **'Please agree to the terms for service use'**
  String get termsAgreementMessage;

  /// Agree all button
  ///
  /// In en, this message translates to:
  /// **'Agree to All'**
  String get agreeAll;

  /// Required label
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Optional label
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Agree and start button
  ///
  /// In en, this message translates to:
  /// **'Agree and Start'**
  String get agreeAndStart;

  /// Required terms message
  ///
  /// In en, this message translates to:
  /// **'Please agree to required terms'**
  String get agreeToRequired;

  /// Nickname label
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// Confirm password label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Next step button
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// Name too short error
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get errorNameTooShort;

  /// Confirm password error
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get errorConfirmPassword;

  /// Passwords don't match error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordsDontMatch;

  /// Email in use message
  ///
  /// In en, this message translates to:
  /// **'Email already in use'**
  String get emailInUse;

  /// Email is available message
  ///
  /// In en, this message translates to:
  /// **'Email is available'**
  String get emailAvailable;

  /// Nickname in use message
  ///
  /// In en, this message translates to:
  /// **'Nickname already in use'**
  String get nicknameInUse;

  /// Nickname available message
  ///
  /// In en, this message translates to:
  /// **'Nickname available'**
  String get nicknameAvailable;

  /// Weak password
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordWeak;

  /// Fair password
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get passwordFair;

  /// Strong password
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrong;

  /// Very strong password
  ///
  /// In en, this message translates to:
  /// **'Very Strong'**
  String get passwordVeryStrong;

  /// Email verification title
  ///
  /// In en, this message translates to:
  /// **'Email Verification'**
  String get emailVerificationTitle;

  /// Email verification message
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification email to {email}.\nPlease check your email and click the verification link.'**
  String emailVerificationMessage(String email);

  /// Resend email button
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get resendEmail;

  /// Email resent message
  ///
  /// In en, this message translates to:
  /// **'Verification email resent'**
  String get emailResent;

  /// Check email instruction
  ///
  /// In en, this message translates to:
  /// **'After verification, please return to the app'**
  String get checkEmailAndReturn;

  /// Empty history state title
  ///
  /// In en, this message translates to:
  /// **'No tarot records yet'**
  String get noHistoryTitle;

  /// Empty history state message
  ///
  /// In en, this message translates to:
  /// **'Read your first destiny'**
  String get noHistoryMessage;

  /// Start reading button
  ///
  /// In en, this message translates to:
  /// **'Start Tarot Reading'**
  String get startReading;

  /// Delete reading dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete this record?'**
  String get deleteReadingTitle;

  /// Delete reading dialog message
  ///
  /// In en, this message translates to:
  /// **'Deleted records cannot be recovered'**
  String get deleteReadingMessage;

  /// Delete all button text
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// Delete all confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete All Records?'**
  String get deleteAllConfirmTitle;

  /// Delete all confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all tarot reading records. This action cannot be undone.'**
  String get deleteAllConfirmMessage;

  /// Delete all confirmation button
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAllButton;

  /// Total readings statistic label
  ///
  /// In en, this message translates to:
  /// **'Total Tarot Readings'**
  String get totalTarotReadings;

  /// Most frequent card statistic label
  ///
  /// In en, this message translates to:
  /// **'Most Frequent Card'**
  String get mostFrequentCard;

  /// Top 5 card frequency chart title
  ///
  /// In en, this message translates to:
  /// **'Card Frequency TOP 5'**
  String get cardFrequencyTop5;

  /// Mood analysis chart title
  ///
  /// In en, this message translates to:
  /// **'Reading Analysis by Mood'**
  String get moodAnalysis;

  /// Monthly trend chart title
  ///
  /// In en, this message translates to:
  /// **'Monthly Reading Trend'**
  String get monthlyReadingTrend;

  /// No data message for charts
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// Empty state message for statistics
  ///
  /// In en, this message translates to:
  /// **'No data to analyze yet'**
  String get noDataToAnalyze;

  /// Prompt to start first reading
  ///
  /// In en, this message translates to:
  /// **'Start your tarot reading'**
  String get startTarotReading;

  /// Card selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Card of Fate'**
  String get cardOfFate;

  /// Card selection dialog subtitle
  ///
  /// In en, this message translates to:
  /// **'This card is calling you'**
  String get cardCallingYou;

  /// Card selection dialog question
  ///
  /// In en, this message translates to:
  /// **'Will you select it?'**
  String get selectThisCard;

  /// Card selection dialog cancel button
  ///
  /// In en, this message translates to:
  /// **'View Again'**
  String get viewAgain;

  /// Card selection dialog confirm button
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// Message shown while shuffling cards
  ///
  /// In en, this message translates to:
  /// **'Shuffling the cards of fate...'**
  String get shufflingCards;

  /// Card selection instruction
  ///
  /// In en, this message translates to:
  /// **'Follow your intuition and select the cards'**
  String get selectCardsIntuition;

  /// Select more cards message
  ///
  /// In en, this message translates to:
  /// **'Select {count} more cards'**
  String selectMoreCards(int count);

  /// Message when all cards are selected
  ///
  /// In en, this message translates to:
  /// **'Selection complete!'**
  String get selectionComplete;

  /// Accessibility hint for selectable item
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get tapToSelect;

  /// Preparing interpretation message
  ///
  /// In en, this message translates to:
  /// **'Preparing interpretation...'**
  String get preparingInterpretation;

  /// Card message section title
  ///
  /// In en, this message translates to:
  /// **'Card Message'**
  String get cardMessage;

  /// Cards story header
  ///
  /// In en, this message translates to:
  /// **'The Story Your Cards Tell'**
  String get cardsStory;

  /// Special interpretation subtitle
  ///
  /// In en, this message translates to:
  /// **'A Special Interpretation for You'**
  String get specialInterpretation;

  /// Interpreting cards loading message
  ///
  /// In en, this message translates to:
  /// **'Interpreting the meaning of the cards...'**
  String get interpretingCards;

  /// Chat limit reached message
  ///
  /// In en, this message translates to:
  /// **'Today\'s conversation has ended'**
  String get todaysChatEnded;

  /// Chat input placeholder
  ///
  /// In en, this message translates to:
  /// **'Ask your questions...'**
  String get askQuestions;

  /// Continue conversation button
  ///
  /// In en, this message translates to:
  /// **'Continue Conversation'**
  String get continueConversation;

  /// Ad dialog title
  ///
  /// In en, this message translates to:
  /// **'Want to know deeper truths?'**
  String get wantDeeperTruth;

  /// Ad dialog message
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to continue\nyour conversation with the Tarot Master'**
  String get watchAdToContinue;

  /// Later button
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// Watch ad button
  ///
  /// In en, this message translates to:
  /// **'Watch Ad'**
  String get watchAd;

  /// Email verification header
  ///
  /// In en, this message translates to:
  /// **'Email Verification'**
  String get emailVerification;

  /// Check email title
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkYourEmail;

  /// Verification email sent message
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification email to the address above.\nPlease check your inbox and click the verification link.'**
  String get verificationEmailSent;

  /// Verifying email loading text
  ///
  /// In en, this message translates to:
  /// **'Verifying email...'**
  String get verifyingEmail;

  /// No email received title
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the email?'**
  String get noEmailReceived;

  /// Check spam folder message
  ///
  /// In en, this message translates to:
  /// **'Check your spam folder.\nIf it\'s still not there, click the button below to resend.'**
  String get checkSpamFolder;

  /// Resend cooldown message
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(int seconds);

  /// Resend verification email button
  ///
  /// In en, this message translates to:
  /// **'Resend Verification Email'**
  String get resendVerificationEmail;

  /// Already verified button
  ///
  /// In en, this message translates to:
  /// **'I\'ve already verified'**
  String get alreadyVerified;

  /// Final onboarding button
  ///
  /// In en, this message translates to:
  /// **'Open the Gate of Fate'**
  String get openGateOfFate;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get skip;

  /// Language change success message
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// Notifications enabled message
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationsEnabled;

  /// Notifications disabled message
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationsDisabled;

  /// Vibration enabled message
  ///
  /// In en, this message translates to:
  /// **'Vibration enabled'**
  String get vibrationEnabled;

  /// Vibration disabled message
  ///
  /// In en, this message translates to:
  /// **'Vibration disabled'**
  String get vibrationDisabled;

  /// Animations enabled message
  ///
  /// In en, this message translates to:
  /// **'Animations enabled'**
  String get animationsEnabled;

  /// Animations disabled message
  ///
  /// In en, this message translates to:
  /// **'Animations disabled'**
  String get animationsDisabled;

  /// Notification permission denied message
  ///
  /// In en, this message translates to:
  /// **'Notification permission is required'**
  String get notificationPermissionDenied;

  /// Weak password error
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get errorWeakPassword;

  /// More section title
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// Card selection dialog question
  ///
  /// In en, this message translates to:
  /// **'Will you select it?'**
  String get willYouSelectIt;

  /// Card selection instruction in header
  ///
  /// In en, this message translates to:
  /// **'Select the card that draws your heart'**
  String get selectCardByHeart;

  /// Number of cards more to select
  ///
  /// In en, this message translates to:
  /// **'{count} more to select'**
  String moreToSelect(int count);

  /// Instruction to tap card for selection
  ///
  /// In en, this message translates to:
  /// **'Tap the card to select'**
  String get tapToSelectCard;

  /// Current situation section title
  ///
  /// In en, this message translates to:
  /// **'Current Situation'**
  String get currentSituation;

  /// Practical advice section title
  ///
  /// In en, this message translates to:
  /// **'Practical Advice'**
  String get practicalAdvice;

  /// Future forecast section title
  ///
  /// In en, this message translates to:
  /// **'Future Forecast'**
  String get futureForecast;

  /// Overall flow section title
  ///
  /// In en, this message translates to:
  /// **'Overall Flow'**
  String get overallFlow;

  /// Time-based interpretation section title
  ///
  /// In en, this message translates to:
  /// **'Time-based Interpretation'**
  String get timeBasedInterpretation;

  /// Past influence section title
  ///
  /// In en, this message translates to:
  /// **'Past Influence'**
  String get pastInfluence;

  /// Upcoming future section title
  ///
  /// In en, this message translates to:
  /// **'Upcoming Future'**
  String get upcomingFuture;

  /// Action guidelines section title
  ///
  /// In en, this message translates to:
  /// **'Action Guidelines'**
  String get actionGuidelines;

  /// Core advice section title
  ///
  /// In en, this message translates to:
  /// **'Core Advice'**
  String get coreAdvice;

  /// Core situation analysis section title
  ///
  /// In en, this message translates to:
  /// **'Core Situation Analysis'**
  String get coreSituationAnalysis;

  /// Inner conflict section title
  ///
  /// In en, this message translates to:
  /// **'Inner Conflict'**
  String get innerConflict;

  /// Timeline analysis section title
  ///
  /// In en, this message translates to:
  /// **'Timeline Analysis'**
  String get timelineAnalysis;

  /// External factors section title
  ///
  /// In en, this message translates to:
  /// **'External Factors'**
  String get externalFactors;

  /// Final forecast section title
  ///
  /// In en, this message translates to:
  /// **'Final Forecast'**
  String get finalForecast;

  /// Step-by-step plan section title
  ///
  /// In en, this message translates to:
  /// **'Step-by-Step Plan'**
  String get stepByStepPlan;

  /// Two person energy section title
  ///
  /// In en, this message translates to:
  /// **'Two-Person Energy'**
  String get twoPersonEnergy;

  /// Heart temperature difference section title
  ///
  /// In en, this message translates to:
  /// **'Heart Temperature Difference'**
  String get heartTemperatureDifference;

  /// Relationship obstacles section title
  ///
  /// In en, this message translates to:
  /// **'Relationship Obstacles'**
  String get relationshipObstacles;

  /// Future possibility section title
  ///
  /// In en, this message translates to:
  /// **'Future Possibility'**
  String get futurePossibility;

  /// Advice for love section title
  ///
  /// In en, this message translates to:
  /// **'Advice for Love'**
  String get adviceForLove;

  /// One line advice section title
  ///
  /// In en, this message translates to:
  /// **'One-Line Advice'**
  String get oneLineAdvice;

  /// Judgment basis section title
  ///
  /// In en, this message translates to:
  /// **'Judgment Basis'**
  String get judgmentBasis;

  /// Core message section title
  ///
  /// In en, this message translates to:
  /// **'Core Message'**
  String get coreMessage;

  /// Success conditions section title
  ///
  /// In en, this message translates to:
  /// **'Success Conditions'**
  String get successConditions;

  /// Timing prediction section title
  ///
  /// In en, this message translates to:
  /// **'Timing Prediction'**
  String get timingPrediction;

  /// Action guide section title
  ///
  /// In en, this message translates to:
  /// **'Action Guide'**
  String get actionGuide;

  /// Future keyword
  ///
  /// In en, this message translates to:
  /// **'Future'**
  String get future;

  /// Advice keyword
  ///
  /// In en, this message translates to:
  /// **'Advice'**
  String get advice;

  /// Message keyword
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// Meaning keyword
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get meaning;

  /// Interpretation keyword
  ///
  /// In en, this message translates to:
  /// **'Interpretation'**
  String get interpretation;

  /// Overall meaning section title
  ///
  /// In en, this message translates to:
  /// **'Overall Meaning'**
  String get overallMeaning;

  /// Comprehensive interpretation section title
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Interpretation'**
  String get comprehensiveInterpretation;

  /// Future advice section title
  ///
  /// In en, this message translates to:
  /// **'Future Advice'**
  String get futureAdvice;

  /// Yes answer
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No answer
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Conditional yes answer
  ///
  /// In en, this message translates to:
  /// **'Conditional Yes'**
  String get conditionalYes;

  /// Loading message while analyzing statistics
  ///
  /// In en, this message translates to:
  /// **'Analyzing your destiny...'**
  String get analyzingDestiny;

  /// Times count suffix
  ///
  /// In en, this message translates to:
  /// **'{count} times'**
  String timesCount(int count);

  /// Month label format
  ///
  /// In en, this message translates to:
  /// **'{month}'**
  String monthLabel(String month);

  /// Label for remaining card draws
  ///
  /// In en, this message translates to:
  /// **'Remaining Draws'**
  String get remainingDraws;

  /// Message when no draws are left
  ///
  /// In en, this message translates to:
  /// **'No draws remaining'**
  String get noDrawsRemaining;

  /// Label for draws obtained by watching ads
  ///
  /// In en, this message translates to:
  /// **'Ad'**
  String get adDraws;

  /// Title for daily limit reached dialog
  ///
  /// In en, this message translates to:
  /// **'Daily Draw Limit Reached'**
  String get dailyLimitReached;

  /// Message encouraging users to watch ads for more draws
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to get more card draws. You can get up to 10 additional draws per day.'**
  String get watchAdForMore;

  /// Success message after watching ad
  ///
  /// In en, this message translates to:
  /// **'1 draw added! ✨'**
  String get drawAddedMessage;

  /// Error message when ad fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load ad. Please try again later.'**
  String get adLoadFailed;

  /// Accessibility label for menu button
  ///
  /// In en, this message translates to:
  /// **'Open menu'**
  String get openMenu;

  /// Accessibility hint for selected item
  ///
  /// In en, this message translates to:
  /// **'Currently selected'**
  String get currentlySelected;

  /// Accessibility hint for continue button when enabled
  ///
  /// In en, this message translates to:
  /// **'Proceed to spread selection'**
  String get proceedToSpreadSelection;

  /// Accessibility hint for continue button when disabled
  ///
  /// In en, this message translates to:
  /// **'Please select a mood first'**
  String get selectMoodFirst;

  /// Accessibility label for user info
  ///
  /// In en, this message translates to:
  /// **'Current user'**
  String get currentUser;

  /// Accessibility label for back button
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// Accessibility hint for cancel button in card selection
  ///
  /// In en, this message translates to:
  /// **'Cancel card selection'**
  String get cancelCardSelection;

  /// Accessibility hint for confirm button in card selection
  ///
  /// In en, this message translates to:
  /// **'Confirm card selection'**
  String get confirmCardSelection;

  /// Cards label for accessibility
  ///
  /// In en, this message translates to:
  /// **'cards'**
  String get cards;

  /// Accessibility hint for spread selection
  ///
  /// In en, this message translates to:
  /// **'Tap to select this spread'**
  String get tapToSelectSpread;

  /// Close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Back button label
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Accessibility label for card layout section
  ///
  /// In en, this message translates to:
  /// **'Selected cards layout'**
  String get selectedCardsLayout;

  /// Label for user's chat message
  ///
  /// In en, this message translates to:
  /// **'Your question'**
  String get yourQuestion;

  /// Label for tarot master/AI
  ///
  /// In en, this message translates to:
  /// **'Tarot Master'**
  String get tarotMaster;

  /// Label for user's question
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// Label for AI's chat response
  ///
  /// In en, this message translates to:
  /// **'Tarot master\'s response'**
  String get tarotMasterResponse;

  /// Accessibility label for chat input
  ///
  /// In en, this message translates to:
  /// **'Chat input field'**
  String get chatInputField;

  /// Send button label
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get sendMessage;

  /// Date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Card label
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// Chat count display
  ///
  /// In en, this message translates to:
  /// **'Chat {count} times'**
  String chatCount(int count);

  /// Delete reading button label
  ///
  /// In en, this message translates to:
  /// **'Delete reading'**
  String get deleteReading;

  /// Delete reading accessibility description
  ///
  /// In en, this message translates to:
  /// **'Delete this tarot reading permanently'**
  String get deleteReadingDescription;

  /// Toggle switch on state
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// Toggle switch off state
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// Card showing new perspective message
  ///
  /// In en, this message translates to:
  /// **'card is showing you a new perspective.'**
  String get cardShowingNewPerspective;

  /// Mood sign of change message
  ///
  /// In en, this message translates to:
  /// **'mood is a sign of change.'**
  String get moodIsSignOfChange;

  /// Turning point message
  ///
  /// In en, this message translates to:
  /// **'Now is the turning point.'**
  String get nowIsTurningPoint;

  /// Try different choice advice
  ///
  /// In en, this message translates to:
  /// **'Try making a different choice today'**
  String get tryDifferentChoiceToday;

  /// Talk with someone special advice
  ///
  /// In en, this message translates to:
  /// **'Have a conversation with someone special'**
  String get talkWithSomeoneSpecial;

  /// Set small goal advice
  ///
  /// In en, this message translates to:
  /// **'Set a small goal and start'**
  String get setSmallGoalAndStart;

  /// Positive change timeframe message
  ///
  /// In en, this message translates to:
  /// **'You\'ll feel positive changes within 2-3 weeks.'**
  String get positiveChangeInWeeks;

  /// Past to future flow message
  ///
  /// In en, this message translates to:
  /// **'The flow from past to present to future is visible.'**
  String get flowFromPastToFuture;

  /// Lessons from past label
  ///
  /// In en, this message translates to:
  /// **'Lessons from past experiences'**
  String get lessonsFromPast;

  /// Upcoming possibilities label
  ///
  /// In en, this message translates to:
  /// **'Upcoming possibilities'**
  String get upcomingPossibilities;

  /// Time perspective advice
  ///
  /// In en, this message translates to:
  /// **'Accept the past, focus on the present, prepare for the future.'**
  String get acceptPastFocusPresentPrepareFuture;

  /// Current choice importance message
  ///
  /// In en, this message translates to:
  /// **'state, the most important thing is your current choice.'**
  String get mostImportantIsCurrentChoice;

  /// Final answer label
  ///
  /// In en, this message translates to:
  /// **'Final Answer'**
  String get finalAnswer;

  /// Positive signals label
  ///
  /// In en, this message translates to:
  /// **'Positive signals'**
  String get positiveSignals;

  /// Caution signals label
  ///
  /// In en, this message translates to:
  /// **'Caution signals'**
  String get cautionSignals;

  /// Card holds key message
  ///
  /// In en, this message translates to:
  /// **'card holds the important key.'**
  String get cardHoldsImportantKey;

  /// Preparation and timing message
  ///
  /// In en, this message translates to:
  /// **'Careful preparation and proper timing are needed.'**
  String get needCarefulPreparationAndTiming;

  /// 1-2 weeks timeframe
  ///
  /// In en, this message translates to:
  /// **'1-2 weeks'**
  String get oneToTwoWeeks;

  /// 1-2 months timeframe
  ///
  /// In en, this message translates to:
  /// **'1-2 months'**
  String get oneToTwoMonths;

  /// Check results label
  ///
  /// In en, this message translates to:
  /// **'to check results'**
  String get checkResults;

  /// Do best regardless advice
  ///
  /// In en, this message translates to:
  /// **'Do your best to prepare regardless of the outcome.'**
  String get doBestRegardlessOfResult;

  /// You label
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// Partner label
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get partner;

  /// Important role in relationship label
  ///
  /// In en, this message translates to:
  /// **'Important role in the relationship'**
  String get importantRoleInRelationship;

  /// Partner's current state label
  ///
  /// In en, this message translates to:
  /// **'Partner\'s current state'**
  String get partnersCurrentState;

  /// Temperature difference message
  ///
  /// In en, this message translates to:
  /// **'There\'s a temperature difference in hearts, but it\'s understandable.'**
  String get temperatureDifferenceButUnderstandable;

  /// Showing challenges message
  ///
  /// In en, this message translates to:
  /// **' showing challenges ahead.'**
  String get showingChallenges;

  /// Possibility with effort message
  ///
  /// In en, this message translates to:
  /// **'With effort, there\'s over 60% possibility of progress.'**
  String get possibilityWithEffort;

  /// Need conversation understanding time message
  ///
  /// In en, this message translates to:
  /// **'Conversation, understanding, and time are needed.'**
  String get needConversationUnderstandingTime;

  /// Love is mirror message
  ///
  /// In en, this message translates to:
  /// **'Love is like a mirror reflecting each other.'**
  String get loveIsMirrorReflectingEachOther;

  /// Cards showing complex situation message
  ///
  /// In en, this message translates to:
  /// **' cards are showing a complex situation.'**
  String get cardsShowingComplexSituation;

  /// Conscious unconscious conflict message
  ///
  /// In en, this message translates to:
  /// **'There\'s conflict between conscious and unconscious.'**
  String get conflictBetweenConsciousUnconscious;

  /// Past influence continues message
  ///
  /// In en, this message translates to:
  /// **'The influence of the past continues to the present.'**
  String get pastInfluenceContinuesToPresent;

  /// Surrounding environment important message
  ///
  /// In en, this message translates to:
  /// **'The surrounding environment has important influence.'**
  String get surroundingEnvironmentImportant;

  /// 70% positive change possibility message
  ///
  /// In en, this message translates to:
  /// **'There\'s about 70% possibility of positive change.'**
  String get positiveChangePossibility70Percent;

  /// This week timeframe
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// This month timeframe
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// 3 months later timeframe
  ///
  /// In en, this message translates to:
  /// **'3 months later'**
  String get threeMonthsLater;

  /// Organize situation advice
  ///
  /// In en, this message translates to:
  /// **'Organize the situation'**
  String get organizeSituation;

  /// Start concrete action advice
  ///
  /// In en, this message translates to:
  /// **'Start concrete action'**
  String get startConcreteAction;

  /// You have power to overcome message
  ///
  /// In en, this message translates to:
  /// **'You have the power within to overcome your current state.'**
  String get youHavePowerToOvercome;

  /// When keyword
  ///
  /// In en, this message translates to:
  /// **'when'**
  String get when;

  /// Timing keyword
  ///
  /// In en, this message translates to:
  /// **'timing'**
  String get timing;

  /// How keyword
  ///
  /// In en, this message translates to:
  /// **'how'**
  String get how;

  /// Method keyword
  ///
  /// In en, this message translates to:
  /// **'method'**
  String get method;

  /// Why keyword
  ///
  /// In en, this message translates to:
  /// **'why'**
  String get why;

  /// Reason keyword
  ///
  /// In en, this message translates to:
  /// **'reason'**
  String get reason;

  /// Tarot timing answer template
  ///
  /// In en, this message translates to:
  /// **'Tarot typically shows timing between 1-3 months. Looking at the {cardName} card\'s energy, it might be sooner. The best time is when you\'re ready.'**
  String tarotTimingAnswer(String cardName);

  /// Tarot method answer template
  ///
  /// In en, this message translates to:
  /// **'The {cardName} card says to follow your intuition. Don\'t overthink it, just take one step at a time following your heart. Small beginnings create big changes.'**
  String tarotMethodAnswer(String cardName);

  /// Tarot reason answer template
  ///
  /// In en, this message translates to:
  /// **'The reason is, as the {cardName} card suggests, now is the time for change. It\'s time to break free from past patterns and open new possibilities.'**
  String tarotReasonAnswer(String cardName);

  /// Tarot general answer template
  ///
  /// In en, this message translates to:
  /// **'Good question. From the {cardName} card\'s perspective, now is the time to move forward carefully yet courageously. What aspect are you most curious about?'**
  String tarotGeneralAnswer(String cardName);

  /// Empty chat state message
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about your tarot reading'**
  String get startChatMessage;

  /// Chat history section title
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chatHistory;

  /// Chat history section description
  ///
  /// In en, this message translates to:
  /// **'Your conversation with the Tarot Master'**
  String get chatHistoryDescription;

  /// Past timeframe label
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// Present timeframe label
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// Positive change possibility label
  ///
  /// In en, this message translates to:
  /// **'Possibility of positive change'**
  String get positiveChangePossibility;

  /// Future outlook section title
  ///
  /// In en, this message translates to:
  /// **'Future Outlook'**
  String get futureOutlook;

  /// Free tier label
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// Paid tier label
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// One card spread description
  ///
  /// In en, this message translates to:
  /// **'Today\'s fortune and advice'**
  String get oneCardDescription;

  /// Three card spread description
  ///
  /// In en, this message translates to:
  /// **'Flow of past, present, future'**
  String get threeCardDescription;

  /// Celtic cross spread description
  ///
  /// In en, this message translates to:
  /// **'Analyze all aspects of the situation'**
  String get celticCrossDescription;

  /// Relationship spread description
  ///
  /// In en, this message translates to:
  /// **'Dynamics and future of relationships'**
  String get relationshipDescription;

  /// Yes/No spread description
  ///
  /// In en, this message translates to:
  /// **'Fortune telling for clear answers'**
  String get yesNoDescription;

  /// Error message when AI API fails
  ///
  /// In en, this message translates to:
  /// **'Sorry, the threads of fate have become tangled. Please try again.'**
  String get errorApiMessage;

  /// Default interpretation start
  ///
  /// In en, this message translates to:
  /// **'The {spreadName} spread has been laid out.'**
  String defaultInterpretationStart(String spreadName);

  /// Label for selected cards
  ///
  /// In en, this message translates to:
  /// **'Selected cards: {cards}'**
  String selectedCardsLabel(String cards);

  /// Card energy resonance message
  ///
  /// In en, this message translates to:
  /// **'The energy created by these cards resonates with your {mood} heart.'**
  String cardEnergyResonance(String mood);

  /// Message about deeper interpretation coming
  ///
  /// In en, this message translates to:
  /// **'Each card\'s message connects to form a larger picture.\n\nI will share a deeper interpretation shortly...'**
  String get deeperInterpretationComing;

  /// General waiting/loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get waitingMessage;

  /// Name is available message
  ///
  /// In en, this message translates to:
  /// **'Name is available'**
  String get nameAvailable;

  /// Name already taken error
  ///
  /// In en, this message translates to:
  /// **'Name is already taken'**
  String get nameAlreadyTaken;

  /// Name check failed error
  ///
  /// In en, this message translates to:
  /// **'Error checking name availability'**
  String get errorNameCheckFailed;

  /// Email already registered error
  ///
  /// In en, this message translates to:
  /// **'Email is already registered'**
  String get emailAlreadyRegistered;

  /// Email check failed error
  ///
  /// In en, this message translates to:
  /// **'Error checking email availability'**
  String get errorEmailCheckFailed;

  /// Message required error
  ///
  /// In en, this message translates to:
  /// **'Please enter a message'**
  String get messageRequired;

  /// Message too long error
  ///
  /// In en, this message translates to:
  /// **'Message must be within 500 characters'**
  String get messageTooLong;

  /// Invalid characters error
  ///
  /// In en, this message translates to:
  /// **'Message contains invalid characters'**
  String get messageInvalidCharacters;

  /// Invalid script error
  ///
  /// In en, this message translates to:
  /// **'Message contains invalid script'**
  String get messageInvalidScript;

  /// Password required error
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get passwordRequired;

  /// Weak password strength
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordStrengthWeak;

  /// Medium password strength
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get passwordStrengthMedium;

  /// Strong password strength
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrengthStrong;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Invalid format error
  ///
  /// In en, this message translates to:
  /// **'Invalid format'**
  String get errorInvalidFormat;

  /// Unexpected error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get errorUnexpected;

  /// Unknown error message
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get errorUnknown;

  /// Network timeout error
  ///
  /// In en, this message translates to:
  /// **'Network connection timed out'**
  String get errorNetworkTimeout;

  /// No internet connection error
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorNoInternet;

  /// Server error message
  ///
  /// In en, this message translates to:
  /// **'Server error occurred'**
  String get errorServerError;

  /// Invalid credentials error
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get errorInvalidCredentials;

  /// Email not verified error
  ///
  /// In en, this message translates to:
  /// **'Email not verified'**
  String get errorEmailNotVerified;

  /// Session expired error
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please login again'**
  String get errorSessionExpired;

  /// Quota exceeded error
  ///
  /// In en, this message translates to:
  /// **'Daily limit exceeded'**
  String get errorQuotaExceeded;

  /// Invalid response error
  ///
  /// In en, this message translates to:
  /// **'Invalid response from server'**
  String get errorInvalidResponse;

  /// Rate limit exceeded error
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later'**
  String get errorRateLimitExceeded;

  /// Data not found error
  ///
  /// In en, this message translates to:
  /// **'Data not found'**
  String get errorDataNotFound;

  /// Data corrupted error
  ///
  /// In en, this message translates to:
  /// **'Data corrupted'**
  String get errorDataCorrupted;

  /// Save failed error
  ///
  /// In en, this message translates to:
  /// **'Failed to save data'**
  String get errorSaveFailed;

  /// Permission denied error
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get errorPermissionDenied;

  /// Permission restricted error
  ///
  /// In en, this message translates to:
  /// **'Access restricted'**
  String get errorPermissionRestricted;

  /// Email already in use error
  ///
  /// In en, this message translates to:
  /// **'Email already in use'**
  String get errorEmailAlreadyInUse;

  /// Invalid email error
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get errorInvalidEmail;

  /// Network request failed error
  ///
  /// In en, this message translates to:
  /// **'Network request failed'**
  String get errorNetworkRequestFailed;

  /// Operation not allowed error
  ///
  /// In en, this message translates to:
  /// **'Operation not allowed'**
  String get errorOperationNotAllowed;

  /// Authentication failed error
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get errorAuthFailed;

  /// Logout success message
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get logoutSuccess;

  /// Delete account success message
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get deleteAccountSuccess;

  /// General settings section title
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// Account settings section title
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// Language setting title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// Notifications setting title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// Vibration setting title
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get vibrationTitle;

  /// Vibration setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Enable vibration feedback'**
  String get vibrationSubtitle;

  /// Animations setting title
  ///
  /// In en, this message translates to:
  /// **'Animations'**
  String get animationsTitle;

  /// Animations setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Enable UI animations'**
  String get animationsSubtitle;

  /// Daily tarot reminder setting
  ///
  /// In en, this message translates to:
  /// **'Get daily tarot reminders'**
  String get dailyTarotReminder;

  /// Delete account confirmation message
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data will be permanently deleted.'**
  String get deleteAccountConfirmMessage;

  /// Selected cards label
  ///
  /// In en, this message translates to:
  /// **'Selected Cards'**
  String get selectedCards;

  /// AI interpretation title
  ///
  /// In en, this message translates to:
  /// **'AI Interpretation'**
  String get aiInterpretation;

  /// Error when emotion input is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid emotion input.'**
  String get invalidEmotionInput;

  /// Error when interpretation is not received
  ///
  /// In en, this message translates to:
  /// **'Could not receive interpretation result.'**
  String get interpretationNotReceived;

  /// Error when response generation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to generate response.'**
  String get responseGenerationFailed;

  /// Error for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Invalid email format.'**
  String get invalidEmailFormat;

  /// Error for weak password
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Please use at least 8 characters including uppercase, lowercase, numbers, and special characters.'**
  String get weakPassword;

  /// Error for invalid username
  ///
  /// In en, this message translates to:
  /// **'Username must be 3-20 characters using only letters, numbers, and underscores.'**
  String get invalidUsername;

  /// General signup error
  ///
  /// In en, this message translates to:
  /// **'An error occurred during sign up.'**
  String get signupError;

  /// General login error
  ///
  /// In en, this message translates to:
  /// **'An error occurred during login.'**
  String get loginError;

  /// General logout error
  ///
  /// In en, this message translates to:
  /// **'An error occurred during logout.'**
  String get logoutError;

  /// Error when password reset email fails
  ///
  /// In en, this message translates to:
  /// **'Failed to send password reset email.'**
  String get passwordResetEmailFailed;

  /// Error when profile creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create user profile.'**
  String get profileCreationFailed;

  /// Error when no user is logged in
  ///
  /// In en, this message translates to:
  /// **'No logged in user.'**
  String get noLoggedInUser;

  /// Error when profile update fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile.'**
  String get profileUpdateFailed;

  /// Error when card interpretation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to get card interpretation: {error}'**
  String cardInterpretationFailed(String error);

  /// Error when email is already registered
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get emailAlreadyInUse;

  /// Signup error with specific message
  ///
  /// In en, this message translates to:
  /// **'An error occurred during sign up: {message}'**
  String signupErrorWithMessage(String message);

  /// Error for rate limiting
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later.'**
  String get tooManyRequests;

  /// Error when sending verification email
  ///
  /// In en, this message translates to:
  /// **'An error occurred while sending verification email.'**
  String get verificationEmailError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'ja',
        'ko',
        'pt',
        'th',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.scriptCode) {
          case 'fallback':
            return AppLocalizationsEnFallback();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'th':
      return AppLocalizationsTh();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
