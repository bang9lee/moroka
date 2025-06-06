// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Moroka';

  @override
  String get appTagline => '暗影神谕';

  @override
  String get appTitle => 'Moroka - 不祥的低语';

  @override
  String get onboardingTitle1 => '命运之门开启';

  @override
  String get onboardingDesc1 => '古老的智慧与现代科技相遇\n向您低语未来';

  @override
  String get onboardingTitle2 => '黑暗中的真相';

  @override
  String get onboardingDesc2 => '塔罗牌从不撒谎\n它们只展现您能承受的真相';

  @override
  String get onboardingTitle3 => 'AI解读命运';

  @override
  String get onboardingDesc3 => '人工智能解释您的牌阵\n通过深入对话引导您的道路';

  @override
  String get onboardingTitle4 => '您准备好了吗？';

  @override
  String get onboardingDesc4 => '每个选择都有其代价\n如果您准备好面对自己的命运...';

  @override
  String get loginTitle => '您回来了';

  @override
  String get loginSubtitle => '我们一直在等您';

  @override
  String get signupTitle => '命运契约';

  @override
  String get signupSubtitle => '注册您的灵魂';

  @override
  String get emailLabel => '电子邮件';

  @override
  String get passwordLabel => '密码';

  @override
  String get nameLabel => '姓名';

  @override
  String get loginButton => '进入';

  @override
  String get signupButton => '灵魂注册';

  @override
  String get googleLogin => '使用Google登录';

  @override
  String get googleSignup => '使用Google开始';

  @override
  String get alreadyHaveAccount => '已有账户？登录';

  @override
  String get dontHaveAccount => '第一次来？注册';

  @override
  String get moodQuestion => '您现在感觉如何？';

  @override
  String get selectSpreadButton => '选择塔罗牌阵';

  @override
  String get moodAnxious => '焦虑';

  @override
  String get moodLonely => '孤独';

  @override
  String get moodCurious => '好奇';

  @override
  String get moodFearful => '恐惧';

  @override
  String get moodHopeful => '充满希望';

  @override
  String get moodConfused => '困惑';

  @override
  String get moodDesperate => '绝望';

  @override
  String get moodExpectant => '期待';

  @override
  String get moodMystical => '神秘';

  @override
  String get spreadSelectionTitle => '选择牌阵';

  @override
  String get spreadSelectionSubtitle => '根据您当前的感受选择牌阵';

  @override
  String get spreadDifficultyBeginner => '1-3张牌';

  @override
  String get spreadDifficultyIntermediate => '5-7张牌';

  @override
  String get spreadDifficultyAdvanced => '10张牌';

  @override
  String get spreadOneCard => '单张牌';

  @override
  String get spreadThreeCard => '三张牌';

  @override
  String get spreadCelticCross => '凯尔特十字';

  @override
  String get spreadRelationship => '关系牌阵';

  @override
  String get spreadYesNo => '是/否';

  @override
  String get selectCardTitle => '选择命运之牌';

  @override
  String get currentMoodLabel => '您当前的心情：';

  @override
  String get currentSpreadLabel => '已选牌阵：';

  @override
  String get shufflingMessage => '命运之线正在交织...';

  @override
  String get selectCardInstruction => '跟随您的直觉选择牌';

  @override
  String cardsSelected(int count) {
    return '已选$count张';
  }

  @override
  String cardsRemaining(int count) {
    return '再选$count张';
  }

  @override
  String get todaysCard => 'Today\'s Card';

  @override
  String get threeCardSpread => 'Three Card Spread';

  @override
  String get celticCrossSpread => '凯尔特十字牌阵';

  @override
  String get crossSection => '十字 - 当前情况';

  @override
  String get staffSection => '权杖 - 未来发展';

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
  String get typeMessageHint => '输入消息...';

  @override
  String get continueReading => '获得更深层的建议';

  @override
  String get watchAdPrompt => '要聆听来自更深渊的声音，\n您必须查看来自另一个世界的讯息。';

  @override
  String get interpretingSpread => '正在解读牌面的讯息...';

  @override
  String get menuHistory => '过往塔罗记录';

  @override
  String get menuHistoryDesc => '回顾您过去的命运';

  @override
  String get loadingHistory => '正在加载历史记录...';

  @override
  String get menuStatistics => '统计与分析';

  @override
  String get menuStatisticsDesc => '分析您的命运模式';

  @override
  String get menuSettings => '设置';

  @override
  String get menuSettingsDesc => '调整应用环境';

  @override
  String get menuAbout => '关于';

  @override
  String get menuAboutDesc => 'Moroka - 暗影神谕';

  @override
  String get logoutButton => '退出登录';

  @override
  String get logoutTitle => '您真的要离开吗？';

  @override
  String get logoutMessage => '当命运之门关闭\n您必须再次归来';

  @override
  String get logoutCancel => '留下';

  @override
  String get logoutConfirm => '离开';

  @override
  String get errorOccurred => '发生错误';

  @override
  String get errorEmailEmpty => '请输入您的电子邮件';

  @override
  String get errorEmailInvalid => '无效的电子邮件格式';

  @override
  String get errorPasswordEmpty => '请输入您的密码';

  @override
  String get errorPasswordShort => '密码必须至少6个字符';

  @override
  String get errorNameEmpty => '请输入您的姓名';

  @override
  String get errorLoginFailed => '登录失败';

  @override
  String get errorSignupFailed => '注册失败';

  @override
  String get errorGoogleLoginFailed => 'Google登录失败';

  @override
  String get errorNetworkFailed => '请检查您的网络连接';

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
  String get errorNotEnoughCards => '请选择更多牌';

  @override
  String get successLogin => '欢迎';

  @override
  String get successSignup => '您的灵魂已注册';

  @override
  String get successLogout => '再见';

  @override
  String get successCardsSelected => '所有牌已选择完毕';

  @override
  String get settingsLanguageTitle => '语言设置';

  @override
  String get settingsLanguageLabel => '应用语言';

  @override
  String get settingsLanguageDesc => '选择您偏好的语言';

  @override
  String get settingsNotificationTitle => '通知设置';

  @override
  String get settingsDailyNotification => '每日塔罗提醒';

  @override
  String get settingsDailyNotificationDesc => '每天早晨收到您的日运';

  @override
  String get settingsWeeklyReport => '每周塔罗报告';

  @override
  String get settingsWeeklyReportDesc => '每周一收到您的周运';

  @override
  String get settingsDisplayTitle => '显示设置';

  @override
  String get settingsVibration => '震动效果';

  @override
  String get settingsVibrationDesc => '选牌时的震动反馈';

  @override
  String get settingsAnimations => '动画效果';

  @override
  String get settingsAnimationsDesc => '画面转场动画';

  @override
  String get settingsDataTitle => '数据管理';

  @override
  String get settingsBackupData => '数据备份';

  @override
  String get settingsBackupDataDesc => '将您的数据备份至云端';

  @override
  String get settingsClearCache => '清除缓存';

  @override
  String get settingsClearCacheDesc => '删除临时文件以释放空间';

  @override
  String get settingsDeleteData => '删除所有数据';

  @override
  String get settingsDeleteDataDesc => '删除所有塔罗记录和设置';

  @override
  String get settingsAccountTitle => '账户';

  @override
  String get settingsChangePassword => '更改密码';

  @override
  String get settingsChangePasswordDesc => '为账户安全更改您的密码';

  @override
  String get settingsDeleteAccount => '删除账户';

  @override
  String get settingsDeleteAccountDesc => '永久删除您的账户';

  @override
  String get dialogBackupTitle => '数据备份';

  @override
  String get dialogBackupMessage => '要将您的数据备份至云端吗？';

  @override
  String get dialogClearCacheTitle => '清除缓存';

  @override
  String get dialogClearCacheMessage => '要删除临时文件吗？';

  @override
  String get dialogDeleteDataTitle => '删除所有数据';

  @override
  String get dialogDeleteDataMessage => '所有塔罗记录和设置将被永久删除。\n此操作无法撤销。';

  @override
  String get dialogChangePasswordTitle => '更改密码';

  @override
  String get dialogDeleteAccountTitle => '删除账户';

  @override
  String get dialogDeleteAccountMessage => '删除账户将永久删除所有数据。\n此操作无法撤销。';

  @override
  String get currentPassword => '当前密码';

  @override
  String get newPassword => '新密码';

  @override
  String get confirmNewPassword => '确认新密码';

  @override
  String get cancel => '取消';

  @override
  String get backup => '备份';

  @override
  String get delete => '删除';

  @override
  String get change => '更改';

  @override
  String get successBackup => '备份完成';

  @override
  String get successClearCache => '缓存已清除';

  @override
  String get successDeleteData => '所有数据已删除';

  @override
  String get successChangePassword => '密码已更改';

  @override
  String get successDeleteAccount => '账户已删除';

  @override
  String errorBackup(String error) {
    return '备份失败：$error';
  }

  @override
  String errorDeleteData(String error) {
    return '删除失败：$error';
  }

  @override
  String errorChangePassword(String error) {
    return '密码更改失败：$error';
  }

  @override
  String errorDeleteAccount(String error) {
    return '账户删除失败：$error';
  }

  @override
  String get errorPasswordMismatch => '新密码不匹配';

  @override
  String get passwordResetTitle => '重置密码';

  @override
  String get passwordResetMessage => '请输入您注册的邮箱地址。\n我们将为您发送密码重置链接。';

  @override
  String get passwordResetSuccess => '密码重置邮件已发送';

  @override
  String get send => '发送';

  @override
  String get emailPlaceholder => 'your@email.com';

  @override
  String get passwordPlaceholder => '6位以上字符';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get login => '登录';

  @override
  String get or => '或';

  @override
  String get continueWithGoogle => '使用Google继续';

  @override
  String get noAccount => '没有账户？';

  @override
  String get signUp => '注册';

  @override
  String get appBrandName => 'MOROKA';

  @override
  String get appBrandTagline => 'oracle of shadows';

  @override
  String get aboutTitle => '关于';

  @override
  String get aboutSubtitle => '命运之牌等待着你';

  @override
  String get aboutTagline => '命运之牌在等待着你';

  @override
  String get aboutDescription =>
      'MOROKA\n\n命运之门已开启\n暗影神谕将解读你的未来\n\n传统塔罗解读与神秘AI结合\n提供深度洞察与智慧';

  @override
  String get featuresTitle => '主要功能';

  @override
  String get feature78Cards => '78张传统塔罗牌';

  @override
  String get feature78CardsDesc => '完整牌组，包含22张大阿尔卡纳和56张小阿尔卡纳';

  @override
  String get feature5Spreads => '5种专业牌阵';

  @override
  String get feature5SpreadsDesc => '从单张牌到凯尔特十字等多种占卜方法';

  @override
  String get featureAI => 'AI塔罗大师';

  @override
  String get featureAIDesc => '如百年经验塔罗大师般的深度解读';

  @override
  String get featureChat => '互动咨询';

  @override
  String get featureChatDesc => '自由询问关于卡牌的任何问题';

  @override
  String get termsAndPolicies => '条款与政策';

  @override
  String get termsOfService => '服务条款';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get marketingConsent => '营销信息接收';

  @override
  String get customerSupport => '客户支持';

  @override
  String get emailSupport => '邮件支持';

  @override
  String get website => '官网';

  @override
  String cannotOpenUrl(String url) {
    return '无法打开URL: $url';
  }

  @override
  String get lastModified => '最后修改：2025年7月3日';

  @override
  String get confirm => '确认';

  @override
  String get companyName => 'Today\'s Studio';

  @override
  String get companyTagline => '创造神秘体验';

  @override
  String get copyright => '© 2025 Today\'s Studio. 保留所有权利。';

  @override
  String get anonymousSoul => '匿名灵魂';

  @override
  String get totalReadings => '总占卜次数';

  @override
  String get joinDate => '加入日期';

  @override
  String get errorLogout => '退出登录时发生错误';

  @override
  String get soulContract => '灵魂契约';

  @override
  String get termsAgreementMessage => '请同意服务条款以使用服务';

  @override
  String get agreeAll => '全部同意';

  @override
  String get required => '必需';

  @override
  String get optional => '可选';

  @override
  String get agreeAndStart => '同意并开始';

  @override
  String get agreeToRequired => '请同意必需条款';

  @override
  String get nickname => '昵称';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get nextStep => '下一步';

  @override
  String get errorNameTooShort => '请输入至少2个字符';

  @override
  String get errorConfirmPassword => '请确认您的密码';

  @override
  String get errorPasswordsDontMatch => '密码不匹配';

  @override
  String get emailInUse => '邮箱已被使用';

  @override
  String get emailAvailable => '邮箱可用';

  @override
  String get nicknameInUse => '昵称已被使用';

  @override
  String get nicknameAvailable => '昵称可用';

  @override
  String get passwordWeak => '弱';

  @override
  String get passwordFair => '一般';

  @override
  String get passwordStrong => '强';

  @override
  String get passwordVeryStrong => '非常强';

  @override
  String get emailVerificationTitle => '邮箱验证';

  @override
  String emailVerificationMessage(String email) {
    return '我们已向 $email 发送了验证邮件。\n请查看您的邮箱并点击验证链接。';
  }

  @override
  String get resendEmail => '重新发送邮件';

  @override
  String get emailResent => '验证邮件已重新发送';

  @override
  String get checkEmailAndReturn => '验证后，请返回应用';

  @override
  String get noHistoryTitle => '尚无塔罗记录';

  @override
  String get noHistoryMessage => '读取您的第一个命运';

  @override
  String get startReading => '开始塔罗占卜';

  @override
  String get deleteReadingTitle => '删除此记录？';

  @override
  String get deleteReadingMessage => '已删除的记录无法恢复';

  @override
  String get deleteAll => '删除全部';

  @override
  String get deleteAllConfirmTitle => '删除所有记录？';

  @override
  String get deleteAllConfirmMessage => '所有塔罗牌阅读将被永久删除。此操作无法撤销。';

  @override
  String get deleteAllButton => '删除全部';

  @override
  String get totalTarotReadings => '塔罗牌阅读总数';

  @override
  String get mostFrequentCard => '最常见的牌';

  @override
  String get cardFrequencyTop5 => '牌频率 - 前5名';

  @override
  String get moodAnalysis => '情绪分析';

  @override
  String get monthlyReadingTrend => '每月阅读趋势';

  @override
  String get noData => '无数据';

  @override
  String get noDataToAnalyze => '没有数据可分析';

  @override
  String get startTarotReading => '开始塔罗牌阅读以查看您的统计数据';

  @override
  String get cardOfFate => '命运之牌';

  @override
  String get cardCallingYou => '这张牌在呼唤你';

  @override
  String get selectThisCard => '选择此牌';

  @override
  String get viewAgain => '再看看';

  @override
  String get select => '选择';

  @override
  String get shufflingCards => '正在洗牌命运之牌...';

  @override
  String get selectCardsIntuition => '凭直觉选择卡牌';

  @override
  String selectMoreCards(int count) {
    return '还需选择 $count 张牌';
  }

  @override
  String get selectionComplete => '选择完成！';

  @override
  String get tapToSelect => '点击选择';

  @override
  String get preparingInterpretation => '准备解读...';

  @override
  String get cardMessage => '卡牌讯息';

  @override
  String get cardsStory => '卡牌的故事';

  @override
  String get specialInterpretation => '特别解读';

  @override
  String get interpretingCards => '解读卡牌中...';

  @override
  String get todaysChatEnded => '今日对话已结束';

  @override
  String get askQuestions => '提出问题';

  @override
  String get continueConversation => '继续对话';

  @override
  String get wantDeeperTruth => '想要更深的真相吗？';

  @override
  String get watchAdToContinue => '观看广告以继续';

  @override
  String get later => '稍后';

  @override
  String get watchAd => '观看广告';

  @override
  String get emailVerification => '邮箱验证';

  @override
  String get checkYourEmail => '请查看您的邮箱';

  @override
  String get verificationEmailSent => '验证邮件已发送';

  @override
  String get verifyingEmail => '验证邮箱中...';

  @override
  String get noEmailReceived => '未收到邮件？';

  @override
  String get checkSpamFolder => '请检查垃圾邮件文件夹';

  @override
  String resendIn(int seconds) {
    return '$seconds 秒后重新发送';
  }

  @override
  String get resendVerificationEmail => '重新发送验证邮件';

  @override
  String get alreadyVerified => '我已经验证了';

  @override
  String get openGateOfFate => '打开命运之门';

  @override
  String get skip => 'SKIP';

  @override
  String get languageChanged => '语言更改成功';

  @override
  String get notificationsEnabled => '通知已启用';

  @override
  String get notificationsDisabled => '通知已禁用';

  @override
  String get vibrationEnabled => '振动已启用';

  @override
  String get vibrationDisabled => '振动已禁用';

  @override
  String get animationsEnabled => '动画已启用';

  @override
  String get animationsDisabled => '动画已禁用';

  @override
  String get notificationPermissionDenied => '需要通知权限';

  @override
  String get errorWeakPassword => '密码太弱';

  @override
  String get moreTitle => '更多';

  @override
  String get willYouSelectIt => '要选择它吗？';

  @override
  String get selectCardByHeart => '选择触动你心灵的牌';

  @override
  String moreToSelect(int count) {
    return '还需选择$count张';
  }

  @override
  String get tapToSelectCard => '点击卡牌进行选择';

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
    return '$month月';
  }

  @override
  String get remainingDraws => '剩余次数';

  @override
  String get noDrawsRemaining => '没有剩余次数';

  @override
  String get adDraws => '广告';

  @override
  String get dailyLimitReached => 'Daily Draw Limit Reached';

  @override
  String get watchAdForMore =>
      'Watch an ad to get more card draws. You can get up to 10 additional draws per day.';

  @override
  String get drawAddedMessage => '增加1次抽卡机会！ ✨';

  @override
  String get adLoadFailed => '广告加载失败。请稍后再试。';

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
  String get tarotMaster => '塔罗大师';

  @override
  String get question => '问题';

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
    return '聊天$count次';
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
  String get startChatMessage => '关于您的塔罗牌解读，有任何问题都可以问我';

  @override
  String get chatHistory => '聊天记录';

  @override
  String get chatHistoryDescription => '您与塔罗大师的对话';

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
  String get oneCardDescription => '今日运势与建议';

  @override
  String get threeCardDescription => '过去、现在、未来的流向';

  @override
  String get celticCrossDescription => '分析情况的各个方面';

  @override
  String get relationshipDescription => '关系动态与未来';

  @override
  String get yesNoDescription => '获得明确答案的占卜';

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
  String get error => '错误';

  @override
  String get ok => '确定';

  @override
  String get errorInvalidFormat => '格式无效';

  @override
  String get errorUnexpected => '发生意外错误';

  @override
  String get errorUnknown => '发生未知错误';

  @override
  String get errorNetworkTimeout => '网络连接超时';

  @override
  String get errorNoInternet => '没有网络连接';

  @override
  String get errorServerError => '服务器错误';

  @override
  String get errorInvalidCredentials => '邮箱或密码无效';

  @override
  String get errorEmailNotVerified => '邮箱未验证';

  @override
  String get errorSessionExpired => '会话已过期，请重新登录';

  @override
  String get errorQuotaExceeded => '超过每日限额';

  @override
  String get errorInvalidResponse => '服务器响应无效';

  @override
  String get errorRateLimitExceeded => '请求过多，请稍后再试';

  @override
  String get errorDataNotFound => '未找到数据';

  @override
  String get errorDataCorrupted => '数据已损坏';

  @override
  String get errorSaveFailed => '保存数据失败';

  @override
  String get errorPermissionDenied => '权限被拒绝';

  @override
  String get errorPermissionRestricted => '访问受限';

  @override
  String get errorEmailAlreadyInUse => '邮箱已被使用';

  @override
  String get errorInvalidEmail => '无效的邮箱地址';

  @override
  String get errorNetworkRequestFailed => '网络请求失败';

  @override
  String get errorOperationNotAllowed => '操作不被允许';

  @override
  String get errorAuthFailed => '认证失败';

  @override
  String get logoutSuccess => '登出成功';

  @override
  String get deleteAccountSuccess => '账号删除成功';

  @override
  String get generalSettings => '通用设置';

  @override
  String get accountSettings => '账号设置';

  @override
  String get languageTitle => '语言';

  @override
  String get notificationsTitle => '通知';

  @override
  String get vibrationTitle => '触觉反馈';

  @override
  String get vibrationSubtitle => '启用振动反馈';

  @override
  String get animationsTitle => '动画';

  @override
  String get animationsSubtitle => '启用界面动画';

  @override
  String get dailyTarotReminder => '获取每日塔罗提醒';

  @override
  String get deleteAccountConfirmMessage => '此操作无法撤销。所有数据将被永久删除。';

  @override
  String get selectedCards => '已选择的卡牌';

  @override
  String get aiInterpretation => 'AI解读';

  @override
  String get invalidEmotionInput => '无效的情绪输入。';

  @override
  String get interpretationNotReceived => '未能接收到解读结果。';

  @override
  String get responseGenerationFailed => '生成响应失败。';

  @override
  String get invalidEmailFormat => '无效的邮箱格式。';

  @override
  String get weakPassword => '密码太弱。请使用至少8个字符，包括大写字母、小写字母、数字和特殊字符。';

  @override
  String get invalidUsername => '用户名必须为3-20个字符，只能使用字母、数字和下划线。';

  @override
  String get signupError => '注册时发生错误。';

  @override
  String get loginError => '登录时发生错误。';

  @override
  String get logoutError => '登出时发生错误。';

  @override
  String get passwordResetEmailFailed => '发送密码重置邮件失败。';

  @override
  String get profileCreationFailed => '创建用户资料失败。';

  @override
  String get noLoggedInUser => '没有登录的用户。';

  @override
  String get profileUpdateFailed => '更新资料失败。';

  @override
  String cardInterpretationFailed(String error) {
    return '卡牌解读失败：$error';
  }

  @override
  String get emailAlreadyInUse => '此邮箱已被使用。';

  @override
  String signupErrorWithMessage(String message) {
    return '注册时发生错误：$message';
  }

  @override
  String get tooManyRequests => '请求过多。请稍后再试。';

  @override
  String get verificationEmailError => '发送验证邮件时发生错误。';
}
