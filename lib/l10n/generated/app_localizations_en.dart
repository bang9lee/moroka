// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Moroka';

  @override
  String get appTagline => 'Oracle of Shadows';

  @override
  String get appTitle => 'Moroka - Ominous Whispers';

  @override
  String get onboardingTitle1 => 'The Gate of Fate Opens';

  @override
  String get onboardingDesc1 =>
      'Ancient wisdom meets modern technology\nto whisper your future';

  @override
  String get onboardingTitle2 => 'Truth in the Darkness';

  @override
  String get onboardingDesc2 =>
      'Tarot cards never lie\nThey only show the truth you can handle';

  @override
  String get onboardingTitle3 => 'AI Reads Your Destiny';

  @override
  String get onboardingDesc3 =>
      'Artificial intelligence interprets your cards\nand guides your path through deep conversation';

  @override
  String get onboardingTitle4 => 'Are You Ready?';

  @override
  String get onboardingDesc4 =>
      'Every choice has its price\nIf you\'re ready to face your destiny...';

  @override
  String get loginTitle => 'You Have Returned';

  @override
  String get loginSubtitle => 'We have been waiting for you';

  @override
  String get signupTitle => 'Contract of Fate';

  @override
  String get signupSubtitle => 'Register your soul';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get nameLabel => 'Name';

  @override
  String get loginButton => 'Enter';

  @override
  String get signupButton => 'Register Soul';

  @override
  String get googleLogin => 'Login with Google';

  @override
  String get googleSignup => 'Start with Google';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get dontHaveAccount => 'First time? Sign up';

  @override
  String get moodQuestion => 'How are you feeling now?';

  @override
  String get selectSpreadButton => 'Select Tarot Spread';

  @override
  String get moodAnxious => 'Anxious';

  @override
  String get moodLonely => 'Lonely';

  @override
  String get moodCurious => 'Curious';

  @override
  String get moodFearful => 'Fearful';

  @override
  String get moodHopeful => 'Hopeful';

  @override
  String get moodConfused => 'Confused';

  @override
  String get moodDesperate => 'Desperate';

  @override
  String get moodExpectant => 'Expectant';

  @override
  String get moodMystical => 'Mystical';

  @override
  String get spreadSelectionTitle => 'Select Spread';

  @override
  String get spreadSelectionSubtitle =>
      'Choose a spread based on your current feelings';

  @override
  String get spreadDifficultyBeginner => '1-3 cards';

  @override
  String get spreadDifficultyIntermediate => '5-7 cards';

  @override
  String get spreadDifficultyAdvanced => '10 cards';

  @override
  String get spreadOneCard => 'One Card';

  @override
  String get spreadThreeCard => 'Three Cards';

  @override
  String get spreadCelticCross => 'Celtic Cross';

  @override
  String get spreadRelationship => 'Relationship Spread';

  @override
  String get spreadYesNo => 'Yes/No';

  @override
  String get selectCardTitle => 'Select the cards of fate';

  @override
  String get currentMoodLabel => 'Your current mood: ';

  @override
  String get currentSpreadLabel => 'Selected spread: ';

  @override
  String get shufflingMessage => 'The threads of fate are intertwining...';

  @override
  String get selectCardInstruction =>
      'Follow your intuition and select the cards';

  @override
  String cardsSelected(int count) {
    return '$count selected';
  }

  @override
  String cardsRemaining(int count) {
    return 'Select $count more';
  }

  @override
  String get todaysCard => 'Today\'s Card';

  @override
  String get threeCardSpread => 'Three Card Spread';

  @override
  String get celticCrossSpread => 'Celtic Cross Spread';

  @override
  String get crossSection => 'Cross - Current Situation';

  @override
  String get staffSection => 'Staff - Future Development';

  @override
  String get relationshipSpread => 'Relationship Spread';

  @override
  String get yesNoSpread => 'Yes/No Spread';

  @override
  String get spreadReading => 'Spread Reading';

  @override
  String get tapCardForDetails => 'Tap card for details';

  @override
  String get interpretationSectionTitle => 'AI Interpretation';

  @override
  String get oneCardReading => 'Single Card Reading';

  @override
  String get threeCardReading => 'Past, Present, Future Reading';

  @override
  String get celticCrossReading => '10-Card In-Depth Analysis';

  @override
  String get relationshipReading => 'Relationship Analysis';

  @override
  String get yesNoReading => 'Yes or No Answer';

  @override
  String get typeMessageHint => 'Type a message...';

  @override
  String get continueReading => 'Get deeper advice';

  @override
  String get watchAdPrompt =>
      'To hear the voice from deeper abyss,\nyou must check messages from another world.';

  @override
  String get interpretingSpread =>
      'Interpreting the messages from the cards...';

  @override
  String get menuHistory => 'Past Tarot Records';

  @override
  String get menuHistoryDesc => 'Look back at your past destinies';

  @override
  String get loadingHistory => 'Loading history...';

  @override
  String get menuStatistics => 'Statistics & Analysis';

  @override
  String get menuStatisticsDesc => 'Analyze your destiny patterns';

  @override
  String get menuSettings => 'Settings';

  @override
  String get menuSettingsDesc => 'Adjust app environment';

  @override
  String get menuAbout => 'About';

  @override
  String get menuAboutDesc => 'Moroka - Oracle of Shadows';

  @override
  String get logoutButton => 'Logout';

  @override
  String get logoutTitle => 'Are you really leaving?';

  @override
  String get logoutMessage =>
      'When the gate of fate closes\nyou must return again';

  @override
  String get logoutCancel => 'Stay';

  @override
  String get logoutConfirm => 'Leave';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get errorEmailEmpty => 'Please enter your email';

  @override
  String get errorEmailInvalid => 'Invalid email format';

  @override
  String get errorPasswordEmpty => 'Please enter your password';

  @override
  String get errorPasswordShort => 'Password must be at least 6 characters';

  @override
  String get errorNameEmpty => 'Please enter your name';

  @override
  String get errorLoginFailed => 'Login failed';

  @override
  String get errorSignupFailed => 'Signup failed';

  @override
  String get errorGoogleLoginFailed => 'Google login failed';

  @override
  String get errorNetworkFailed => 'Please check your network connection';

  @override
  String get errorUserDataLoad => 'Unable to load user data';

  @override
  String get errorUserNotFound => 'Email not registered';

  @override
  String get errorWrongPassword => 'Wrong password';

  @override
  String get errorUserDisabled => 'Account has been disabled';

  @override
  String get errorTooManyRequests =>
      'Too many attempts. Please try again later';

  @override
  String get errorInvalidCredential => 'Invalid email or password';

  @override
  String get errorLogoutFailed => 'Error occurred during logout';

  @override
  String get errorPasswordResetFailed => 'Failed to send password reset email';

  @override
  String get errorNotEnoughCards => 'Please select more cards';

  @override
  String get successLogin => 'Welcome';

  @override
  String get successSignup => 'Your soul has been registered';

  @override
  String get successLogout => 'Farewell';

  @override
  String get successCardsSelected => 'All cards have been selected';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageLabel => 'App Language';

  @override
  String get settingsLanguageDesc => 'Select your preferred language';

  @override
  String get settingsNotificationTitle => 'Notification Settings';

  @override
  String get settingsDailyNotification => 'Daily Tarot Notification';

  @override
  String get settingsDailyNotificationDesc =>
      'Get your daily fortune every morning';

  @override
  String get settingsWeeklyReport => 'Weekly Tarot Report';

  @override
  String get settingsWeeklyReportDesc => 'Get your weekly fortune every Monday';

  @override
  String get settingsDisplayTitle => 'Display Settings';

  @override
  String get settingsVibration => 'Vibration Effects';

  @override
  String get settingsVibrationDesc => 'Vibration feedback when selecting cards';

  @override
  String get settingsAnimations => 'Animation Effects';

  @override
  String get settingsAnimationsDesc => 'Screen transition animations';

  @override
  String get settingsDataTitle => 'Data Management';

  @override
  String get settingsBackupData => 'Data Backup';

  @override
  String get settingsBackupDataDesc => 'Backup your data to the cloud';

  @override
  String get settingsClearCache => 'Clear Cache';

  @override
  String get settingsClearCacheDesc =>
      'Delete temporary files to free up space';

  @override
  String get settingsDeleteData => 'Delete All Data';

  @override
  String get settingsDeleteDataDesc => 'Delete all tarot records and settings';

  @override
  String get settingsAccountTitle => 'Account';

  @override
  String get settingsChangePassword => 'Change Password';

  @override
  String get settingsChangePasswordDesc =>
      'Change your password for account security';

  @override
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get settingsDeleteAccountDesc => 'Permanently delete your account';

  @override
  String get dialogBackupTitle => 'Data Backup';

  @override
  String get dialogBackupMessage => 'Backup your data to the cloud?';

  @override
  String get dialogClearCacheTitle => 'Clear Cache';

  @override
  String get dialogClearCacheMessage => 'Delete temporary files?';

  @override
  String get dialogDeleteDataTitle => 'Delete All Data';

  @override
  String get dialogDeleteDataMessage =>
      'All tarot records and settings will be permanently deleted.\nThis action cannot be undone.';

  @override
  String get dialogChangePasswordTitle => 'Change Password';

  @override
  String get dialogDeleteAccountTitle => 'Delete Account';

  @override
  String get dialogDeleteAccountMessage =>
      'Deleting your account will permanently delete all data.\nThis action cannot be undone.';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get cancel => 'Cancel';

  @override
  String get backup => 'Backup';

  @override
  String get delete => 'Delete';

  @override
  String get change => 'Change';

  @override
  String get successBackup => 'Data backed up successfully';

  @override
  String get successClearCache => 'Cache cleared';

  @override
  String get successDeleteData => 'All data deleted';

  @override
  String get successChangePassword => 'Password changed successfully';

  @override
  String get successDeleteAccount => 'Account deleted';

  @override
  String errorBackup(String error) {
    return 'Backup failed: $error';
  }

  @override
  String errorDeleteData(String error) {
    return 'Delete failed: $error';
  }

  @override
  String errorChangePassword(String error) {
    return 'Password change failed: $error';
  }

  @override
  String errorDeleteAccount(String error) {
    return 'Account deletion failed: $error';
  }

  @override
  String get errorPasswordMismatch => 'New passwords do not match';

  @override
  String get passwordResetTitle => 'Reset Password';

  @override
  String get passwordResetMessage =>
      'Enter your registered email address.\nWe\'ll send you a password reset link.';

  @override
  String get passwordResetSuccess => 'Password reset email sent';

  @override
  String get send => 'Send';

  @override
  String get emailPlaceholder => 'your@email.com';

  @override
  String get passwordPlaceholder => '6+ characters';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get login => 'Login';

  @override
  String get or => 'or';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get appBrandName => 'MOROKA';

  @override
  String get appBrandTagline => 'oracle of shadows';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutSubtitle => 'Cards of fate await you';

  @override
  String get aboutTagline => 'The cards of fate await you';

  @override
  String get aboutDescription =>
      'MOROKA reads your destiny through ancient mystical tarot cards. Our AI Tarot Master interprets the cosmic messages contained in each of the 78 cards.\n\nDiscover the truth that shines in the darkness, and the special message meant just for you.';

  @override
  String get featuresTitle => 'Key Features';

  @override
  String get feature78Cards => '78 Traditional Tarot Cards';

  @override
  String get feature78CardsDesc =>
      'Complete deck with 22 Major Arcana and 56 Minor Arcana';

  @override
  String get feature5Spreads => '5 Professional Spreads';

  @override
  String get feature5SpreadsDesc =>
      'Various reading methods from One Card to Celtic Cross';

  @override
  String get featureAI => 'AI Tarot Master';

  @override
  String get featureAIDesc =>
      'Deep interpretations like a tarot master with 100 years of experience';

  @override
  String get featureChat => 'Interactive Consultation';

  @override
  String get featureChatDesc => 'Ask questions freely about your cards';

  @override
  String get termsAndPolicies => 'Terms & Policies';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get marketingConsent => 'Marketing Information';

  @override
  String get customerSupport => 'Customer Support';

  @override
  String get emailSupport => 'Email Support';

  @override
  String get website => 'Website';

  @override
  String cannotOpenUrl(String url) {
    return 'Cannot open URL: $url';
  }

  @override
  String get lastModified => 'Last modified: July 3, 2025';

  @override
  String get confirm => 'Confirm';

  @override
  String get companyName => 'Today\'s Studio';

  @override
  String get companyTagline => 'Creating mystical experiences';

  @override
  String get copyright => '© 2025 Today\'s Studio. All rights reserved.';

  @override
  String get anonymousSoul => 'Anonymous Soul';

  @override
  String get totalReadings => 'Total Readings';

  @override
  String get joinDate => 'Join Date';

  @override
  String get errorLogout => 'Error occurred during logout';

  @override
  String get soulContract => 'Soul Contract';

  @override
  String get termsAgreementMessage =>
      'Please agree to the terms for service use';

  @override
  String get agreeAll => 'Agree to All';

  @override
  String get required => 'Required';

  @override
  String get optional => 'Optional';

  @override
  String get agreeAndStart => 'Agree and Start';

  @override
  String get agreeToRequired => 'Please agree to required terms';

  @override
  String get nickname => 'Nickname';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get nextStep => 'Next Step';

  @override
  String get errorNameTooShort => 'Name must be at least 2 characters';

  @override
  String get errorConfirmPassword => 'Please confirm your password';

  @override
  String get errorPasswordsDontMatch => 'Passwords do not match';

  @override
  String get emailInUse => 'Email already in use';

  @override
  String get emailAvailable => 'Email is available';

  @override
  String get nicknameInUse => 'Nickname already in use';

  @override
  String get nicknameAvailable => 'Nickname available';

  @override
  String get passwordWeak => 'Weak';

  @override
  String get passwordFair => 'Fair';

  @override
  String get passwordStrong => 'Strong';

  @override
  String get passwordVeryStrong => 'Very Strong';

  @override
  String get emailVerificationTitle => 'Email Verification';

  @override
  String emailVerificationMessage(String email) {
    return 'We\'ve sent a verification email to $email.\nPlease check your email and click the verification link.';
  }

  @override
  String get resendEmail => 'Resend Email';

  @override
  String get emailResent => 'Verification email resent';

  @override
  String get checkEmailAndReturn =>
      'After verification, please return to the app';

  @override
  String get noHistoryTitle => 'No tarot records yet';

  @override
  String get noHistoryMessage => 'Read your first destiny';

  @override
  String get startReading => 'Start Tarot Reading';

  @override
  String get deleteReadingTitle => 'Delete this record?';

  @override
  String get deleteReadingMessage => 'Deleted records cannot be recovered';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get deleteAllConfirmTitle => 'Delete All Records?';

  @override
  String get deleteAllConfirmMessage =>
      'This will permanently delete all tarot reading records. This action cannot be undone.';

  @override
  String get deleteAllButton => 'Delete All';

  @override
  String get totalTarotReadings => 'Total Tarot Readings';

  @override
  String get mostFrequentCard => 'Most Frequent Card';

  @override
  String get cardFrequencyTop5 => 'Card Frequency TOP 5';

  @override
  String get moodAnalysis => 'Reading Analysis by Mood';

  @override
  String get monthlyReadingTrend => 'Monthly Reading Trend';

  @override
  String get noData => 'No data available';

  @override
  String get noDataToAnalyze => 'No data to analyze yet';

  @override
  String get startTarotReading => 'Start your tarot reading';

  @override
  String get cardOfFate => 'Card of Fate';

  @override
  String get cardCallingYou => 'This card is calling you';

  @override
  String get selectThisCard => 'Will you select it?';

  @override
  String get viewAgain => 'View Again';

  @override
  String get select => 'Select';

  @override
  String get shufflingCards => 'Shuffling the cards of fate...';

  @override
  String get selectCardsIntuition =>
      'Follow your intuition and select the cards';

  @override
  String selectMoreCards(int count) {
    return 'Select $count more cards';
  }

  @override
  String get selectionComplete => 'Selection complete!';

  @override
  String get tapToSelect => 'Tap to select';

  @override
  String get preparingInterpretation => 'Preparing interpretation...';

  @override
  String get cardMessage => 'Card Message';

  @override
  String get cardsStory => 'The Story Your Cards Tell';

  @override
  String get specialInterpretation => 'A Special Interpretation for You';

  @override
  String get interpretingCards => 'Interpreting the meaning of the cards...';

  @override
  String get todaysChatEnded => 'Today\'s conversation has ended';

  @override
  String get askQuestions => 'Ask your questions...';

  @override
  String get continueConversation => 'Continue Conversation';

  @override
  String get wantDeeperTruth => 'Want to know deeper truths?';

  @override
  String get watchAdToContinue =>
      'Watch an ad to continue\nyour conversation with the Tarot Master';

  @override
  String get later => 'Later';

  @override
  String get watchAd => 'Watch Ad';

  @override
  String get emailVerification => 'Email Verification';

  @override
  String get checkYourEmail => 'Check your email';

  @override
  String get verificationEmailSent =>
      'We\'ve sent a verification email to the address above.\nPlease check your inbox and click the verification link.';

  @override
  String get verifyingEmail => 'Verifying email...';

  @override
  String get noEmailReceived => 'Didn\'t receive the email?';

  @override
  String get checkSpamFolder =>
      'Check your spam folder.\nIf it\'s still not there, click the button below to resend.';

  @override
  String resendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get resendVerificationEmail => 'Resend Verification Email';

  @override
  String get alreadyVerified => 'I\'ve already verified';

  @override
  String get openGateOfFate => 'Open the Gate of Fate';

  @override
  String get skip => 'SKIP';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get notificationsEnabled => 'Notifications enabled';

  @override
  String get notificationsDisabled => 'Notifications disabled';

  @override
  String get vibrationEnabled => 'Vibration enabled';

  @override
  String get vibrationDisabled => 'Vibration disabled';

  @override
  String get animationsEnabled => 'Animations enabled';

  @override
  String get animationsDisabled => 'Animations disabled';

  @override
  String get notificationPermissionDenied =>
      'Notification permission is required';

  @override
  String get errorWeakPassword => 'Password is too weak';

  @override
  String get moreTitle => 'More';

  @override
  String get willYouSelectIt => 'Will you select it?';

  @override
  String get selectCardByHeart => 'Select the card that draws your heart';

  @override
  String moreToSelect(int count) {
    return '$count more to select';
  }

  @override
  String get tapToSelectCard => 'Tap the card to select';

  @override
  String get currentSituation => 'Current Situation';

  @override
  String get practicalAdvice => 'Practical Advice';

  @override
  String get futureForecast => 'Future Forecast';

  @override
  String get overallFlow => 'Overall Flow';

  @override
  String get timeBasedInterpretation => 'Time-based Interpretation';

  @override
  String get pastInfluence => 'Past Influence';

  @override
  String get upcomingFuture => 'Upcoming Future';

  @override
  String get actionGuidelines => 'Action Guidelines';

  @override
  String get coreAdvice => 'Core Advice';

  @override
  String get coreSituationAnalysis => 'Core Situation Analysis';

  @override
  String get innerConflict => 'Inner Conflict';

  @override
  String get timelineAnalysis => 'Timeline Analysis';

  @override
  String get externalFactors => 'External Factors';

  @override
  String get finalForecast => 'Final Forecast';

  @override
  String get stepByStepPlan => 'Step-by-Step Plan';

  @override
  String get twoPersonEnergy => 'Two-Person Energy';

  @override
  String get heartTemperatureDifference => 'Heart Temperature Difference';

  @override
  String get relationshipObstacles => 'Relationship Obstacles';

  @override
  String get futurePossibility => 'Future Possibility';

  @override
  String get adviceForLove => 'Advice for Love';

  @override
  String get oneLineAdvice => 'One-Line Advice';

  @override
  String get judgmentBasis => 'Judgment Basis';

  @override
  String get coreMessage => 'Core Message';

  @override
  String get successConditions => 'Success Conditions';

  @override
  String get timingPrediction => 'Timing Prediction';

  @override
  String get actionGuide => 'Action Guide';

  @override
  String get future => 'Future';

  @override
  String get advice => 'Advice';

  @override
  String get message => 'Message';

  @override
  String get meaning => 'Meaning';

  @override
  String get interpretation => 'Interpretation';

  @override
  String get overallMeaning => 'Overall Meaning';

  @override
  String get comprehensiveInterpretation => 'Comprehensive Interpretation';

  @override
  String get futureAdvice => 'Future Advice';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get conditionalYes => 'Conditional Yes';

  @override
  String get analyzingDestiny => 'Analyzing your destiny...';

  @override
  String timesCount(int count) {
    return '$count times';
  }

  @override
  String monthLabel(String month) {
    return '$month';
  }

  @override
  String get remainingDraws => 'Remaining Draws';

  @override
  String get noDrawsRemaining => 'No draws remaining';

  @override
  String get adDraws => 'Ad';

  @override
  String get dailyLimitReached => 'Daily Draw Limit Reached';

  @override
  String get watchAdForMore =>
      'Watch an ad to get more card draws. You can get up to 10 additional draws per day.';

  @override
  String get drawAddedMessage => '1 draw added! ✨';

  @override
  String get adLoadFailed => 'Failed to load ad. Please try again later.';

  @override
  String get openMenu => 'Open menu';

  @override
  String get currentlySelected => 'Currently selected';

  @override
  String get proceedToSpreadSelection => 'Proceed to spread selection';

  @override
  String get selectMoodFirst => 'Please select a mood first';

  @override
  String get currentUser => 'Current user';

  @override
  String get goBack => 'Go back';

  @override
  String get cancelCardSelection => 'Cancel card selection';

  @override
  String get confirmCardSelection => 'Confirm card selection';

  @override
  String get cards => 'cards';

  @override
  String get tapToSelectSpread => 'Tap to select this spread';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get selectedCardsLayout => 'Selected cards layout';

  @override
  String get yourQuestion => 'Your question';

  @override
  String get tarotMaster => 'Tarot Master';

  @override
  String get question => 'Question';

  @override
  String get tarotMasterResponse => 'Tarot master\'s response';

  @override
  String get chatInputField => 'Chat input field';

  @override
  String get sendMessage => 'Send message';

  @override
  String get date => 'Date';

  @override
  String get card => 'Card';

  @override
  String chatCount(int count) {
    return 'Chat $count times';
  }

  @override
  String get deleteReading => 'Delete reading';

  @override
  String get deleteReadingDescription =>
      'Delete this tarot reading permanently';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get cardShowingNewPerspective =>
      'card is showing you a new perspective.';

  @override
  String get moodIsSignOfChange => 'mood is a sign of change.';

  @override
  String get nowIsTurningPoint => 'Now is the turning point.';

  @override
  String get tryDifferentChoiceToday => 'Try making a different choice today';

  @override
  String get talkWithSomeoneSpecial =>
      'Have a conversation with someone special';

  @override
  String get setSmallGoalAndStart => 'Set a small goal and start';

  @override
  String get positiveChangeInWeeks =>
      'You\'ll feel positive changes within 2-3 weeks.';

  @override
  String get flowFromPastToFuture =>
      'The flow from past to present to future is visible.';

  @override
  String get lessonsFromPast => 'Lessons from past experiences';

  @override
  String get upcomingPossibilities => 'Upcoming possibilities';

  @override
  String get acceptPastFocusPresentPrepareFuture =>
      'Accept the past, focus on the present, prepare for the future.';

  @override
  String get mostImportantIsCurrentChoice =>
      'state, the most important thing is your current choice.';

  @override
  String get finalAnswer => 'Final Answer';

  @override
  String get positiveSignals => 'Positive signals';

  @override
  String get cautionSignals => 'Caution signals';

  @override
  String get cardHoldsImportantKey => 'card holds the important key.';

  @override
  String get needCarefulPreparationAndTiming =>
      'Careful preparation and proper timing are needed.';

  @override
  String get oneToTwoWeeks => '1-2 weeks';

  @override
  String get oneToTwoMonths => '1-2 months';

  @override
  String get checkResults => 'to check results';

  @override
  String get doBestRegardlessOfResult =>
      'Do your best to prepare regardless of the outcome.';

  @override
  String get you => 'You';

  @override
  String get partner => 'Partner';

  @override
  String get importantRoleInRelationship =>
      'Important role in the relationship';

  @override
  String get partnersCurrentState => 'Partner\'s current state';

  @override
  String get temperatureDifferenceButUnderstandable =>
      'There\'s a temperature difference in hearts, but it\'s understandable.';

  @override
  String get showingChallenges => ' showing challenges ahead.';

  @override
  String get possibilityWithEffort =>
      'With effort, there\'s over 60% possibility of progress.';

  @override
  String get needConversationUnderstandingTime =>
      'Conversation, understanding, and time are needed.';

  @override
  String get loveIsMirrorReflectingEachOther =>
      'Love is like a mirror reflecting each other.';

  @override
  String get cardsShowingComplexSituation =>
      ' cards are showing a complex situation.';

  @override
  String get conflictBetweenConsciousUnconscious =>
      'There\'s conflict between conscious and unconscious.';

  @override
  String get pastInfluenceContinuesToPresent =>
      'The influence of the past continues to the present.';

  @override
  String get surroundingEnvironmentImportant =>
      'The surrounding environment has important influence.';

  @override
  String get positiveChangePossibility70Percent =>
      'There\'s about 70% possibility of positive change.';

  @override
  String get thisWeek => 'This week';

  @override
  String get thisMonth => 'This month';

  @override
  String get threeMonthsLater => '3 months later';

  @override
  String get organizeSituation => 'Organize the situation';

  @override
  String get startConcreteAction => 'Start concrete action';

  @override
  String get youHavePowerToOvercome =>
      'You have the power within to overcome your current state.';

  @override
  String get when => 'when';

  @override
  String get timing => 'timing';

  @override
  String get how => 'how';

  @override
  String get method => 'method';

  @override
  String get why => 'why';

  @override
  String get reason => 'reason';

  @override
  String tarotTimingAnswer(String cardName) {
    return 'Tarot typically shows timing between 1-3 months. Looking at the $cardName card\'s energy, it might be sooner. The best time is when you\'re ready.';
  }

  @override
  String tarotMethodAnswer(String cardName) {
    return 'The $cardName card says to follow your intuition. Don\'t overthink it, just take one step at a time following your heart. Small beginnings create big changes.';
  }

  @override
  String tarotReasonAnswer(String cardName) {
    return 'The reason is, as the $cardName card suggests, now is the time for change. It\'s time to break free from past patterns and open new possibilities.';
  }

  @override
  String tarotGeneralAnswer(String cardName) {
    return 'Good question. From the $cardName card\'s perspective, now is the time to move forward carefully yet courageously. What aspect are you most curious about?';
  }

  @override
  String get startChatMessage => 'Ask me anything about your tarot reading';

  @override
  String get chatHistory => 'Chat History';

  @override
  String get chatHistoryDescription =>
      'Your conversation with the Tarot Master';

  @override
  String get past => 'Past';

  @override
  String get present => 'Present';

  @override
  String get positiveChangePossibility => 'Possibility of positive change';

  @override
  String get futureOutlook => 'Future Outlook';

  @override
  String get free => 'Free';

  @override
  String get paid => 'Paid';

  @override
  String get oneCardDescription => 'Today\'s fortune and advice';

  @override
  String get threeCardDescription => 'Flow of past, present, future';

  @override
  String get celticCrossDescription => 'Analyze all aspects of the situation';

  @override
  String get relationshipDescription => 'Dynamics and future of relationships';

  @override
  String get yesNoDescription => 'Fortune telling for clear answers';

  @override
  String get errorApiMessage =>
      'Sorry, the threads of fate have become tangled. Please try again.';

  @override
  String defaultInterpretationStart(String spreadName) {
    return 'The $spreadName spread has been laid out.';
  }

  @override
  String selectedCardsLabel(String cards) {
    return 'Selected cards: $cards';
  }

  @override
  String cardEnergyResonance(String mood) {
    return 'The energy created by these cards resonates with your $mood heart.';
  }

  @override
  String get deeperInterpretationComing =>
      'Each card\'s message connects to form a larger picture.\n\nI will share a deeper interpretation shortly...';

  @override
  String get waitingMessage => 'Loading...';

  @override
  String get nameAvailable => 'Name is available';

  @override
  String get nameAlreadyTaken => 'Name is already taken';

  @override
  String get errorNameCheckFailed => 'Error checking name availability';

  @override
  String get emailAlreadyRegistered => 'Email is already registered';

  @override
  String get errorEmailCheckFailed => 'Error checking email availability';

  @override
  String get messageRequired => 'Please enter a message';

  @override
  String get messageTooLong => 'Message must be within 500 characters';

  @override
  String get messageInvalidCharacters => 'Message contains invalid characters';

  @override
  String get messageInvalidScript => 'Message contains invalid script';

  @override
  String get passwordRequired => 'Please enter a password';

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthMedium => 'Medium';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get errorInvalidFormat => 'Invalid format';

  @override
  String get errorUnexpected => 'An unexpected error occurred';

  @override
  String get errorUnknown => 'Unknown error occurred';

  @override
  String get errorNetworkTimeout => 'Network connection timed out';

  @override
  String get errorNoInternet => 'No internet connection';

  @override
  String get errorServerError => 'Server error occurred';

  @override
  String get errorInvalidCredentials => 'Invalid email or password';

  @override
  String get errorEmailNotVerified => 'Email not verified';

  @override
  String get errorSessionExpired => 'Session expired. Please login again';

  @override
  String get errorQuotaExceeded => 'Daily limit exceeded';

  @override
  String get errorInvalidResponse => 'Invalid response from server';

  @override
  String get errorRateLimitExceeded =>
      'Too many requests. Please try again later';

  @override
  String get errorDataNotFound => 'Data not found';

  @override
  String get errorDataCorrupted => 'Data corrupted';

  @override
  String get errorSaveFailed => 'Failed to save data';

  @override
  String get errorPermissionDenied => 'Permission denied';

  @override
  String get errorPermissionRestricted => 'Access restricted';

  @override
  String get errorEmailAlreadyInUse => 'Email already in use';

  @override
  String get errorInvalidEmail => 'Invalid email address';

  @override
  String get errorNetworkRequestFailed => 'Network request failed';

  @override
  String get errorOperationNotAllowed => 'Operation not allowed';

  @override
  String get errorAuthFailed => 'Authentication failed';

  @override
  String get logoutSuccess => 'Logged out successfully';

  @override
  String get deleteAccountSuccess => 'Account deleted successfully';

  @override
  String get generalSettings => 'General Settings';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get languageTitle => 'Language';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get vibrationTitle => 'Haptic Feedback';

  @override
  String get vibrationSubtitle => 'Enable vibration feedback';

  @override
  String get animationsTitle => 'Animations';

  @override
  String get animationsSubtitle => 'Enable UI animations';

  @override
  String get dailyTarotReminder => 'Get daily tarot reminders';

  @override
  String get deleteAccountConfirmMessage =>
      'This action cannot be undone. All your data will be permanently deleted.';

  @override
  String get selectedCards => 'Selected Cards';

  @override
  String get aiInterpretation => 'AI Interpretation';

  @override
  String get invalidEmotionInput => 'Invalid emotion input.';

  @override
  String get interpretationNotReceived =>
      'Could not receive interpretation result.';

  @override
  String get responseGenerationFailed => 'Failed to generate response.';

  @override
  String get invalidEmailFormat => 'Invalid email format.';

  @override
  String get weakPassword =>
      'Password is too weak. Please use at least 8 characters including uppercase, lowercase, numbers, and special characters.';

  @override
  String get invalidUsername =>
      'Username must be 3-20 characters using only letters, numbers, and underscores.';

  @override
  String get signupError => 'An error occurred during sign up.';

  @override
  String get loginError => 'An error occurred during login.';

  @override
  String get logoutError => 'An error occurred during logout.';

  @override
  String get passwordResetEmailFailed => 'Failed to send password reset email.';

  @override
  String get profileCreationFailed => 'Failed to create user profile.';

  @override
  String get noLoggedInUser => 'No logged in user.';

  @override
  String get profileUpdateFailed => 'Failed to update profile.';

  @override
  String cardInterpretationFailed(String error) {
    return 'Failed to get card interpretation: $error';
  }

  @override
  String get emailAlreadyInUse => 'This email is already in use.';

  @override
  String signupErrorWithMessage(String message) {
    return 'An error occurred during sign up: $message';
  }

  @override
  String get tooManyRequests => 'Too many requests. Please try again later.';

  @override
  String get verificationEmailError =>
      'An error occurred while sending verification email.';
}

