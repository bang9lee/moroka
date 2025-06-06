// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'Moroka';

  @override
  String get appTagline => '그림자의 신탁';

  @override
  String get appTitle => 'Moroka - 불길한 속삭임';

  @override
  String get onboardingTitle1 => '운명의 문이 열립니다';

  @override
  String get onboardingDesc1 => '고대의 지혜와 현대의 기술이 만나\n당신의 미래를 속삭입니다';

  @override
  String get onboardingTitle2 => '어둠 속의 진실';

  @override
  String get onboardingDesc2 => '타로 카드는 거짓말을 하지 않습니다\n당신이 감당할 수 있는 진실만을 보여줄 뿐';

  @override
  String get onboardingTitle3 => 'AI가 읽는 운명';

  @override
  String get onboardingDesc3 => '인공지능이 당신의 카드를 해석하고\n깊은 대화를 통해 길을 안내합니다';

  @override
  String get onboardingTitle4 => '준비되셨나요?';

  @override
  String get onboardingDesc4 => '모든 선택에는 대가가 따릅니다\n당신의 운명을 마주할 준비가 되셨다면...';

  @override
  String get loginTitle => '다시 돌아오셨군요';

  @override
  String get loginSubtitle => '당신을 기다리고 있었습니다';

  @override
  String get signupTitle => '운명의 계약';

  @override
  String get signupSubtitle => '당신의 영혼을 등록하세요';

  @override
  String get emailLabel => '이메일';

  @override
  String get passwordLabel => '비밀번호';

  @override
  String get nameLabel => '이름';

  @override
  String get loginButton => '입장하기';

  @override
  String get signupButton => '영혼 등록';

  @override
  String get googleLogin => 'Google로 로그인';

  @override
  String get googleSignup => 'Google로 시작하기';

  @override
  String get alreadyHaveAccount => '이미 계정이 있으신가요? 로그인';

  @override
  String get dontHaveAccount => '처음이신가요? 회원가입';

  @override
  String get moodQuestion => '지금 어떤 마음이신가요?';

  @override
  String get selectSpreadButton => '타로 배열법 선택';

  @override
  String get moodAnxious => '불안한';

  @override
  String get moodLonely => '외로운';

  @override
  String get moodCurious => '호기심 가득한';

  @override
  String get moodFearful => '두려운';

  @override
  String get moodHopeful => '희망적인';

  @override
  String get moodConfused => '혼란스러운';

  @override
  String get moodDesperate => '절망적인';

  @override
  String get moodExpectant => '기대하는';

  @override
  String get moodMystical => '신비로운';

  @override
  String get spreadSelectionTitle => '배열법 선택';

  @override
  String get spreadSelectionSubtitle => '현재 느끼는 감정으로 배열법을 선택하세요';

  @override
  String get spreadDifficultyBeginner => '1~3장';

  @override
  String get spreadDifficultyIntermediate => '5~7장';

  @override
  String get spreadDifficultyAdvanced => '10장';

  @override
  String get spreadOneCard => '원 카드';

  @override
  String get spreadThreeCard => '쓰리 카드';

  @override
  String get spreadCelticCross => '켈틱 크로스';

  @override
  String get spreadRelationship => '관계 스프레드';

  @override
  String get spreadYesNo => '예/아니오';

  @override
  String get selectCardTitle => '운명의 카드를 선택하세요';

  @override
  String get currentMoodLabel => '현재 당신의 기분: ';

  @override
  String get currentSpreadLabel => '선택한 배열법: ';

  @override
  String get shufflingMessage => '운명의 실이 엮이고 있습니다...';

  @override
  String get selectCardInstruction => '직감을 따라 카드를 선택하세요';

  @override
  String cardsSelected(int count) {
    return '$count장 선택됨';
  }

  @override
  String cardsRemaining(int count) {
    return '$count장 더 선택하세요';
  }

  @override
  String get todaysCard => 'Today\'s Card';

  @override
  String get threeCardSpread => 'Three Card Spread';

  @override
  String get celticCrossSpread => '켈틱 크로스 스프레드';

  @override
  String get crossSection => '십자가 - 현재 상황';

  @override
  String get staffSection => '지팡이 - 미래 전개';

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
  String get typeMessageHint => '메시지를 입력하세요...';

  @override
  String get continueReading => '더 깊은 조언 받기';

  @override
  String get watchAdPrompt => '더 깊은 심연의 목소리를 듣고 싶다면,\n잠시 다른 세계의 메시지를 확인해야 합니다.';

  @override
  String get interpretingSpread => '카드들의 메시지를 해석하고 있습니다...';

  @override
  String get menuHistory => '지난 타로 기록';

  @override
  String get menuHistoryDesc => '과거의 운명을 되돌아보세요';

  @override
  String get loadingHistory => '기록을 불러오는 중...';

  @override
  String get menuStatistics => '통계 & 분석';

  @override
  String get menuStatisticsDesc => '당신의 운명 패턴을 분석합니다';

  @override
  String get menuSettings => '설정';

  @override
  String get menuSettingsDesc => '앱 환경을 조정하세요';

  @override
  String get menuAbout => '앱 정보';

  @override
  String get menuAboutDesc => 'Moroka - 그림자의 신탁';

  @override
  String get logoutButton => '로그아웃';

  @override
  String get logoutTitle => '정말 떠나시겠습니까?';

  @override
  String get logoutMessage => '운명의 문이 닫히면\n다시 돌아와야 합니다';

  @override
  String get logoutCancel => '머무르기';

  @override
  String get logoutConfirm => '떠나기';

  @override
  String get errorOccurred => '오류가 발생했습니다';

  @override
  String get errorEmailEmpty => '이메일을 입력해주세요';

  @override
  String get errorEmailInvalid => '올바른 이메일 형식이 아닙니다';

  @override
  String get errorPasswordEmpty => '비밀번호를 입력해주세요';

  @override
  String get errorPasswordShort => '비밀번호는 6자 이상이어야 합니다';

  @override
  String get errorNameEmpty => '이름을 입력해주세요';

  @override
  String get errorLoginFailed => '로그인에 실패했습니다';

  @override
  String get errorSignupFailed => '회원가입에 실패했습니다';

  @override
  String get errorGoogleLoginFailed => 'Google 로그인에 실패했습니다';

  @override
  String get errorNetworkFailed => '네트워크 연결을 확인해주세요';

  @override
  String get errorUserDataLoad => '사용자 정보를 불러올 수 없습니다';

  @override
  String get errorUserNotFound => '등록되지 않은 이메일입니다';

  @override
  String get errorWrongPassword => '비밀번호가 올바르지 않습니다';

  @override
  String get errorUserDisabled => '비활성화된 계정입니다';

  @override
  String get errorTooManyRequests => '너무 많은 시도가 있었습니다. 잠시 후 다시 시도해주세요';

  @override
  String get errorInvalidCredential => '이메일 또는 비밀번호가 올바르지 않습니다';

  @override
  String get errorLogoutFailed => '로그아웃 중 오류가 발생했습니다';

  @override
  String get errorPasswordResetFailed => '비밀번호 재설정 이메일 발송에 실패했습니다';

  @override
  String get errorNotEnoughCards => '카드를 더 선택해주세요';

  @override
  String get successLogin => '환영합니다';

  @override
  String get successSignup => '영혼이 등록되었습니다';

  @override
  String get successLogout => '안녕히 가세요';

  @override
  String get successCardsSelected => '모든 카드가 선택되었습니다';

  @override
  String get settingsLanguageTitle => '언어';

  @override
  String get settingsLanguageLabel => '앱 언어';

  @override
  String get settingsLanguageDesc => '선호하는 언어를 선택하세요';

  @override
  String get settingsNotificationTitle => '알림 설정';

  @override
  String get settingsDailyNotification => '일일 타로 알림';

  @override
  String get settingsDailyNotificationDesc => '매일 아침 오늘의 운세를 알려드립니다';

  @override
  String get settingsWeeklyReport => '주간 타로 리포트';

  @override
  String get settingsWeeklyReportDesc => '매주 월요일 주간 운세를 알려드립니다';

  @override
  String get settingsDisplayTitle => '화면 설정';

  @override
  String get settingsVibration => '진동 효과';

  @override
  String get settingsVibrationDesc => '카드 선택 시 진동 피드백';

  @override
  String get settingsAnimations => '애니메이션 효과';

  @override
  String get settingsAnimationsDesc => '화면 전환 애니메이션';

  @override
  String get settingsDataTitle => '데이터 관리';

  @override
  String get settingsBackupData => '데이터 백업';

  @override
  String get settingsBackupDataDesc => '클라우드에 데이터를 백업합니다';

  @override
  String get settingsClearCache => '캐시 삭제';

  @override
  String get settingsClearCacheDesc => '임시 파일을 삭제하여 공간을 확보합니다';

  @override
  String get settingsDeleteData => '모든 데이터 삭제';

  @override
  String get settingsDeleteDataDesc => '모든 타로 기록과 설정을 삭제합니다';

  @override
  String get settingsAccountTitle => '계정';

  @override
  String get settingsChangePassword => '비밀번호 변경';

  @override
  String get settingsChangePasswordDesc => '계정 보안을 위해 비밀번호를 변경합니다';

  @override
  String get settingsDeleteAccount => '계정 삭제';

  @override
  String get settingsDeleteAccountDesc => '영구적으로 계정을 삭제합니다';

  @override
  String get dialogBackupTitle => '데이터 백업';

  @override
  String get dialogBackupMessage => '클라우드에 데이터를 백업하시겠습니까?';

  @override
  String get dialogClearCacheTitle => '캐시 삭제';

  @override
  String get dialogClearCacheMessage => '임시 파일을 삭제하시겠습니까?';

  @override
  String get dialogDeleteDataTitle => '모든 데이터 삭제';

  @override
  String get dialogDeleteDataMessage =>
      '모든 타로 기록과 설정이 영구적으로 삭제됩니다.\n이 작업은 되돌릴 수 없습니다.';

  @override
  String get dialogChangePasswordTitle => '비밀번호 변경';

  @override
  String get dialogDeleteAccountTitle => '계정 삭제';

  @override
  String get dialogDeleteAccountMessage =>
      '계정을 삭제하면 모든 데이터가 영구적으로 삭제됩니다.\n이 작업은 되돌릴 수 없습니다.';

  @override
  String get currentPassword => '현재 비밀번호';

  @override
  String get newPassword => '새 비밀번호';

  @override
  String get confirmNewPassword => '새 비밀번호 확인';

  @override
  String get cancel => '취소';

  @override
  String get backup => '백업';

  @override
  String get delete => '삭제';

  @override
  String get change => '변경';

  @override
  String get successBackup => '백업이 완료되었습니다';

  @override
  String get successClearCache => '캐시가 삭제되었습니다';

  @override
  String get successDeleteData => '모든 데이터가 삭제되었습니다';

  @override
  String get successChangePassword => '비밀번호가 변경되었습니다';

  @override
  String get successDeleteAccount => '계정이 삭제되었습니다';

  @override
  String errorBackup(String error) {
    return '백업 실패: $error';
  }

  @override
  String errorDeleteData(String error) {
    return '데이터 삭제 실패: $error';
  }

  @override
  String errorChangePassword(String error) {
    return '비밀번호 변경 실패: $error';
  }

  @override
  String errorDeleteAccount(String error) {
    return '계정 삭제 실패: $error';
  }

  @override
  String get errorPasswordMismatch => '새 비밀번호가 일치하지 않습니다';

  @override
  String get passwordResetTitle => '비밀번호 재설정';

  @override
  String get passwordResetMessage =>
      '가입하신 이메일 주소를 입력해주세요.\n비밀번호 재설정 링크를 보내드립니다.';

  @override
  String get passwordResetSuccess => '비밀번호 재설정 이메일을 발송했습니다';

  @override
  String get send => '전송';

  @override
  String get emailPlaceholder => 'your@email.com';

  @override
  String get passwordPlaceholder => '6자 이상 입력';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get login => '로그인';

  @override
  String get or => '또는';

  @override
  String get continueWithGoogle => 'Google로 계속하기';

  @override
  String get noAccount => '계정이 없으신가요?';

  @override
  String get signUp => '회원가입';

  @override
  String get appBrandName => 'MOROKA';

  @override
  String get appBrandTagline => 'oracle of shadows';

  @override
  String get aboutTitle => '앱 정보';

  @override
  String get aboutSubtitle => '운명의 카드가 당신을 기다립니다';

  @override
  String get aboutTagline => '운명의 카드가 당신을 기다립니다';

  @override
  String get aboutDescription =>
      'MOROKA는 고대의 신비로운 타로 카드를 통해 당신의 운명을 읽어드립니다. 78장의 카드 하나하나에 담긴 우주의 메시지를 AI 타로 마스터가 해석해 드립니다.\n\n어둠 속에서 빛나는 진실, 그리고 당신만을 위한 특별한 메시지를 만나보세요.';

  @override
  String get featuresTitle => '주요 기능';

  @override
  String get feature78Cards => '78장의 전통 타로 카드';

  @override
  String get feature78CardsDesc => '메이저 아르카나 22장과 마이너 아르카나 56장의 완전한 덱';

  @override
  String get feature5Spreads => '5가지 전문 배열법';

  @override
  String get feature5SpreadsDesc => '원카드부터 켈틱 크로스까지 다양한 리딩 방법 제공';

  @override
  String get featureAI => 'AI 타로 마스터';

  @override
  String get featureAIDesc => '100년 경력의 타로 마스터처럼 깊이 있는 해석 제공';

  @override
  String get featureChat => '대화형 상담';

  @override
  String get featureChatDesc => '카드에 대해 궁금한 점을 자유롭게 질문하세요';

  @override
  String get termsAndPolicies => '약관 및 정책';

  @override
  String get termsOfService => '서비스 이용약관';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get marketingConsent => '마케팅 정보 수신';

  @override
  String get customerSupport => '고객 지원';

  @override
  String get emailSupport => '이메일 문의';

  @override
  String get website => '웹사이트';

  @override
  String cannotOpenUrl(String url) {
    return 'URL을 열 수 없습니다: $url';
  }

  @override
  String get lastModified => '최종 수정일: 2025년 7월 3일';

  @override
  String get confirm => '확인';

  @override
  String get companyName => 'Today`s Studio';

  @override
  String get companyTagline => 'Creating mystical experiences';

  @override
  String get copyright => '© 2025 Today`s Studio. All rights reserved.';

  @override
  String get anonymousSoul => '이름 없는 영혼';

  @override
  String get totalReadings => '전체 리딩';

  @override
  String get joinDate => '가입일';

  @override
  String get errorLogout => '로그아웃 중 오류가 발생했습니다';

  @override
  String get soulContract => '영혼의 계약';

  @override
  String get termsAgreementMessage => '서비스 이용을 위해 약관에 동의해주세요';

  @override
  String get agreeAll => '전체 동의';

  @override
  String get required => '필수';

  @override
  String get optional => '선택';

  @override
  String get agreeAndStart => '동의하고 시작하기';

  @override
  String get agreeToRequired => '필수 약관에 동의해주세요';

  @override
  String get nickname => '닉네임';

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get nextStep => '다음 단계';

  @override
  String get errorNameTooShort => '이름은 2자 이상이어야 합니다';

  @override
  String get errorConfirmPassword => '비밀번호를 다시 입력해주세요';

  @override
  String get errorPasswordsDontMatch => '비밀번호가 일치하지 않습니다';

  @override
  String get emailInUse => '이미 사용 중인 이메일입니다';

  @override
  String get emailAvailable => '사용 가능한 이메일입니다';

  @override
  String get nicknameInUse => '이미 사용 중인 닉네임입니다';

  @override
  String get nicknameAvailable => '사용 가능한 닉네임입니다';

  @override
  String get passwordWeak => '약함';

  @override
  String get passwordFair => '보통';

  @override
  String get passwordStrong => '강함';

  @override
  String get passwordVeryStrong => '매우 강함';

  @override
  String get emailVerificationTitle => '이메일 인증';

  @override
  String emailVerificationMessage(String email) {
    return '$email로 인증 메일을 발송했습니다.\n이메일을 확인하고 인증 링크를 클릭해주세요.';
  }

  @override
  String get resendEmail => '이메일 재발송';

  @override
  String get emailResent => '인증 이메일이 재발송되었습니다';

  @override
  String get checkEmailAndReturn => '인증 후 앱으로 돌아와주세요';

  @override
  String get noHistoryTitle => '아직 타로 기록이 없습니다';

  @override
  String get noHistoryMessage => '첫 번째 운명을 읽어보세요';

  @override
  String get startReading => '타로 읽기 시작';

  @override
  String get deleteReadingTitle => '기록을 삭제하시겠습니까?';

  @override
  String get deleteReadingMessage => '삭제된 기록은 복구할 수 없습니다';

  @override
  String get deleteAll => '전체 삭제';

  @override
  String get deleteAllConfirmTitle => '모든 기록을 삭제하시겠습니까?';

  @override
  String get deleteAllConfirmMessage =>
      '모든 타로 리딩 기록이 영구적으로 삭제됩니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get deleteAllButton => '전체 삭제';

  @override
  String get totalTarotReadings => '총 타로 리딩';

  @override
  String get mostFrequentCard => '가장 많이 나온 카드';

  @override
  String get cardFrequencyTop5 => '카드 출현 빈도 TOP 5';

  @override
  String get moodAnalysis => '기분별 리딩 분석';

  @override
  String get monthlyReadingTrend => '월별 리딩 추이';

  @override
  String get noData => '데이터가 없습니다';

  @override
  String get noDataToAnalyze => '아직 분석할 데이터가 없습니다';

  @override
  String get startTarotReading => '타로 리딩을 시작해보세요';

  @override
  String get cardOfFate => '운명의 카드';

  @override
  String get cardCallingYou => '이 카드가 당신을 부르고 있습니다';

  @override
  String get selectThisCard => '선택하시겠습니까?';

  @override
  String get viewAgain => '다시 보기';

  @override
  String get select => '선택';

  @override
  String get shufflingCards => '운명의 카드를 섞고 있습니다...';

  @override
  String get selectCardsIntuition => '마음이 끌리는 카드를 선택하세요';

  @override
  String selectMoreCards(int count) {
    return '$count장 더 선택';
  }

  @override
  String get selectionComplete => '선택 완료!';

  @override
  String get tapToSelect => '탭하여 선택';

  @override
  String get preparingInterpretation => '해석을 준비하는 중입니다...';

  @override
  String get cardMessage => '카드의 메시지';

  @override
  String get cardsStory => '카드들이 그리는 이야기';

  @override
  String get specialInterpretation => '당신을 위한 특별한 해석';

  @override
  String get interpretingCards => '카드의 의미를 해석하는 중...';

  @override
  String get todaysChatEnded => '오늘의 대화가 모두 끝났습니다';

  @override
  String get askQuestions => '궁금한 것을 물어보세요...';

  @override
  String get continueConversation => '대화 계속하기';

  @override
  String get wantDeeperTruth => '더 깊은 진실을 원하시나요?';

  @override
  String get watchAdToContinue => '광고를 시청하고 \n타로 마스터와 대화를 이어가세요';

  @override
  String get later => '다음에';

  @override
  String get watchAd => '광고 시청';

  @override
  String get emailVerification => '이메일 인증';

  @override
  String get checkYourEmail => '이메일을 확인해주세요';

  @override
  String get verificationEmailSent =>
      '위 이메일 주소로 인증 메일을 발송했습니다.\n메일함을 확인하고 인증 링크를 클릭해주세요.';

  @override
  String get verifyingEmail => '인증 확인 중...';

  @override
  String get noEmailReceived => '메일이 오지 않나요?';

  @override
  String get checkSpamFolder => '스팸 메일함을 확인해보세요.\n그래도 없다면 아래 버튼을 눌러 다시 보내세요.';

  @override
  String resendIn(int seconds) {
    return '다시 보내기 ($seconds초)';
  }

  @override
  String get resendVerificationEmail => '인증 메일 다시 보내기';

  @override
  String get alreadyVerified => '이미 인증했어요';

  @override
  String get openGateOfFate => '운명의 문을 열다';

  @override
  String get skip => '건너뛰기';

  @override
  String get languageChanged => '언어가 성공적으로 변경되었습니다';

  @override
  String get notificationsEnabled => '알림이 활성화되었습니다';

  @override
  String get notificationsDisabled => '알림이 비활성화되었습니다';

  @override
  String get vibrationEnabled => '진동이 활성화되었습니다';

  @override
  String get vibrationDisabled => '진동이 비활성화되었습니다';

  @override
  String get animationsEnabled => '애니메이션이 활성화되었습니다';

  @override
  String get animationsDisabled => '애니메이션이 비활성화되었습니다';

  @override
  String get notificationPermissionDenied => '알림 권한이 필요합니다';

  @override
  String get errorWeakPassword => '비밀번호가 너무 약합니다';

  @override
  String get moreTitle => '더보기';

  @override
  String get willYouSelectIt => '선택하시겠습니까?';

  @override
  String get selectCardByHeart => '마음이 끌리는 카드를 선택하세요';

  @override
  String moreToSelect(int count) {
    return '$count장 더 선택';
  }

  @override
  String get tapToSelectCard => '카드를 탭하여 선택하세요';

  @override
  String get currentSituation => '현재 상황';

  @override
  String get practicalAdvice => '실천 조언';

  @override
  String get futureForecast => '앞으로의 전망';

  @override
  String get overallFlow => '전체 흐름';

  @override
  String get timeBasedInterpretation => '시간대별 해석';

  @override
  String get pastInfluence => '과거의 영향';

  @override
  String get upcomingFuture => '다가올 미래';

  @override
  String get actionGuidelines => '행동 지침';

  @override
  String get coreAdvice => '핵심 조언';

  @override
  String get coreSituationAnalysis => '핵심 상황 분석';

  @override
  String get innerConflict => '내면의 갈등';

  @override
  String get timelineAnalysis => '시간축 분석';

  @override
  String get externalFactors => '외부 요인';

  @override
  String get finalForecast => '최종 전망';

  @override
  String get stepByStepPlan => '단계별 실천 계획';

  @override
  String get twoPersonEnergy => '두 사람의 에너지';

  @override
  String get heartTemperatureDifference => '마음의 온도차';

  @override
  String get relationshipObstacles => '관계의 걸림돌';

  @override
  String get futurePossibility => '미래 가능성';

  @override
  String get adviceForLove => '사랑을 위한 조언';

  @override
  String get oneLineAdvice => '한 줄 조언';

  @override
  String get judgmentBasis => '판단 근거';

  @override
  String get coreMessage => '핵심 메시지';

  @override
  String get successConditions => '성공 조건';

  @override
  String get timingPrediction => '시기 예측';

  @override
  String get actionGuide => '행동 가이드';

  @override
  String get future => '미래';

  @override
  String get advice => '조언';

  @override
  String get message => '메시지';

  @override
  String get meaning => '의미';

  @override
  String get interpretation => '해석';

  @override
  String get overallMeaning => '전체적인 의미';

  @override
  String get comprehensiveInterpretation => '종합 해석';

  @override
  String get futureAdvice => '앞으로의 조언';

  @override
  String get yes => '예';

  @override
  String get no => '아니오';

  @override
  String get conditionalYes => '조건부 예';

  @override
  String get analyzingDestiny => '운명을 분석하는 중...';

  @override
  String timesCount(int count) {
    return '$count회';
  }

  @override
  String monthLabel(String month) {
    return '$month월';
  }

  @override
  String get remainingDraws => '남은 횟수';

  @override
  String get noDrawsRemaining => '남은 횟수가 없습니다';

  @override
  String get adDraws => '광고';

  @override
  String get dailyLimitReached => '일일 뽑기 한도 도달';

  @override
  String get watchAdForMore =>
      '광고를 시청하여 카드 뽑기 횟수를 추가하세요. 하루에 최대 10회까지 추가할 수 있습니다.';

  @override
  String get drawAddedMessage => '뽑기 1회가 추가되었습니다! ✨';

  @override
  String get adLoadFailed => '광고를 불러오지 못했습니다. 나중에 다시 시도해주세요.';

  @override
  String get openMenu => '메뉴 열기';

  @override
  String get currentlySelected => '현재 선택됨';

  @override
  String get proceedToSpreadSelection => '스프레드 선택으로 진행';

  @override
  String get selectMoodFirst => '먼저 기분을 선택해주세요';

  @override
  String get currentUser => '현재 사용자';

  @override
  String get goBack => '뒤로 가기';

  @override
  String get cancelCardSelection => '카드 선택 취소';

  @override
  String get confirmCardSelection => '카드 선택 확인';

  @override
  String get cards => '장';

  @override
  String get tapToSelectSpread => '탭하여 이 스프레드 선택';

  @override
  String get close => '닫기';

  @override
  String get back => '뒤로';

  @override
  String get selectedCardsLayout => '선택된 카드 레이아웃';

  @override
  String get yourQuestion => '당신의 질문';

  @override
  String get tarotMaster => '타로 마스터';

  @override
  String get question => '질문';

  @override
  String get tarotMasterResponse => '타로 마스터의 답변';

  @override
  String get chatInputField => '채팅 입력란';

  @override
  String get sendMessage => '메시지 보내기';

  @override
  String get date => '날짜';

  @override
  String get card => '카드';

  @override
  String chatCount(int count) {
    return '대화 $count회';
  }

  @override
  String get deleteReading => '기록 삭제';

  @override
  String get deleteReadingDescription => '이 타로 리딩을 영구적으로 삭제합니다';

  @override
  String get on => '켜짐';

  @override
  String get off => '꺼짐';

  @override
  String get cardShowingNewPerspective => '카드가 새로운 관점을 보여주고 있습니다.';

  @override
  String get moodIsSignOfChange => '기분은 변화의 신호입니다.';

  @override
  String get nowIsTurningPoint => '지금이 전환점입니다.';

  @override
  String get tryDifferentChoiceToday => '오늘은 다른 선택을 해보세요';

  @override
  String get talkWithSomeoneSpecial => '특별한 사람과 대화를 나누세요';

  @override
  String get setSmallGoalAndStart => '작은 목표를 정하고 시작하세요';

  @override
  String get positiveChangeInWeeks => '2-3주 내에 긍정적인 변화를 느끼실 겁니다.';

  @override
  String get flowFromPastToFuture => '과거에서 현재, 미래로 이어지는 흐름이 보입니다.';

  @override
  String get lessonsFromPast => '과거 경험의 교훈';

  @override
  String get upcomingPossibilities => '다가올 가능성들';

  @override
  String get acceptPastFocusPresentPrepareFuture =>
      '과거를 받아들이고, 현재에 집중하며, 미래를 준비하세요.';

  @override
  String get mostImportantIsCurrentChoice => '상태에서 가장 중요한 것은 지금의 선택입니다.';

  @override
  String get finalAnswer => '최종 답변';

  @override
  String get positiveSignals => '긍정적 신호';

  @override
  String get cautionSignals => '주의 신호';

  @override
  String get cardHoldsImportantKey => '카드가 중요한 열쇠를 가지고 있습니다.';

  @override
  String get needCarefulPreparationAndTiming => '신중한 준비와 적절한 타이밍이 필요합니다.';

  @override
  String get oneToTwoWeeks => '1-2주';

  @override
  String get oneToTwoMonths => '1-2개월';

  @override
  String get checkResults => '결과를 확인하세요';

  @override
  String get doBestRegardlessOfResult => '결과에 상관없이 최선을 다해 준비하세요.';

  @override
  String get you => '당신';

  @override
  String get partner => '상대방';

  @override
  String get importantRoleInRelationship => '관계에서 중요한 역할';

  @override
  String get partnersCurrentState => '상대방의 현재 상태';

  @override
  String get temperatureDifferenceButUnderstandable =>
      '마음의 온도차가 있지만 이해할 수 있는 범위입니다.';

  @override
  String get showingChallenges => '가 앞으로의 도전을 보여주고 있습니다.';

  @override
  String get possibilityWithEffort => '노력하면 60% 이상의 발전 가능성이 있습니다.';

  @override
  String get needConversationUnderstandingTime => '대화와 이해, 그리고 시간이 필요합니다.';

  @override
  String get loveIsMirrorReflectingEachOther => '사랑은 서로를 비추는 거울과 같습니다.';

  @override
  String get cardsShowingComplexSituation => '장의 카드가 복잡한 상황을 보여주고 있습니다.';

  @override
  String get conflictBetweenConsciousUnconscious => '의식과 무의식 사이의 갈등이 있습니다.';

  @override
  String get pastInfluenceContinuesToPresent => '과거의 영향이 현재까지 이어지고 있습니다.';

  @override
  String get surroundingEnvironmentImportant => '주변 환경이 중요한 영향을 미치고 있습니다.';

  @override
  String get positiveChangePossibility70Percent =>
      'There\'s about 70% possibility of positive change.';

  @override
  String get thisWeek => '이번 주';

  @override
  String get thisMonth => '이번 달';

  @override
  String get threeMonthsLater => '3개월 후';

  @override
  String get organizeSituation => '상황을 정리하세요';

  @override
  String get startConcreteAction => '구체적인 행동을 시작하세요';

  @override
  String get youHavePowerToOvercome => '당신에게는 현재 상태를 극복할 힘이 내재되어 있습니다.';

  @override
  String get when => '언제';

  @override
  String get timing => '타이밍';

  @override
  String get how => '어떻게';

  @override
  String get method => '방법';

  @override
  String get why => '왜';

  @override
  String get reason => '이유';

  @override
  String tarotTimingAnswer(String cardName) {
    return '타로는 보통 1-3개월 사이의 타이밍을 보여줍니다. $cardName 카드의 에너지를 보면 더 빠를 수도 있어요. 가장 좋은 때는 당신이 준비되었을 때입니다.';
  }

  @override
  String tarotMethodAnswer(String cardName) {
    return '$cardName 카드는 직감을 따르라고 말합니다. 너무 생각하지 말고 마음을 따라 한 걸음씩 나아가세요. 작은 시작이 큰 변화를 만듭니다.';
  }

  @override
  String tarotReasonAnswer(String cardName) {
    return '그 이유는 $cardName 카드가 시사하듯, 지금이 변화의 때이기 때문입니다. 과거의 패턴에서 벗어나 새로운 가능성을 열 시기가 왔습니다.';
  }

  @override
  String tarotGeneralAnswer(String cardName) {
    return '좋은 질문이네요. $cardName 카드의 관점에서 보면, 지금은 신중하면서도 용기 있게 나아갈 때입니다. 어떤 부분이 가장 궁금하신가요?';
  }

  @override
  String get startChatMessage => '타로 리딩에 대해 궁금한 점을 물어보세요';

  @override
  String get chatHistory => '대화 기록';

  @override
  String get chatHistoryDescription => '타로 마스터와의 대화';

  @override
  String get past => '과거';

  @override
  String get present => '현재';

  @override
  String get positiveChangePossibility => '긍정적 변화 가능성';

  @override
  String get futureOutlook => '앞으로의 전망';

  @override
  String get free => '무료';

  @override
  String get paid => '유료';

  @override
  String get oneCardDescription => '오늘의 운세와 조언';

  @override
  String get threeCardDescription => '과거, 현재, 미래의 흐름';

  @override
  String get celticCrossDescription => '상황의 모든 측면을 분석';

  @override
  String get relationshipDescription => '관계의 역학과 미래';

  @override
  String get yesNoDescription => '명확한 답을 위한 점술';

  @override
  String get errorApiMessage => '죄송합니다. 운명의 실이 잠시 엉켜버렸네요. 다시 시도해 주세요.';

  @override
  String defaultInterpretationStart(String spreadName) {
    return '$spreadName 배열이 펼쳐졌습니다.';
  }

  @override
  String selectedCardsLabel(String cards) {
    return '선택하신 카드들: $cards';
  }

  @override
  String cardEnergyResonance(String mood) {
    return '이 카드들이 만들어내는 에너지가 당신의 $mood 마음과 공명하고 있습니다.';
  }

  @override
  String get deeperInterpretationComing =>
      '각 카드가 전하는 메시지들이 서로 연결되어 더 큰 그림을 그리고 있네요.\n\n잠시 후 더 깊은 해석을 전해드리겠습니다...';

  @override
  String get waitingMessage => '기다리는 중...';

  @override
  String get nameAvailable => '사용 가능한 이름입니다';

  @override
  String get nameAlreadyTaken => '이미 사용 중인 이름입니다';

  @override
  String get errorNameCheckFailed => '이름 확인 중 오류가 발생했습니다';

  @override
  String get emailAlreadyRegistered => '이미 가입된 이메일입니다';

  @override
  String get errorEmailCheckFailed => '이메일 확인 중 오류가 발생했습니다';

  @override
  String get messageRequired => '메시지를 입력해주세요';

  @override
  String get messageTooLong => '메시지는 500자 이내로 입력해주세요';

  @override
  String get messageInvalidCharacters => '허용되지 않은 문자가 포함되어 있습니다';

  @override
  String get messageInvalidScript => '허용되지 않은 스크립트가 포함되어 있습니다';

  @override
  String get passwordRequired => '비밀번호를 입력해주세요';

  @override
  String get passwordStrengthWeak => '약함';

  @override
  String get passwordStrengthMedium => '보통';

  @override
  String get passwordStrengthStrong => '강함';

  @override
  String get error => '오류';

  @override
  String get ok => '확인';

  @override
  String get errorInvalidFormat => '잘못된 형식';

  @override
  String get errorUnexpected => '예기치 않은 오류가 발생했습니다';

  @override
  String get errorUnknown => '알 수 없는 오류가 발생했습니다';

  @override
  String get errorNetworkTimeout => '네트워크 연결 시간이 초과되었습니다';

  @override
  String get errorNoInternet => '인터넷 연결 없음';

  @override
  String get errorServerError => '서버 오류가 발생했습니다';

  @override
  String get errorInvalidCredentials => '잘못된 이메일 또는 비밀번호';

  @override
  String get errorEmailNotVerified => '이메일이 인증되지 않았습니다';

  @override
  String get errorSessionExpired => '세션이 만료되었습니다. 다시 로그인해주세요';

  @override
  String get errorQuotaExceeded => '일일 한도를 초과했습니다';

  @override
  String get errorInvalidResponse => '서버로부터 잘못된 응답을 받았습니다';

  @override
  String get errorRateLimitExceeded => '요청이 너무 많습니다. 나중에 다시 시도해주세요';

  @override
  String get errorDataNotFound => '데이터를 찾을 수 없습니다';

  @override
  String get errorDataCorrupted => '데이터가 손상되었습니다';

  @override
  String get errorSaveFailed => '데이터 저장에 실패했습니다';

  @override
  String get errorPermissionDenied => '권한이 거부되었습니다';

  @override
  String get errorPermissionRestricted => '접근이 제한되었습니다';

  @override
  String get errorEmailAlreadyInUse => '이미 사용 중인 이메일입니다';

  @override
  String get errorInvalidEmail => '잘못된 이메일 주소';

  @override
  String get errorNetworkRequestFailed => '네트워크 요청에 실패했습니다';

  @override
  String get errorOperationNotAllowed => '허용되지 않는 작업입니다';

  @override
  String get errorAuthFailed => '인증에 실패했습니다';

  @override
  String get logoutSuccess => '성공적으로 로그아웃되었습니다';

  @override
  String get deleteAccountSuccess => '계정이 성공적으로 삭제되었습니다';

  @override
  String get generalSettings => '일반 설정';

  @override
  String get accountSettings => '계정 설정';

  @override
  String get languageTitle => '언어';

  @override
  String get notificationsTitle => '알림';

  @override
  String get vibrationTitle => '햅틱 피드백';

  @override
  String get vibrationSubtitle => '진동 피드백 활성화';

  @override
  String get animationsTitle => '애니메이션';

  @override
  String get animationsSubtitle => 'UI 애니메이션 활성화';

  @override
  String get dailyTarotReminder => '매일 타로 알림 받기';

  @override
  String get deleteAccountConfirmMessage =>
      '이 작업은 되돌릴 수 없습니다. 모든 데이터가 영구적으로 삭제됩니다.';

  @override
  String get selectedCards => '선택된 카드';

  @override
  String get aiInterpretation => 'AI 해석';

  @override
  String get invalidEmotionInput => '유효하지 않은 감정 입력입니다.';

  @override
  String get interpretationNotReceived => '해석 결과를 받지 못했습니다.';

  @override
  String get responseGenerationFailed => '응답을 생성하지 못했습니다.';

  @override
  String get invalidEmailFormat => '유효하지 않은 이메일 형식입니다.';

  @override
  String get weakPassword =>
      '비밀번호가 너무 약합니다. 대소문자, 숫자, 특수문자를 포함해 8자 이상으로 설정해주세요.';

  @override
  String get invalidUsername => '사용자 이름은 3-20자의 영문, 숫자, 언더스코어만 사용 가능합니다.';

  @override
  String get signupError => '회원가입 중 오류가 발생했습니다.';

  @override
  String get loginError => '로그인 중 오류가 발생했습니다.';

  @override
  String get logoutError => '로그아웃 중 오류가 발생했습니다.';

  @override
  String get passwordResetEmailFailed => '비밀번호 재설정 이메일 발송에 실패했습니다.';

  @override
  String get profileCreationFailed => '사용자 프로필 생성에 실패했습니다.';

  @override
  String get noLoggedInUser => '로그인된 사용자가 없습니다.';

  @override
  String get profileUpdateFailed => '프로필 업데이트에 실패했습니다.';

  @override
  String cardInterpretationFailed(String error) {
    return '카드 해석을 가져오는데 실패했습니다: $error';
  }

  @override
  String get emailAlreadyInUse => '이미 사용 중인 이메일입니다.';

  @override
  String signupErrorWithMessage(String message) {
    return '회원가입 중 오류가 발생했습니다: $message';
  }

  @override
  String get tooManyRequests => '너무 많은 요청이 있었습니다. 잠시 후 다시 시도해주세요.';

  @override
  String get verificationEmailError => '인증 메일 발송 중 오류가 발생했습니다.';
}
