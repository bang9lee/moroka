// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'Moroka';

  @override
  String get appTagline => 'छायाओं का दैवज्ञ';

  @override
  String get appTitle => 'Moroka - अशुभ फुसफुसाहट';

  @override
  String get onboardingTitle1 => 'भाग्य का द्वार खुलता है';

  @override
  String get onboardingDesc1 =>
      'प्राचीन ज्ञान आधुनिक तकनीक से मिलता है\nआपके भविष्य को फुसफुसाने के लिए';

  @override
  String get onboardingTitle2 => 'अंधकार में सत्य';

  @override
  String get onboardingDesc2 =>
      'टैरो कार्ड कभी झूठ नहीं बोलते\nवे केवल वह सत्य दिखाते हैं जिसे आप सह सकते हैं';

  @override
  String get onboardingTitle3 => 'AI आपका भाग्य पढ़ता है';

  @override
  String get onboardingDesc3 =>
      'कृत्रिम बुद्धिमत्ता आपके कार्डों की व्याख्या करती है\nऔर गहरी बातचीत से आपका मार्ग दिखाती है';

  @override
  String get onboardingTitle4 => 'क्या आप तैयार हैं?';

  @override
  String get onboardingDesc4 =>
      'हर चुनाव की अपनी कीमत होती है\nयदि आप अपने भाग्य का सामना करने के लिए तैयार हैं...';

  @override
  String get loginTitle => 'आप वापस आ गए हैं';

  @override
  String get loginSubtitle => 'हम आपका इंतज़ार कर रहे थे';

  @override
  String get signupTitle => 'भाग्य का अनुबंध';

  @override
  String get signupSubtitle => 'अपनी आत्मा को पंजीकृत करें';

  @override
  String get emailLabel => 'ईमेल';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get nameLabel => 'नाम';

  @override
  String get loginButton => 'प्रवेश करें';

  @override
  String get signupButton => 'आत्मा पंजीकरण';

  @override
  String get googleLogin => 'Google से लॉगिन करें';

  @override
  String get googleSignup => 'Google से शुरू करें';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है? लॉगिन करें';

  @override
  String get dontHaveAccount => 'पहली बार? साइन अप करें';

  @override
  String get moodQuestion => 'अभी आप कैसा महसूस कर रहे हैं?';

  @override
  String get selectSpreadButton => 'टैरो स्प्रेड चुनें';

  @override
  String get moodAnxious => 'चिंतित';

  @override
  String get moodLonely => 'अकेला';

  @override
  String get moodCurious => 'जिज्ञासु';

  @override
  String get moodFearful => 'भयभीत';

  @override
  String get moodHopeful => 'आशावान';

  @override
  String get moodConfused => 'भ्रमित';

  @override
  String get moodDesperate => 'निराश';

  @override
  String get moodExpectant => 'प्रत्याशी';

  @override
  String get moodMystical => 'रहस्यमय';

  @override
  String get spreadSelectionTitle => 'स्प्रेड चुनें';

  @override
  String get spreadSelectionSubtitle =>
      'अपनी वर्तमान भावनाओं के आधार पर स्प्रेड चुनें';

  @override
  String get spreadDifficultyBeginner => '1-3 कार्ड';

  @override
  String get spreadDifficultyIntermediate => '5-7 कार्ड';

  @override
  String get spreadDifficultyAdvanced => '10 कार्ड';

  @override
  String get spreadOneCard => 'एक कार्ड';

  @override
  String get spreadThreeCard => 'तीन कार्ड';

  @override
  String get spreadCelticCross => 'केल्टिक क्रॉस';

  @override
  String get spreadRelationship => 'रिश्ता स्प्रेड';

  @override
  String get spreadYesNo => 'हाँ/नहीं';

  @override
  String get selectCardTitle => 'भाग्य के कार्ड चुनें';

  @override
  String get currentMoodLabel => 'आपका वर्तमान मूड: ';

  @override
  String get currentSpreadLabel => 'चुना गया स्प्रेड: ';

  @override
  String get shufflingMessage => 'भाग्य के धागे गुंथ रहे हैं...';

  @override
  String get selectCardInstruction =>
      'अपनी अंतर्दृष्टि का पालन करें और कार्ड चुनें';

  @override
  String cardsSelected(int count) {
    return '$count चुने गए';
  }

  @override
  String cardsRemaining(int count) {
    return '$count और चुनें';
  }

  @override
  String get todaysCard => 'Today\'s Card';

  @override
  String get threeCardSpread => 'Three Card Spread';

  @override
  String get celticCrossSpread => 'Celtic Cross Spread';

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
  String get typeMessageHint => 'संदेश टाइप करें...';

  @override
  String get continueReading => 'गहरी सलाह प्राप्त करें';

  @override
  String get watchAdPrompt =>
      'गहरे रसातल से आवाज़ सुनने के लिए,\nआपको दूसरी दुनिया से संदेश देखने होंगे।';

  @override
  String get interpretingSpread =>
      'कार्डों के संदेशों की व्याख्या कर रहा है...';

  @override
  String get menuHistory => 'पिछले टैरो रिकॉर्ड';

  @override
  String get menuHistoryDesc => 'अपने पिछले भाग्य को देखें';

  @override
  String get menuStatistics => 'सांख्यिकी और विश्लेषण';

  @override
  String get menuStatisticsDesc => 'अपने भाग्य के पैटर्न का विश्लेषण करें';

  @override
  String get menuSettings => 'सेटिंग्स';

  @override
  String get menuSettingsDesc => 'ऐप वातावरण समायोजित करें';

  @override
  String get menuAbout => 'के बारे में';

  @override
  String get menuAboutDesc => 'Moroka - छायाओं का दैवज्ञ';

  @override
  String get logoutButton => 'लॉगआउट';

  @override
  String get logoutTitle => 'क्या आप वास्तव में जा रहे हैं?';

  @override
  String get logoutMessage =>
      'जब भाग्य का द्वार बंद हो जाता है\nआपको फिर से वापस आना होगा';

  @override
  String get logoutCancel => 'रहें';

  @override
  String get logoutConfirm => 'जाएं';

  @override
  String get errorOccurred => 'एक त्रुटि हुई';

  @override
  String get errorEmailEmpty => 'कृपया अपना ईमेल दर्ज करें';

  @override
  String get errorEmailInvalid => 'अमान्य ईमेल प्रारूप';

  @override
  String get errorPasswordEmpty => 'कृपया अपना पासवर्ड दर्ज करें';

  @override
  String get errorPasswordShort => 'पासवर्ड कम से कम 6 वर्ण का होना चाहिए';

  @override
  String get errorNameEmpty => 'कृपया अपना नाम दर्ज करें';

  @override
  String get errorLoginFailed => 'लॉगिन विफल';

  @override
  String get errorSignupFailed => 'साइनअप विफल';

  @override
  String get errorGoogleLoginFailed => 'Google लॉगिन विफल';

  @override
  String get errorNetworkFailed => 'कृपया अपना नेटवर्क कनेक्शन जांचें';

  @override
  String get errorNotEnoughCards => 'कृपया और कार्ड चुनें';

  @override
  String get successLogin => 'स्वागत है';

  @override
  String get successSignup => 'आपकी आत्मा पंजीकृत हो गई है';

  @override
  String get successLogout => 'अलविदा';

  @override
  String get successCardsSelected => 'सभी कार्ड चुने गए हैं';

  @override
  String get settingsLanguageTitle => 'भाषा';

  @override
  String get settingsLanguageLabel => 'ऐप की भाषा';

  @override
  String get settingsLanguageDesc => 'अपनी पसंदीदा भाषा चुनें';

  @override
  String get settingsNotificationTitle => 'सूचना सेटिंग्स';

  @override
  String get settingsDailyNotification => 'दैनिक टैरो सूचना';

  @override
  String get settingsDailyNotificationDesc =>
      'हर सुबह अपना दैनिक भाग्य प्राप्त करें';

  @override
  String get settingsWeeklyReport => 'साप्ताहिक टैरो रिपोर्ट';

  @override
  String get settingsWeeklyReportDesc =>
      'हर सोमवार अपना साप्ताहिक भाग्य प्राप्त करें';

  @override
  String get settingsDisplayTitle => 'प्रदर्शन सेटिंग्स';

  @override
  String get settingsVibration => 'कंपन प्रभाव';

  @override
  String get settingsVibrationDesc => 'कार्ड चुनते समय कंपन फीडबैक';

  @override
  String get settingsAnimations => 'एनिमेशन प्रभाव';

  @override
  String get settingsAnimationsDesc => 'स्क्रीन संक्रमण एनिमेशन';

  @override
  String get settingsDataTitle => 'डेटा प्रबंधन';

  @override
  String get settingsBackupData => 'डेटा बैकअप';

  @override
  String get settingsBackupDataDesc => 'अपना डेटा क्लाउड में बैकअप करें';

  @override
  String get settingsClearCache => 'कैश साफ़ करें';

  @override
  String get settingsClearCacheDesc =>
      'स्थान खाली करने के लिए अस्थायी फ़ाइलें हटाएं';

  @override
  String get settingsDeleteData => 'सभी डेटा हटाएं';

  @override
  String get settingsDeleteDataDesc => 'सभी टैरो रिकॉर्ड और सेटिंग्स हटाएं';

  @override
  String get settingsAccountTitle => 'खाता';

  @override
  String get settingsChangePassword => 'पासवर्ड बदलें';

  @override
  String get settingsChangePasswordDesc =>
      'खाता सुरक्षा के लिए अपना पासवर्ड बदलें';

  @override
  String get settingsDeleteAccount => 'खाता हटाएं';

  @override
  String get settingsDeleteAccountDesc => 'अपना खाता स्थायी रूप से हटाएं';

  @override
  String get dialogBackupTitle => 'डेटा बैकअप';

  @override
  String get dialogBackupMessage => 'अपना डेटा क्लाउड में बैकअप करें?';

  @override
  String get dialogClearCacheTitle => 'कैश साफ़ करें';

  @override
  String get dialogClearCacheMessage => 'अस्थायी फ़ाइलें हटाएं?';

  @override
  String get dialogDeleteDataTitle => 'सभी डेटा हटाएं';

  @override
  String get dialogDeleteDataMessage =>
      'सभी टैरो रिकॉर्ड और सेटिंग्स स्थायी रूप से हटा दिए जाएंगे।\nयह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get dialogChangePasswordTitle => 'पासवर्ड बदलें';

  @override
  String get dialogDeleteAccountTitle => 'खाता हटाएं';

  @override
  String get dialogDeleteAccountMessage =>
      'अपना खाता हटाने से सभी डेटा स्थायी रूप से हटा दिया जाएगा।\nयह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get currentPassword => 'वर्तमान पासवर्ड';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get confirmNewPassword => 'नया पासवर्ड की पुष्टि करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get backup => 'बैकअप';

  @override
  String get delete => 'हटाएं';

  @override
  String get change => 'बदलें';

  @override
  String get successBackup => 'बैकअप पूर्ण हुआ';

  @override
  String get successClearCache => 'कैश साफ़ हो गया';

  @override
  String get successDeleteData => 'सभी डेटा हटा दिया गया';

  @override
  String get successChangePassword => 'पासवर्ड बदल दिया गया';

  @override
  String get successDeleteAccount => 'खाता हटा दिया गया';

  @override
  String errorBackup(String error) {
    return 'बैकअप विफल: $error';
  }

  @override
  String errorDeleteData(String error) {
    return 'हटाना विफल: $error';
  }

  @override
  String errorChangePassword(String error) {
    return 'पासवर्ड बदलना विफल: $error';
  }

  @override
  String errorDeleteAccount(String error) {
    return 'खाता हटाना विफल: $error';
  }

  @override
  String get errorPasswordMismatch => 'नए पासवर्ड मेल नहीं खाते';

  @override
  String get passwordResetTitle => 'पासवर्ड रीसेट करें';

  @override
  String get passwordResetMessage =>
      'अपना पंजीकृत ईमेल पता दर्ज करें।\nहम आपको पासवर्ड रीसेट लिंक भेजेंगे।';

  @override
  String get passwordResetSuccess => 'पासवर्ड रीसेट ईमेल भेजा गया';

  @override
  String get send => 'भेजें';

  @override
  String get emailPlaceholder => 'your@email.com';

  @override
  String get passwordPlaceholder => '6+ वर्ण';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get login => 'लॉगिन';

  @override
  String get or => 'या';

  @override
  String get continueWithGoogle => 'Google से जारी रखें';

  @override
  String get noAccount => 'खाता नहीं है?';

  @override
  String get signUp => 'साइन अप करें';

  @override
  String get appBrandName => 'MOROKA';

  @override
  String get appBrandTagline => 'छायाओं का दैवज्ञ';

  @override
  String get aboutTitle => 'परिचय';

  @override
  String get aboutSubtitle => 'भाग्य के पत्ते आपकी प्रतीक्षा कर रहे हैं';

  @override
  String get aboutDescription =>
      'MOROKA\n\nभाग्य का द्वार खुल गया है\nछाया दैवज्ञ आपके भविष्य की व्याख्या करेगा\n\nरहस्यमय AI के साथ पारंपरिक टैरो व्याख्या\nगहरी अंतर्दृष्टि और ज्ञान प्रदान करना';

  @override
  String get featuresTitle => 'मुख्य विशेषताएं';

  @override
  String get feature78Cards => '78 पारंपरिक टैरो कार्ड';

  @override
  String get feature78CardsDesc =>
      '22 मेजर आर्काना और 56 माइनर आर्काना के साथ पूर्ण डेक';

  @override
  String get feature5Spreads => '5 पेशेवर स्प्रेड';

  @override
  String get feature5SpreadsDesc =>
      'एक कार्ड से लेकर केल्टिक क्रॉस तक विभिन्न पठन विधियां';

  @override
  String get featureAI => 'AI टैरो मास्टर';

  @override
  String get featureAIDesc =>
      '100 वर्षों के अनुभव वाले टैरो मास्टर की तरह गहरी व्याख्याएं';

  @override
  String get featureChat => 'इंटरैक्टिव परामर्श';

  @override
  String get featureChatDesc =>
      'अपने कार्डों के बारे में स्वतंत्र रूप से प्रश्न पूछें';

  @override
  String get termsAndPolicies => 'शर्तें और नीतियां';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get marketingConsent => 'विपणन जानकारी';

  @override
  String get customerSupport => 'ग्राहक सहायता';

  @override
  String get emailSupport => 'ईमेल सहायता';

  @override
  String get website => 'वेबसाइट';

  @override
  String cannotOpenUrl(String url) {
    return 'URL नहीं खोल सकते: $url';
  }

  @override
  String get lastModified => 'अंतिम संशोधन: 3 जुलाई, 2025';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get companyName => 'Today\'s Studio';

  @override
  String get companyTagline => 'रहस्यमय अनुभव बनाना';

  @override
  String get copyright => '© 2025 Today\'s Studio. सर्वाधिकार सुरक्षित।';

  @override
  String get anonymousSoul => 'अज्ञात आत्मा';

  @override
  String get totalReadings => 'कुल रीडिंग';

  @override
  String get joinDate => 'शामिल होने की तारीख';

  @override
  String get errorLogout => 'लॉगआउट के दौरान त्रुटि हुई';

  @override
  String get soulContract => 'आत्मा अनुबंध';

  @override
  String get termsAgreementMessage =>
      'सेवा उपयोग के लिए कृपया शर्तों से सहमत हों';

  @override
  String get agreeAll => 'सभी से सहमत';

  @override
  String get required => 'आवश्यक';

  @override
  String get optional => 'वैकल्पिक';

  @override
  String get agreeAndStart => 'सहमत हों और शुरू करें';

  @override
  String get agreeToRequired => 'कृपया आवश्यक शर्तों से सहमत हों';

  @override
  String get nickname => 'उपनाम';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get nextStep => 'अगला चरण';

  @override
  String get errorNameTooShort => 'कम से कम 2 वर्ण दर्ज करें';

  @override
  String get errorConfirmPassword => 'कृपया अपने पासवर्ड की पुष्टि करें';

  @override
  String get errorPasswordsDontMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get emailInUse => 'ईमेल पहले से उपयोग में है';

  @override
  String get emailAvailable => 'ईमेल उपलब्ध है';

  @override
  String get nicknameInUse => 'उपनाम पहले से उपयोग में है';

  @override
  String get nicknameAvailable => 'उपनाम उपलब्ध है';

  @override
  String get passwordWeak => 'कमज़ोर';

  @override
  String get passwordFair => 'ठीक';

  @override
  String get passwordStrong => 'मज़बूत';

  @override
  String get passwordVeryStrong => 'बहुत मज़बूत';

  @override
  String get emailVerificationTitle => 'ईमेल सत्यापन';

  @override
  String emailVerificationMessage(String email) {
    return 'हमने $email पर एक सत्यापन ईमेल भेजा है।\nकृपया अपना ईमेल जांचें और सत्यापन लिंक पर क्लिक करें।';
  }

  @override
  String get resendEmail => 'ईमेल फिर से भेजें';

  @override
  String get emailResent => 'सत्यापन ईमेल फिर से भेजा गया';

  @override
  String get checkEmailAndReturn => 'सत्यापन के बाद, कृपया ऐप पर वापस आएं';

  @override
  String get noHistoryTitle => 'अभी तक कोई टैरो रिकॉर्ड नहीं';

  @override
  String get noHistoryMessage => 'अपना पहला भाग्य पढ़ें';

  @override
  String get startReading => 'टैरो रीडिंग शुरू करें';

  @override
  String get deleteReadingTitle => 'इस रिकॉर्ड को हटाएं?';

  @override
  String get deleteReadingMessage =>
      'हटाए गए रिकॉर्ड पुनर्प्राप्त नहीं किए जा सकते';

  @override
  String get cardOfFate => 'भाग्य का कार्ड';

  @override
  String get cardCallingYou => 'आपको बुलाने वाला कार्ड';

  @override
  String get selectThisCard => 'इस कार्ड को चुनें';

  @override
  String get viewAgain => 'फिर से देखें';

  @override
  String get select => 'चुनें';

  @override
  String get shufflingCards => 'कार्ड फेंटे जा रहे हैं...';

  @override
  String get selectCardsIntuition => 'अपनी अंतर्दृष्टि से कार्ड चुनें';

  @override
  String selectMoreCards(int count) {
    return 'अभी भी $count कार्ड चुनें';
  }

  @override
  String get selectionComplete => 'चयन पूर्ण';

  @override
  String get tapToSelect => 'चुनने के लिए टैप करें';

  @override
  String get preparingInterpretation => 'व्याख्या तैयार की जा रही है...';

  @override
  String get cardMessage => 'कार्ड का संदेश';

  @override
  String get cardsStory => 'कार्डों की कहानी';

  @override
  String get specialInterpretation => 'विशेष व्याख्या';

  @override
  String get interpretingCards => 'कार्डों की व्याख्या की जा रही है...';

  @override
  String get todaysChatEnded => 'आज की बातचीत समाप्त हो गई';

  @override
  String get askQuestions => 'प्रश्न पूछें';

  @override
  String get continueConversation => 'बातचीत जारी रखें';

  @override
  String get wantDeeperTruth => 'क्या आप गहरा सत्य चाहते हैं?';

  @override
  String get watchAdToContinue => 'जारी रखने के लिए विज्ञापन देखें';

  @override
  String get later => 'बाद में';

  @override
  String get watchAd => 'विज्ञापन देखें';

  @override
  String get emailVerification => 'ईमेल सत्यापन';

  @override
  String get checkYourEmail => 'अपना ईमेल जांचें';

  @override
  String get verificationEmailSent => 'सत्यापन ईमेल भेजा गया';

  @override
  String get verifyingEmail => 'ईमेल सत्यापित किया जा रहा है...';

  @override
  String get noEmailReceived => 'ईमेल प्राप्त नहीं हुआ?';

  @override
  String get checkSpamFolder => 'अपना स्पैम फ़ोल्डर जांचें';

  @override
  String resendIn(int seconds) {
    return '$seconds सेकंड में फिर से भेजें';
  }

  @override
  String get resendVerificationEmail => 'सत्यापन ईमेल फिर से भेजें';

  @override
  String get alreadyVerified => 'पहले से सत्यापित';

  @override
  String get openGateOfFate => 'भाग्य का द्वार खोलें';

  @override
  String get skip => 'छोड़ें';

  @override
  String get willYouSelectIt => 'क्या आप इसे चुनेंगे?';

  @override
  String get selectCardByHeart =>
      'वह कार्ड चुनें जो आपके दिल को आकर्षित करता है';

  @override
  String moreToSelect(int count) {
    return '$count और चुनना है';
  }

  @override
  String get tapToSelectCard => 'चुनने के लिए कार्ड पर टैप करें';

  @override
  String get currentSituation => 'वर्तमान स्थिति';

  @override
  String get practicalAdvice => 'व्यावहारिक सलाह';

  @override
  String get futureForecast => 'भविष्य की भविष्यवाणी';

  @override
  String get overallFlow => 'समग्र प्रवाह';

  @override
  String get timeBasedInterpretation => 'समय आधारित व्याख्या';

  @override
  String get pastInfluence => 'अतीत का प्रभाव';

  @override
  String get upcomingFuture => 'आगामी भविष्य';

  @override
  String get actionGuidelines => 'कार्य दिशानिर्देश';

  @override
  String get coreAdvice => 'मुख्य सलाह';

  @override
  String get coreSituationAnalysis => 'मुख्य स्थिति विश्लेषण';

  @override
  String get innerConflict => 'आंतरिक संघर्ष';

  @override
  String get timelineAnalysis => 'समयरेखा विश्लेषण';

  @override
  String get externalFactors => 'बाहरी कारक';

  @override
  String get finalForecast => 'अंतिम पूर्वानुमान';

  @override
  String get stepByStepPlan => 'चरण-दर-चरण योजना';

  @override
  String get twoPersonEnergy => 'दो व्यक्ति की ऊर्जा';

  @override
  String get heartTemperatureDifference => 'दिल के तापमान का अंतर';

  @override
  String get relationshipObstacles => 'संबंध बाधाएं';

  @override
  String get futurePossibility => 'भविष्य की संभावना';

  @override
  String get adviceForLove => 'प्रेम के लिए सलाह';

  @override
  String get oneLineAdvice => 'एक पंक्ति की सलाह';

  @override
  String get judgmentBasis => 'निर्णय आधार';

  @override
  String get coreMessage => 'मुख्य संदेश';

  @override
  String get successConditions => 'सफलता की शर्तें';

  @override
  String get timingPrediction => 'समय की भविष्यवाणी';

  @override
  String get actionGuide => 'कार्य मार्गदर्शक';

  @override
  String get future => 'भविष्य';

  @override
  String get advice => 'सलाह';

  @override
  String get message => 'संदेश';

  @override
  String get meaning => 'अर्थ';

  @override
  String get interpretation => 'व्याख्या';

  @override
  String get overallMeaning => 'समग्र अर्थ';

  @override
  String get comprehensiveInterpretation => 'व्यापक व्याख्या';

  @override
  String get futureAdvice => 'भविष्य की सलाह';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get conditionalYes => 'सशर्त हाँ';

  @override
  String get analyzingDestiny => 'आपके भाग्य का विश्लेषण कर रहे हैं...';

  @override
  String get noDataToAnalyze => 'अभी तक विश्लेषण के लिए कोई डेटा नहीं';

  @override
  String get startTarotReading => 'अपना टैरो रीडिंग शुरू करें';

  @override
  String get totalTarotReadings => 'कुल टैरो रीडिंग';

  @override
  String get mostFrequentCard => 'सबसे अधिक बार आने वाला कार्ड';

  @override
  String get cardFrequencyTop5 => 'कार्ड आवृत्ति शीर्ष 5';

  @override
  String get moodAnalysis => 'मनोदशा द्वारा रीडिंग विश्लेषण';

  @override
  String get monthlyReadingTrend => 'मासिक रीडिंग रुझान';

  @override
  String get noData => 'कोई डेटा उपलब्ध नहीं';

  @override
  String timesCount(int count) {
    return '$count बार';
  }

  @override
  String monthLabel(String month) {
    return '$month';
  }

  @override
  String get remainingDraws => 'शेष ड्रॉ';

  @override
  String get noDrawsRemaining => 'कोई ड्रॉ शेष नहीं';

  @override
  String get adDraws => 'विज्ञापन';

  @override
  String get dailyLimitReached => 'दैनिक ड्रॉ सीमा समाप्त';

  @override
  String get watchAdForMore =>
      'अधिक कार्ड ड्रॉ के लिए विज्ञापन देखें। आप प्रति दिन 10 अतिरिक्त ड्रॉ तक प्राप्त कर सकते हैं।';

  @override
  String get drawAddedMessage => '1 ड्रॉ जोड़ा गया! ✨';

  @override
  String get adLoadFailed =>
      'विज्ञापन लोड करने में विफल। कृपया बाद में पुनः प्रयास करें।';

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
  String get chatCount => 'Chat count';

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
  String get startChatMessage =>
      'अपने टैरो रीडिंग के बारे में मुझसे कुछ भी पूछें';

  @override
  String get chatHistory => 'चैट इतिहास';

  @override
  String get chatHistoryDescription => 'टैरो मास्टर के साथ आपकी बातचीत';

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
}
