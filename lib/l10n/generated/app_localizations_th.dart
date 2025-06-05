// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appName => 'Moroka';

  @override
  String get appTagline => 'คำทำนายแห่งเงามืด';

  @override
  String get appTitle => 'Moroka - เสียงกระซิบอันน่าสะพรึง';

  @override
  String get onboardingTitle1 => 'ประตูแห่งโชคชะตาเปิดออก';

  @override
  String get onboardingDesc1 =>
      'ภูมิปัญญาโบราณพบกับเทคโนโลยีสมัยใหม่\nเพื่อกระซิบบอกอนาคตของคุณ';

  @override
  String get onboardingTitle2 => 'ความจริงในความมืด';

  @override
  String get onboardingDesc2 =>
      'ไพ่ทาโรต์ไม่เคยโกหก\nพวกมันแค่แสดงความจริงที่คุณรับได้';

  @override
  String get onboardingTitle3 => 'AI อ่านโชคชะตาของคุณ';

  @override
  String get onboardingDesc3 =>
      'ปัญญาประดิษฐ์ตีความไพ่ของคุณ\nและนำทางเส้นทางผ่านการสนทนาลึกซึ้ง';

  @override
  String get onboardingTitle4 => 'คุณพร้อมหรือยัง?';

  @override
  String get onboardingDesc4 =>
      'ทุกทางเลือกมีราคาของมัน\nหากคุณพร้อมเผชิญหน้ากับโชคชะตา...';

  @override
  String get loginTitle => 'คุณกลับมาแล้ว';

  @override
  String get loginSubtitle => 'เรารอคุณอยู่';

  @override
  String get signupTitle => 'สัญญาแห่งโชคชะตา';

  @override
  String get signupSubtitle => 'ลงทะเบียนวิญญาณของคุณ';

  @override
  String get emailLabel => 'อีเมล';

  @override
  String get passwordLabel => 'รหัสผ่าน';

  @override
  String get nameLabel => 'ชื่อ';

  @override
  String get loginButton => 'เข้าสู่ระบบ';

  @override
  String get signupButton => 'ลงทะเบียนวิญญาณ';

  @override
  String get googleLogin => 'เข้าสู่ระบบด้วย Google';

  @override
  String get googleSignup => 'เริ่มต้นด้วย Google';

  @override
  String get alreadyHaveAccount => 'มีบัญชีแล้ว? เข้าสู่ระบบ';

  @override
  String get dontHaveAccount => 'ครั้งแรก? ลงทะเบียน';

  @override
  String get moodQuestion => 'ตอนนี้คุณรู้สึกอย่างไร?';

  @override
  String get selectSpreadButton => 'เลือกการกางไพ่ทาโรต์';

  @override
  String get moodAnxious => 'กังวล';

  @override
  String get moodLonely => 'เหงา';

  @override
  String get moodCurious => 'อยากรู้';

  @override
  String get moodFearful => 'หวาดกลัว';

  @override
  String get moodHopeful => 'มีความหวัง';

  @override
  String get moodConfused => 'สับสน';

  @override
  String get moodDesperate => 'สิ้นหวัง';

  @override
  String get moodExpectant => 'คาดหวัง';

  @override
  String get moodMystical => 'ลึกลับ';

  @override
  String get spreadSelectionTitle => 'เลือกการกางไพ่';

  @override
  String get spreadSelectionSubtitle =>
      'เลือกการกางไพ่ตามความรู้สึกปัจจุบันของคุณ';

  @override
  String get spreadDifficultyBeginner => '1-3 ใบ';

  @override
  String get spreadDifficultyIntermediate => '5-7 ใบ';

  @override
  String get spreadDifficultyAdvanced => '10 ใบ';

  @override
  String get spreadOneCard => 'ไพ่หนึ่งใบ';

  @override
  String get spreadThreeCard => 'ไพ่สามใบ';

  @override
  String get spreadCelticCross => 'เซลติกครอส';

  @override
  String get spreadRelationship => 'การกางไพ่ความสัมพันธ์';

  @override
  String get spreadYesNo => 'ใช่/ไม่ใช่';

  @override
  String get selectCardTitle => 'เลือกไพ่แห่งโชคชะตา';

  @override
  String get currentMoodLabel => 'อารมณ์ปัจจุบันของคุณ: ';

  @override
  String get currentSpreadLabel => 'การกางไพ่ที่เลือก: ';

  @override
  String get shufflingMessage => 'เส้นด้ายแห่งโชคชะตากำลังพันกัน...';

  @override
  String get selectCardInstruction => 'ใช้สัญชาตญาณของคุณและเลือกไพ่';

  @override
  String cardsSelected(int count) {
    return 'เลือกแล้ว $count ใบ';
  }

  @override
  String cardsRemaining(int count) {
    return 'เลือกอีก $count ใบ';
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
  String get typeMessageHint => 'พิมพ์ข้อความ...';

  @override
  String get continueReading => 'รับคำแนะนำที่ลึกซึ้งยิ่งขึ้น';

  @override
  String get watchAdPrompt =>
      'เพื่อฟังเสียงจากห้วงลึกที่ลึกกว่า\nคุณต้องตรวจสอบข้อความจากโลกอื่น';

  @override
  String get interpretingSpread => 'กำลังตีความข้อความจากไพ่...';

  @override
  String get menuHistory => 'บันทึกไพ่ทาโรต์ที่ผ่านมา';

  @override
  String get menuHistoryDesc => 'ย้อนดูโชคชะตาที่ผ่านมาของคุณ';

  @override
  String get menuStatistics => 'สถิติและการวิเคราะห์';

  @override
  String get menuStatisticsDesc => 'วิเคราะห์รูปแบบโชคชะตาของคุณ';

  @override
  String get menuSettings => 'การตั้งค่า';

  @override
  String get menuSettingsDesc => 'ปรับแต่งสภาพแวดล้อมแอป';

  @override
  String get menuAbout => 'เกี่ยวกับ';

  @override
  String get menuAboutDesc => 'Moroka - คำทำนายแห่งเงามืด';

  @override
  String get logoutButton => 'ออกจากระบบ';

  @override
  String get logoutTitle => 'คุณกำลังจะจากไปจริงๆ หรือ?';

  @override
  String get logoutMessage =>
      'เมื่อประตูแห่งโชคชะตาปิดลง\nคุณจะต้องกลับมาอีกครั้ง';

  @override
  String get logoutCancel => 'อยู่ต่อ';

  @override
  String get logoutConfirm => 'จากไป';

  @override
  String get errorOccurred => 'เกิดข้อผิดพลาด';

  @override
  String get errorEmailEmpty => 'กรุณาใส่อีเมลของคุณ';

  @override
  String get errorEmailInvalid => 'รูปแบบอีเมลไม่ถูกต้อง';

  @override
  String get errorPasswordEmpty => 'กรุณาใส่รหัสผ่านของคุณ';

  @override
  String get errorPasswordShort => 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';

  @override
  String get errorNameEmpty => 'กรุณาใส่ชื่อของคุณ';

  @override
  String get errorLoginFailed => 'เข้าสู่ระบบล้มเหลว';

  @override
  String get errorSignupFailed => 'ลงทะเบียนล้มเหลว';

  @override
  String get errorGoogleLoginFailed => 'เข้าสู่ระบบด้วย Google ล้มเหลว';

  @override
  String get errorNetworkFailed => 'กรุณาตรวจสอบการเชื่อมต่อเครือข่ายของคุณ';

  @override
  String get errorNotEnoughCards => 'กรุณาเลือกไพ่เพิ่มเติม';

  @override
  String get successLogin => 'ยินดีต้อนรับ';

  @override
  String get successSignup => 'วิญญาณของคุณได้รับการลงทะเบียนแล้ว';

  @override
  String get successLogout => 'ลาก่อน';

  @override
  String get successCardsSelected => 'เลือกไพ่ทั้งหมดแล้ว';

  @override
  String get settingsLanguageTitle => 'ภาษา';

  @override
  String get settingsLanguageLabel => 'ภาษาของแอป';

  @override
  String get settingsLanguageDesc => 'เลือกภาษาที่คุณต้องการ';

  @override
  String get settingsNotificationTitle => 'การตั้งค่าการแจ้งเตือน';

  @override
  String get settingsDailyNotification => 'การแจ้งเตือนไพ่ทาโรต์ประจำวัน';

  @override
  String get settingsDailyNotificationDesc => 'รับดวงประจำวันทุกเช้า';

  @override
  String get settingsWeeklyReport => 'รายงานไพ่ทาโรต์รายสัปดาห์';

  @override
  String get settingsWeeklyReportDesc => 'รับดวงประจำสัปดาห์ทุกวันจันทร์';

  @override
  String get settingsDisplayTitle => 'การตั้งค่าการแสดงผล';

  @override
  String get settingsVibration => 'เอฟเฟกต์การสั่น';

  @override
  String get settingsVibrationDesc => 'การสั่นสะเทือนเมื่อเลือกไพ่';

  @override
  String get settingsAnimations => 'เอฟเฟกต์แอนิเมชัน';

  @override
  String get settingsAnimationsDesc => 'แอนิเมชันเปลี่ยนหน้าจอ';

  @override
  String get settingsDataTitle => 'การจัดการข้อมูล';

  @override
  String get settingsBackupData => 'สำรองข้อมูล';

  @override
  String get settingsBackupDataDesc => 'สำรองข้อมูลของคุณไปยังคลาวด์';

  @override
  String get settingsClearCache => 'ล้างแคช';

  @override
  String get settingsClearCacheDesc => 'ลบไฟล์ชั่วคราวเพื่อเพิ่มพื้นที่ว่าง';

  @override
  String get settingsDeleteData => 'ลบข้อมูลทั้งหมด';

  @override
  String get settingsDeleteDataDesc => 'ลบบันทึกไพ่ทาโรต์และการตั้งค่าทั้งหมด';

  @override
  String get settingsAccountTitle => 'บัญชี';

  @override
  String get settingsChangePassword => 'เปลี่ยนรหัสผ่าน';

  @override
  String get settingsChangePasswordDesc =>
      'เปลี่ยนรหัสผ่านเพื่อความปลอดภัยของบัญชี';

  @override
  String get settingsDeleteAccount => 'ลบบัญชี';

  @override
  String get settingsDeleteAccountDesc => 'ลบบัญชีของคุณอย่างถาวร';

  @override
  String get dialogBackupTitle => 'สำรองข้อมูล';

  @override
  String get dialogBackupMessage => 'สำรองข้อมูลของคุณไปยังคลาวด์หรือไม่?';

  @override
  String get dialogClearCacheTitle => 'ล้างแคช';

  @override
  String get dialogClearCacheMessage => 'ลบไฟล์ชั่วคราวหรือไม่?';

  @override
  String get dialogDeleteDataTitle => 'ลบข้อมูลทั้งหมด';

  @override
  String get dialogDeleteDataMessage =>
      'บันทึกไพ่ทาโรต์และการตั้งค่าทั้งหมดจะถูกลบอย่างถาวร\nการกระทำนี้ไม่สามารถยกเลิกได้';

  @override
  String get dialogChangePasswordTitle => 'เปลี่ยนรหัสผ่าน';

  @override
  String get dialogDeleteAccountTitle => 'ลบบัญชี';

  @override
  String get dialogDeleteAccountMessage =>
      'การลบบัญชีของคุณจะลบข้อมูลทั้งหมดอย่างถาวร\nการกระทำนี้ไม่สามารถยกเลิกได้';

  @override
  String get currentPassword => 'รหัสผ่านปัจจุบัน';

  @override
  String get newPassword => 'รหัสผ่านใหม่';

  @override
  String get confirmNewPassword => 'ยืนยันรหัสผ่านใหม่';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get backup => 'สำรองข้อมูล';

  @override
  String get delete => 'ลบ';

  @override
  String get change => 'เปลี่ยน';

  @override
  String get successBackup => 'สำรองข้อมูลเสร็จสิ้น';

  @override
  String get successClearCache => 'ล้างแคชแล้ว';

  @override
  String get successDeleteData => 'ลบข้อมูลทั้งหมดแล้ว';

  @override
  String get successChangePassword => 'เปลี่ยนรหัสผ่านแล้ว';

  @override
  String get successDeleteAccount => 'ลบบัญชีแล้ว';

  @override
  String errorBackup(String error) {
    return 'การสำรองข้อมูลล้มเหลว: $error';
  }

  @override
  String errorDeleteData(String error) {
    return 'การลบล้มเหลว: $error';
  }

  @override
  String errorChangePassword(String error) {
    return 'การเปลี่ยนรหัสผ่านล้มเหลว: $error';
  }

  @override
  String errorDeleteAccount(String error) {
    return 'การลบบัญชีล้มเหลว: $error';
  }

  @override
  String get errorPasswordMismatch => 'รหัสผ่านใหม่ไม่ตรงกัน';

  @override
  String get passwordResetTitle => 'รีเซ็ตรหัสผ่าน';

  @override
  String get passwordResetMessage =>
      'ใส่อีเมลที่ลงทะเบียนของคุณ\nเราจะส่งลิงก์รีเซ็ตรหัสผ่านให้คุณ';

  @override
  String get passwordResetSuccess => 'ส่งอีเมลรีเซ็ตรหัสผ่านแล้ว';

  @override
  String get send => 'ส่ง';

  @override
  String get emailPlaceholder => 'your@email.com';

  @override
  String get passwordPlaceholder => '6+ ตัวอักษร';

  @override
  String get forgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get or => 'หรือ';

  @override
  String get continueWithGoogle => 'ดำเนินการต่อด้วย Google';

  @override
  String get noAccount => 'ยังไม่มีบัญชี?';

  @override
  String get signUp => 'ลงทะเบียน';

  @override
  String get appBrandName => 'MOROKA';

  @override
  String get appBrandTagline => 'คำทำนายแห่งเงามืด';

  @override
  String get aboutTitle => 'เกี่ยวกับ';

  @override
  String get aboutSubtitle => 'ไพ่แห่งโชคชะตารอคุณอยู่';

  @override
  String get aboutDescription =>
      'MOROKA\n\nประตูแห่งโชคชะตาได้เปิดออกแล้ว\nคำทำนายแห่งเงามืดจะตีความอนาคตของคุณ\n\nการตีความไพ่ทาโรต์แบบดั้งเดิมด้วย AI ลึกลับ\nมอบข้อมูลเชิงลึกและภูมิปัญญา';

  @override
  String get featuresTitle => 'คุณสมบัติหลัก';

  @override
  String get feature78Cards => 'ไพ่ทาโรต์ดั้งเดิม 78 ใบ';

  @override
  String get feature78CardsDesc =>
      'สำรับไพ่สมบูรณ์พร้อม Major Arcana 22 ใบและ Minor Arcana 56 ใบ';

  @override
  String get feature5Spreads => 'การกางไพ่มืออาชีพ 5 แบบ';

  @override
  String get feature5SpreadsDesc =>
      'วิธีอ่านไพ่หลากหลายตั้งแต่ไพ่หนึ่งใบจนถึงเซลติกครอส';

  @override
  String get featureAI => 'ปรมาจารย์ไพ่ทาโรต์ AI';

  @override
  String get featureAIDesc =>
      'การตีความลึกซึ้งราวกับปรมาจารย์ไพ่ทาโรต์ที่มีประสบการณ์ 100 ปี';

  @override
  String get featureChat => 'การให้คำปรึกษาแบบโต้ตอบ';

  @override
  String get featureChatDesc => 'ถามคำถามเกี่ยวกับไพ่ของคุณได้อย่างอิสระ';

  @override
  String get termsAndPolicies => 'ข้อกำหนดและนโยบาย';

  @override
  String get termsOfService => 'ข้อกำหนดการให้บริการ';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get marketingConsent => 'ข้อมูลทางการตลาด';

  @override
  String get customerSupport => 'ฝ่ายสนับสนุนลูกค้า';

  @override
  String get emailSupport => 'สนับสนุนทางอีเมล';

  @override
  String get website => 'เว็บไซต์';

  @override
  String cannotOpenUrl(String url) {
    return 'ไม่สามารถเปิด URL: $url';
  }

  @override
  String get lastModified => 'แก้ไขล่าสุด: 3 กรกฎาคม 2568';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get companyName => 'Today\'s Studio';

  @override
  String get companyTagline => 'สร้างประสบการณ์ลึกลับ';

  @override
  String get copyright => '© 2568 Today\'s Studio. สงวนลิขสิทธิ์';

  @override
  String get anonymousSoul => 'วิญญาณนิรนาม';

  @override
  String get totalReadings => 'การอ่านไพ่ทั้งหมด';

  @override
  String get joinDate => 'วันที่เข้าร่วม';

  @override
  String get errorLogout => 'เกิดข้อผิดพลาดระหว่างออกจากระบบ';

  @override
  String get soulContract => 'สัญญาวิญญาณ';

  @override
  String get termsAgreementMessage => 'กรุณายอมรับข้อกำหนดเพื่อใช้บริการ';

  @override
  String get agreeAll => 'ยอมรับทั้งหมด';

  @override
  String get required => 'จำเป็น';

  @override
  String get optional => 'ไม่บังคับ';

  @override
  String get agreeAndStart => 'ยอมรับและเริ่มต้น';

  @override
  String get agreeToRequired => 'กรุณายอมรับข้อกำหนดที่จำเป็น';

  @override
  String get nickname => 'ชื่อเล่น';

  @override
  String get confirmPassword => 'ยืนยันรหัสผ่าน';

  @override
  String get nextStep => 'ขั้นตอนถัดไป';

  @override
  String get errorNameTooShort => 'ใส่อย่างน้อย 2 ตัวอักษร';

  @override
  String get errorConfirmPassword => 'กรุณายืนยันรหัสผ่านของคุณ';

  @override
  String get errorPasswordsDontMatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get emailInUse => 'อีเมลถูกใช้งานแล้ว';

  @override
  String get emailAvailable => 'อีเมลพร้อมใช้งาน';

  @override
  String get nicknameInUse => 'ชื่อเล่นถูกใช้งานแล้ว';

  @override
  String get nicknameAvailable => 'ชื่อเล่นพร้อมใช้งาน';

  @override
  String get passwordWeak => 'อ่อนแอ';

  @override
  String get passwordFair => 'พอใช้';

  @override
  String get passwordStrong => 'แข็งแรง';

  @override
  String get passwordVeryStrong => 'แข็งแรงมาก';

  @override
  String get emailVerificationTitle => 'การยืนยันอีเมล';

  @override
  String emailVerificationMessage(String email) {
    return 'เราได้ส่งอีเมลยืนยันไปที่ $email\nกรุณาตรวจสอบอีเมลของคุณและคลิกลิงก์ยืนยัน';
  }

  @override
  String get resendEmail => 'ส่งอีเมลอีกครั้ง';

  @override
  String get emailResent => 'ส่งอีเมลยืนยันอีกครั้งแล้ว';

  @override
  String get checkEmailAndReturn => 'หลังจากยืนยันแล้ว กรุณากลับมาที่แอป';

  @override
  String get noHistoryTitle => 'ยังไม่มีบันทึกไพ่ทาโรต์';

  @override
  String get noHistoryMessage => 'อ่านโชคชะตาแรกของคุณ';

  @override
  String get startReading => 'เริ่มอ่านไพ่ทาโรต์';

  @override
  String get deleteReadingTitle => 'ลบบันทึกนี้หรือไม่?';

  @override
  String get deleteReadingMessage => 'บันทึกที่ลบแล้วไม่สามารถกู้คืนได้';

  @override
  String get cardOfFate => 'ไพ่แห่งโชคชะตา';

  @override
  String get cardCallingYou => 'ไพ่ใบนี้กำลังเรียกหาคุณ';

  @override
  String get selectThisCard => 'คุณจะเลือกมันหรือไม่?';

  @override
  String get viewAgain => 'ดูอีกครั้ง';

  @override
  String get select => 'เลือก';

  @override
  String get shufflingCards => 'กำลังสับไพ่แห่งโชคชะตา...';

  @override
  String get selectCardsIntuition => 'ใช้สัญชาตญาณของคุณและเลือกไพ่';

  @override
  String selectMoreCards(int count) {
    return 'เลือกไพ่อีก $count ใบ';
  }

  @override
  String get selectionComplete => 'การเลือกเสร็จสมบูรณ์!';

  @override
  String get tapToSelect => 'แตะไพ่เพื่อเลือก';

  @override
  String get preparingInterpretation => 'กำลังเตรียมการตีความ...';

  @override
  String get cardMessage => 'ข้อความจากไพ่';

  @override
  String get cardsStory => 'เรื่องราวที่ไพ่ของคุณบอกเล่า';

  @override
  String get specialInterpretation => 'การตีความพิเศษสำหรับคุณ';

  @override
  String get interpretingCards => 'กำลังตีความความหมายของไพ่...';

  @override
  String get todaysChatEnded => 'การสนทนาวันนี้สิ้นสุดแล้ว';

  @override
  String get askQuestions => 'ถามคำถามของคุณ...';

  @override
  String get continueConversation => 'สนทนาต่อ';

  @override
  String get wantDeeperTruth => 'ต้องการรู้ความจริงที่ลึกซึ้งกว่านี้หรือไม่?';

  @override
  String get watchAdToContinue => 'ดูโฆษณาเพื่อสนทนาต่อ\nกับปรมาจารย์ไพ่ทาโรต์';

  @override
  String get later => 'ภายหลัง';

  @override
  String get watchAd => 'ดูโฆษณา';

  @override
  String get emailVerification => 'การยืนยันอีเมล';

  @override
  String get checkYourEmail => 'ตรวจสอบอีเมลของคุณ';

  @override
  String get verificationEmailSent =>
      'เราได้ส่งอีเมลยืนยันไปที่ที่อยู่ด้านบนแล้ว\nกรุณาตรวจสอบกล่องจดหมายของคุณและคลิกลิงก์ยืนยัน';

  @override
  String get verifyingEmail => 'กำลังยืนยันอีเมล...';

  @override
  String get noEmailReceived => 'ไม่ได้รับอีเมลหรือไม่?';

  @override
  String get checkSpamFolder =>
      'ตรวจสอบโฟลเดอร์สแปมของคุณ\nหากยังไม่พบ คลิกปุ่มด้านล่างเพื่อส่งอีกครั้ง';

  @override
  String resendIn(int seconds) {
    return 'ส่งอีกครั้งใน $seconds วินาที';
  }

  @override
  String get resendVerificationEmail => 'ส่งอีเมลยืนยันอีกครั้ง';

  @override
  String get alreadyVerified => 'ฉันยืนยันแล้ว';

  @override
  String get openGateOfFate => 'เปิดประตูแห่งโชคชะตา';

  @override
  String get skip => 'SKIP';

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
  String get drawAddedMessage => 'เพิ่มการจั่วไพ่ 1 ครั้ง! ✨';

  @override
  String get adLoadFailed => 'ไม่สามารถโหลดโฆษณาได้ โปรดลองอีกครั้งภายหลัง';

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
  String get startChatMessage => 'ถามอะไรก็ได้เกี่ยวกับการอ่านไพ่ทาโรต์ของคุณ';

  @override
  String get chatHistory => 'ประวัติการสนทนา';

  @override
  String get chatHistoryDescription => 'การสนทนาของคุณกับปรมาจารย์ไพ่ทาโรต์';

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