/// The translations for English (`en_fallback`).
class AppLocalizationsEnFallback extends AppLocalizationsEn {
  AppLocalizationsEnFallback() : super('en_fallback');

  @override
  String get no => 'No';

  @override
  String get conditionalYes => 'Conditional Yes';

  @override
  String get remainingDraws => 'Remaining Draws';

  @override
  String get noDrawsRemaining => 'No draws remaining';

  @override
  String get adDraws => 'Ad';

  @override
  String get cards => ' cards';

  @override
  String get tarotMaster => 'Tarot Master';

  @override
  String get question => 'Question';

  @override
  String get cardShowingNewPerspective =>
      'card is showing you a new perspective.';

  @override
  String get moodIsSignOfChange => 'mood is a sign of change.';

  @override
  String get nowIsTurningPoint => 'Now is the turning point.';

  @override
  String get tryDifferentChoiceToday => 'Try making a different choice today';

  @override
  String get talkWithSomeoneSpecial =>
      'Have a conversation with someone special';

  @override
  String get setSmallGoalAndStart => 'Set a small goal and start';

  @override
  String get positiveChangeInWeeks =>
      'You\'ll feel positive changes within 2-3 weeks.';

  @override
  String get flowFromPastToFuture =>
      'The flow from past to present to future is visible.';

