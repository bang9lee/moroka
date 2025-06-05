// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Moroka';

  @override
  String get appTagline => '影の神託';

  @override
  String get appTitle => 'Moroka - 不吉な囁き';

  @override
  String get onboardingTitle1 => '運命の扉が開く';

  @override
  String get onboardingDesc1 => '古代の叡智と現代技術が出会い\nあなたの未来を囁く';

  @override
  String get onboardingTitle2 => '闇の中の真実';

  @override
  String get onboardingDesc2 => 'タロットカードは嘘をつかない\nあなたが受け止められる真実だけを示す';

  @override
  String get onboardingTitle3 => 'AIが読む運命';

  @override
  String get onboardingDesc3 => '人工知能があなたのカードを解釈し\n深い対話を通じて道を導く';

  @override
  String get onboardingTitle4 => '準備はできていますか？';

  @override
  String get onboardingDesc4 => 'すべての選択には代償がある\nもし運命と向き合う準備ができたなら...';

  @override
  String get loginTitle => 'お帰りなさい';

  @override
  String get loginSubtitle => 'お待ちしておりました';

  @override
  String get signupTitle => '運命の契約';

  @override
  String get signupSubtitle => 'あなたの魂を登録する';

  @override
  String get emailLabel => 'メールアドレス';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get nameLabel => '名前';

  @override
  String get loginButton => '入る';

  @override
  String get signupButton => '魂を登録';

  @override
  String get googleLogin => 'Googleでログイン';

  @override
  String get googleSignup => 'Googleで始める';

  @override
  String get alreadyHaveAccount => 'アカウントをお持ちですか？ログイン';

  @override
  String get dontHaveAccount => '初めてですか？登録';

  @override
  String get moodQuestion => '今どんな気持ちですか？';

  @override
  String get selectSpreadButton => 'タロットスプレッドを選ぶ';

  @override
  String get moodAnxious => '不安';

  @override
  String get moodLonely => '孤独';

  @override
  String get moodCurious => '好奇心';

  @override
  String get moodFearful => '恐怖';

  @override
  String get moodHopeful => '希望的';

  @override
  String get moodConfused => '困惑';

  @override
  String get moodDesperate => '絶望的な';

  @override
  String get moodExpectant => '期待';

  @override
  String get moodMystical => '神秘的な';

  @override
  String get spreadSelectionTitle => 'スプレッド選択';

  @override
  String get spreadSelectionSubtitle => '現在の気持ちに基づいてスプレッドを選んでください';

  @override
  String get spreadDifficultyBeginner => '1～3枚';

  @override
  String get spreadDifficultyIntermediate => '5～7枚';

  @override
  String get spreadDifficultyAdvanced => '10枚';

  @override
  String get spreadOneCard => 'ワンカード';

  @override
  String get spreadThreeCard => 'スリーカード';

  @override
  String get spreadCelticCross => 'ケルト十字';

  @override
  String get spreadRelationship => '関係性スプレッド';

  @override
  String get spreadYesNo => 'はい/いいえ';

  @override
  String get selectCardTitle => '運命のカードを選んでください';

  @override
  String get currentMoodLabel => '現在の気持ち：';

  @override
  String get currentSpreadLabel => '選択したスプレッド：';

  @override
  String get shufflingMessage => '運命の糸が絡み合っています...';

  @override
  String get selectCardInstruction => '直感に従ってカードを選んでください';

  @override
  String cardsSelected(int count) {
    return '$count枚選択済み';
  }

  @override
  String cardsRemaining(int count) {
    return 'あと$count枚選んでください';
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
  String get typeMessageHint => 'メッセージを入力...';

  @override
  String get continueReading => 'より深いアドバイスを得る';

  @override
  String get watchAdPrompt => 'より深淵からの声を聞くためには、\n別世界からのメッセージを確認する必要があります。';

  @override
  String get interpretingSpread => 'カードのメッセージを解釈しています...';

  @override
  String get menuHistory => '過去のタロット記録';

  @override
  String get menuHistoryDesc => 'あなたの過去の運命を振り返る';

  @override
  String get menuStatistics => '統計と分析';

  @override
  String get menuStatisticsDesc => 'あなたの運命パターンを分析する';

  @override
  String get menuSettings => '設定';

  @override
  String get menuSettingsDesc => 'アプリ環境を調整する';

  @override
  String get menuAbout => 'アプリについて';

  @override
  String get menuAboutDesc => 'Moroka - 影の神託';

  @override
  String get logoutButton => 'ログアウト';

  @override
  String get logoutTitle => '本当に離れますか？';

  @override
  String get logoutMessage => '運命の扉が閉じれば\nまた戻ってこなければならない';

  @override
  String get logoutCancel => '残る';

  @override
  String get logoutConfirm => '離れる';

  @override
  String get errorOccurred => 'エラーが発生しました';

  @override
  String get errorEmailEmpty => 'メールアドレスを入力してください';

  @override
  String get errorEmailInvalid => '無効なメールアドレス形式です';

  @override
  String get errorPasswordEmpty => 'パスワードを入力してください';

  @override
  String get errorPasswordShort => 'パスワードは6文字以上必要です';

  @override
  String get errorNameEmpty => '名前を入力してください';

  @override
  String get errorLoginFailed => 'ログインに失敗しました';

  @override
  String get errorSignupFailed => '登録に失敗しました';

  @override
  String get errorGoogleLoginFailed => 'Googleログインに失敗しました';

  @override
  String get errorNetworkFailed => 'ネットワーク接続を確認してください';

  @override
  String get errorNotEnoughCards => 'もっとカードを選んでください';

  @override
  String get successLogin => 'ようこそ';

  @override
  String get successSignup => 'あなたの魂が登録されました';

  @override
  String get successLogout => 'さようなら';

  @override
  String get successCardsSelected => 'すべてのカードが選択されました';

  @override
  String get settingsLanguageTitle => '言語設定';

  @override
  String get settingsLanguageLabel => 'アプリの言語';

  @override
  String get settingsLanguageDesc => 'お好みの言語を選択してください';

  @override
  String get settingsNotificationTitle => '通知設定';

  @override
  String get settingsDailyNotification => 'デイリータロット通知';

  @override
  String get settingsDailyNotificationDesc => '毎朝、あなたの運勢をお届けします';

  @override
  String get settingsWeeklyReport => '週間タロットレポート';

  @override
  String get settingsWeeklyReportDesc => '毎週月曜日に運勢をお送りします';

  @override
  String get settingsDisplayTitle => '表示設定';

  @override
  String get settingsVibration => '振動エフェクト';

  @override
  String get settingsVibrationDesc => 'カード選択時の振動フィードバック';

  @override
  String get settingsAnimations => 'アニメーション効果';

  @override
  String get settingsAnimationsDesc => '画面遷移のアニメーション';

  @override
  String get settingsDataTitle => 'データ管理';

  @override
  String get settingsBackupData => 'データバックアップ';

  @override
  String get settingsBackupDataDesc => 'クラウドにデータをバックアップ';

  @override
  String get settingsClearCache => 'キャッシュのクリア';

  @override
  String get settingsClearCacheDesc => '一時ファイルを削除して容量を解放';

  @override
  String get settingsDeleteData => 'すべてのデータを削除';

  @override
  String get settingsDeleteDataDesc => 'すべてのタロット記録と設定を削除';

  @override
  String get settingsAccountTitle => 'アカウント';

  @override
  String get settingsChangePassword => 'パスワードの変更';

  @override
  String get settingsChangePasswordDesc => 'アカウントセキュリティのためパスワードを変更';

  @override
  String get settingsDeleteAccount => 'アカウントの削除';

  @override
  String get settingsDeleteAccountDesc => 'アカウントを永久に削除';

  @override
  String get dialogBackupTitle => 'データバックアップ';

  @override
  String get dialogBackupMessage => 'クラウドにデータをバックアップしますか？';

  @override
  String get dialogClearCacheTitle => 'キャッシュのクリア';

  @override
  String get dialogClearCacheMessage => '一時ファイルを削除しますか？';

  @override
  String get dialogDeleteDataTitle => 'すべてのデータを削除';

  @override
  String get dialogDeleteDataMessage =>
      'すべてのタロット記録と設定が永久に削除されます。\nこの操作は取り消せません。';

  @override
  String get dialogChangePasswordTitle => 'パスワードの変更';

  @override
  String get dialogDeleteAccountTitle => 'アカウントの削除';

  @override
  String get dialogDeleteAccountMessage =>
      'アカウントを削除すると、すべてのデータが永久に削除されます。\nこの操作は取り消せません。';

  @override
  String get currentPassword => '現在のパスワード';

  @override
  String get newPassword => '新しいパスワード';

  @override
  String get confirmNewPassword => '新しいパスワードの確認';

  @override
  String get cancel => 'キャンセル';

  @override
  String get backup => 'バックアップ';

  @override
  String get delete => '削除';

  @override
  String get change => '変更';

  @override
  String get successBackup => 'バックアップが完了しました';

  @override
  String get successClearCache => 'キャッシュをクリアしました';

  @override
  String get successDeleteData => 'すべてのデータを削除しました';

  @override
  String get successChangePassword => 'パスワードを変更しました';

  @override
  String get successDeleteAccount => 'アカウントを削除しました';

  @override
  String errorBackup(String error) {
    return 'バックアップに失敗しました：$error';
  }

  @override
  String errorDeleteData(String error) {
    return '削除に失敗しました：$error';
  }

  @override
  String errorChangePassword(String error) {
    return 'パスワードの変更に失敗しました：$error';
  }

  @override
  String errorDeleteAccount(String error) {
    return 'アカウントの削除に失敗しました：$error';
  }

  @override
  String get errorPasswordMismatch => '新しいパスワードが一致しません';

  @override
  String get passwordResetTitle => 'パスワードのリセット';

  @override
  String get passwordResetMessage =>
      '登録されたメールアドレスを入力してください。\nパスワードリセットリンクをお送りします。';

  @override
  String get passwordResetSuccess => 'パスワードリセットメールを送信しました';

  @override
  String get send => '送信';

  @override
  String get emailPlaceholder => 'your@email.com';

  @override
  String get passwordPlaceholder => '6文字以上';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get login => 'ログイン';

  @override
  String get or => 'または';

  @override
  String get continueWithGoogle => 'Googleで続ける';

  @override
  String get noAccount => 'アカウントをお持ちでない方';

  @override
  String get signUp => '新規登録';

  @override
  String get appBrandName => 'MOROKA';

  @override
  String get appBrandTagline => '影の神託';

  @override
  String get aboutTitle => 'アプリについて';

  @override
  String get aboutSubtitle => '運命のカードがあなたを待っている';

  @override
  String get aboutDescription =>
      'MOROKA\n\n運命の扉が開かれました\n影の神託があなたの未来を解釈します\n\n神秘的なAIによる伝統的なタロット解釈\n深い洞察と叡智を提供';

  @override
  String get featuresTitle => '主な機能';

  @override
  String get feature78Cards => '78枚の伝統的タロットカード';

  @override
  String get feature78CardsDesc => '22枚の大アルカナと56枚の小アルカナの完全デッキ';

  @override
  String get feature5Spreads => '5つのプロフェッショナルスプレッド';

  @override
  String get feature5SpreadsDesc => 'ワンカードからケルト十字まで様々な読み取り方法';

  @override
  String get featureAI => 'AIタロットマスター';

  @override
  String get featureAIDesc => '100年の経験を持つタロットマスターのような深い解釈';

  @override
  String get featureChat => 'インタラクティブな相談';

  @override
  String get featureChatDesc => 'カードについて自由に質問できます';

  @override
  String get termsAndPolicies => '利用規約とポリシー';

  @override
  String get termsOfService => '利用規約';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get marketingConsent => 'マーケティング情報';

  @override
  String get customerSupport => 'カスタマーサポート';

  @override
  String get emailSupport => 'メールサポート';

  @override
  String get website => 'ウェブサイト';

  @override
  String cannotOpenUrl(String url) {
    return 'URLを開けません：$url';
  }

  @override
  String get lastModified => '最終更新日：2025年7月3日';

  @override
  String get confirm => '確認';

  @override
  String get companyName => 'Today\'s Studio';

  @override
  String get companyTagline => '神秘的な体験を創造する';

  @override
  String get copyright => '© 2025 Today\'s Studio. All rights reserved.';

  @override
  String get anonymousSoul => '名もなき魂';

  @override
  String get totalReadings => '総占い回数';

  @override
  String get joinDate => '参加日';

  @override
  String get errorLogout => 'ログアウト中にエラーが発生しました';

  @override
  String get soulContract => '魂の契約';

  @override
  String get termsAgreementMessage => 'サービス利用のため規約にご同意ください';

  @override
  String get agreeAll => 'すべてに同意';

  @override
  String get required => '必須';

  @override
  String get optional => '任意';

  @override
  String get agreeAndStart => '同意して始める';

  @override
  String get agreeToRequired => '必須規約にご同意ください';

  @override
  String get nickname => 'ニックネーム';

  @override
  String get confirmPassword => 'パスワードの確認';

  @override
  String get nextStep => '次のステップ';

  @override
  String get errorNameTooShort => '2文字以上入力してください';

  @override
  String get errorConfirmPassword => 'パスワードを確認してください';

  @override
  String get errorPasswordsDontMatch => 'パスワードが一致しません';

  @override
  String get emailInUse => 'このメールアドレスは既に使用されています';

  @override
  String get emailAvailable => 'このメールアドレスは使用可能です';

  @override
  String get nicknameInUse => 'このニックネームは既に使用されています';

  @override
  String get nicknameAvailable => 'このニックネームは使用可能です';

  @override
  String get passwordWeak => '弱い';

  @override
  String get passwordFair => '普通';

  @override
  String get passwordStrong => '強い';

  @override
  String get passwordVeryStrong => '非常に強い';

  @override
  String get emailVerificationTitle => 'メール認証';

  @override
  String emailVerificationMessage(String email) {
    return '$email に確認メールを送信しました。\nメールをご確認いただき、認証リンクをクリックしてください。';
  }

  @override
  String get resendEmail => 'メールを再送信';

  @override
  String get emailResent => '確認メールを再送信しました';

  @override
  String get checkEmailAndReturn => '認証後、アプリにお戻りください';

  @override
  String get noHistoryTitle => 'タロットの記録はまだありません';

  @override
  String get noHistoryMessage => '最初の運命を読み取りましょう';

  @override
  String get startReading => 'タロット占いを始める';

  @override
  String get deleteReadingTitle => 'この記録を削除しますか？';

  @override
  String get deleteReadingMessage => '削除された記録は復元できません';

  @override
  String get cardOfFate => '運命のカード';

  @override
  String get cardCallingYou => 'このカードがあなたを呼んでいます';

  @override
  String get selectThisCard => '選びますか？';

  @override
  String get viewAgain => 'もう一度見る';

  @override
  String get select => '選択';

  @override
  String get shufflingCards => '運命のカードをシャッフルしています...';

  @override
  String get selectCardsIntuition => '直感に従ってカードを選んでください';

  @override
  String selectMoreCards(int count) {
    return 'あと$count枚選んでください';
  }

  @override
  String get selectionComplete => '選択完了！';

  @override
  String get tapToSelect => 'タップして選択';

  @override
  String get preparingInterpretation => '解釈を準備しています...';

  @override
  String get cardMessage => 'カードからのメッセージ';

  @override
  String get cardsStory => 'あなたのカードが語る物語';

  @override
  String get specialInterpretation => 'あなたのための特別な解釈';

  @override
  String get interpretingCards => 'カードの意味を解釈しています...';

  @override
  String get todaysChatEnded => '本日の対話は終了しました';

  @override
  String get askQuestions => '質問をどうぞ...';

  @override
  String get continueConversation => '対話を続ける';

  @override
  String get wantDeeperTruth => 'より深い真実を知りたいですか？';

  @override
  String get watchAdToContinue => '広告を視聴して\nタロットマスターとの対話を続けましょう';

  @override
  String get later => '後で';

  @override
  String get watchAd => '広告を見る';

  @override
  String get emailVerification => 'メール認証';

  @override
  String get checkYourEmail => 'メールをご確認ください';

  @override
  String get verificationEmailSent =>
      '上記のアドレスに確認メールを送信しました。\n受信トレイをご確認いただき、認証リンクをクリックしてください。';

  @override
  String get verifyingEmail => 'メールを確認中...';

  @override
  String get noEmailReceived => 'メールが届きませんか？';

  @override
  String get checkSpamFolder =>
      '迷惑メールフォルダをご確認ください。\nそれでも見つからない場合は、下のボタンをクリックして再送信してください。';

  @override
  String resendIn(int seconds) {
    return '$seconds秒後に再送信';
  }

  @override
  String get resendVerificationEmail => '確認メールを再送信';

  @override
  String get alreadyVerified => '既に認証済みです';

  @override
  String get openGateOfFate => '運命の扉を開く';

  @override
  String get skip => 'SKIP';

  @override
  String get willYouSelectIt => '選択しますか？';

  @override
  String get selectCardByHeart => '心に響くカードを選んでください';

  @override
  String moreToSelect(int count) {
    return 'あと$count枚選択';
  }

  @override
  String get tapToSelectCard => 'カードをタップして選択';

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
  String get noDataToAnalyze => 'No data to analyze yet';

  @override
  String get startTarotReading => 'Start your tarot reading';

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
  String timesCount(int count) {
    return '$count times';
  }

  @override
  String monthLabel(String month) {
    return '$month月';
  }

  @override
  String get remainingDraws => 'Remaining Draws';

  @override
  String get noDrawsRemaining => 'No draws remaining';

  @override
  String get adDraws => 'Ad';

  @override
  String get dailyLimitReached => '1日の引き制限に達しました';

  @override
  String get watchAdForMore => '広告を視聴してカードを引く回数を追加しましょう。1日最大10回まで追加できます。';

  @override
  String get drawAddedMessage => '1回分のドローが追加されました！ ✨';

  @override
  String get adLoadFailed => '広告の読み込みに失敗しました。後でもう一度お試しください。';

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
  String get startChatMessage => 'タロットリーディングについて何でも聞いてください';

  @override
  String get chatHistory => 'チャット履歴';

  @override
  String get chatHistoryDescription => 'タロットマスターとの会話';

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