  @override
  String get lessonsFromPast => 'Lessons from past experiences';

  @override
  String get upcomingPossibilities => 'Upcoming possibilities';

  @override
  String get acceptPastFocusPresentPrepareFuture =>
      'Accept the past, focus on the present, prepare for the future.';

  @override
  String get mostImportantIsCurrentChoice =>
      'state, the most important thing is your current choice.';

  @override
  String get finalAnswer => 'Final Answer';

  @override
  String get positiveSignals => 'Positive signals';

  @override
  String get cautionSignals => 'Caution signals';

  @override
  String get cardHoldsImportantKey => 'card holds the important key.';

  @override
  String get needCarefulPreparationAndTiming =>
      'Careful preparation and proper timing are needed.';

  @override
  String get oneToTwoWeeks => '1-2 weeks';

  @override
  String get oneToTwoMonths => '1-2 months';

  @override
  String get checkResults => 'to check results';

  @override
  String get doBestRegardlessOfResult =>
      'Do your best to prepare regardless of the outcome.';

  @override
  String get you => 'You';

  @override
  String get partner => 'Partner';

  @override
  String get importantRoleInRelationship =>
      'Important role in the relationship';

  @override
  String get partnersCurrentState => 'Partner\'s current state';

  @override
  String get temperatureDifferenceButUnderstandable =>
      'There\'s a temperature difference in hearts, but it\'s understandable.';

  @override
  String get showingChallenges => ' showing challenges ahead.';

  @override
  String get possibilityWithEffort =>
      'With effort, there\'s over 60% possibility of progress.';

  @override
  String get needConversationUnderstandingTime =>
      'Conversation, understanding, and time are needed.';

  @override
  String get loveIsMirrorReflectingEachOther =>
      'Love is like a mirror reflecting each other.';

  @override
  String get cardsShowingComplexSituation =>
      ' cards are showing a complex situation.';

  @override
  String get conflictBetweenConsciousUnconscious =>
      'There\'s conflict between conscious and unconscious.';

  @override
  String get pastInfluenceContinuesToPresent =>
      'The influence of the past continues to the present.';

  @override
  String get surroundingEnvironmentImportant =>
      'The surrounding environment has important influence.';

  @override
  String get positiveChangePossibility70Percent =>
      'There\'s about 70% possibility of positive change.';

  @override
  String get thisWeek => 'This week';

  @override
  String get thisMonth => 'This month';

  @override
  String get threeMonthsLater => '3 months later';

  @override
  String get organizeSituation => 'Organize the situation';

  @override
  String get startConcreteAction => 'Start concrete action';

  @override
  String get youHavePowerToOvercome =>
      'You have the power within to overcome your current state.';

  @override
  String get when => 'when';

  @override
  String get timing => 'timing';

  @override
  String get how => 'how';

  @override
  String get method => 'method';

  @override
  String get why => 'why';

  @override
  String get reason => 'reason';

  @override
  String tarotTimingAnswer(String cardName) {
    return 'Tarot typically shows timing between 1-3 months. Looking at the $cardName card\'s energy, it might be sooner. The best time is when you\'re ready.';
  }

  @override
  String tarotMethodAnswer(String cardName) {
    return 'The $cardName card says to follow your intuition. Don\'t overthink it, just take one step at a time following your heart. Small beginnings create big changes.';
  }

  @override
  String tarotReasonAnswer(String cardName) {
    return 'The reason is, as the $cardName card suggests, now is the time for change. It\'s time to break free from past patterns and open new possibilities.';
  }

  @override
  String tarotGeneralAnswer(String cardName) {
    return 'Good question. From the $cardName card\'s perspective, now is the time to move forward carefully yet courageously. What aspect are you most curious about?';
  }

  @override
  String get startChatMessage => 'Ask me anything about your tarot reading';

  @override
  String get chatHistory => 'Chat History';

  @override
  String get chatHistoryDescription =>
      'Your conversation with the Tarot Master';
}
