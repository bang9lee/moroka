// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Moroka';

  @override
  String get appTagline => 'Oráculo de Sombras';

  @override
  String get appTitle => 'Moroka - Susurros Siniestros';

  @override
  String get onboardingTitle1 => 'La Puerta del Destino se Abre';

  @override
  String get onboardingDesc1 =>
      'La sabiduría antigua se encuentra con la tecnología moderna\npara susurrar tu futuro';

  @override
  String get onboardingTitle2 => 'Verdad en la Oscuridad';

  @override
  String get onboardingDesc2 =>
      'Las cartas del tarot nunca mienten\nSolo muestran la verdad que puedes soportar';

  @override
  String get onboardingTitle3 => 'La IA Lee tu Destino';

  @override
  String get onboardingDesc3 =>
      'La inteligencia artificial interpreta tus cartas\ny guía tu camino a través de conversaciones profundas';

  @override
  String get onboardingTitle4 => '¿Estás Preparado?';

  @override
  String get onboardingDesc4 =>
      'Cada elección tiene su precio\nSi estás listo para enfrentar tu destino...';

  @override
  String get loginTitle => 'Has Regresado';

  @override
  String get loginSubtitle => 'Te hemos estado esperando';

  @override
  String get signupTitle => 'Contrato del Destino';

  @override
  String get signupSubtitle => 'Registra tu alma';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get loginButton => 'Entrar';

  @override
  String get signupButton => 'Registrar Alma';

  @override
  String get googleLogin => 'Iniciar sesión con Google';

  @override
  String get googleSignup => 'Comenzar con Google';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get dontHaveAccount => '¿Primera vez? Regístrate';

  @override
  String get moodQuestion => '¿Cómo te sientes ahora?';

  @override
  String get selectSpreadButton => 'Seleccionar Tirada de Tarot';

  @override
  String get moodAnxious => 'Ansioso';

  @override
  String get moodLonely => 'Solitario';

  @override
  String get moodCurious => 'Curioso';

  @override
  String get moodFearful => 'Temeroso';

  @override
  String get moodHopeful => 'Esperanzado';

  @override
  String get moodConfused => 'Confundido';

  @override
  String get moodDesperate => 'Desesperado';

  @override
  String get moodExpectant => 'Expectante';

  @override
  String get moodMystical => 'Místico';

  @override
  String get spreadSelectionTitle => 'Seleccionar Tirada';

  @override
  String get spreadSelectionSubtitle =>
      'Elige una tirada basada en tus sentimientos actuales';

  @override
  String get spreadDifficultyBeginner => '1-3 cartas';

  @override
  String get spreadDifficultyIntermediate => '5-7 cartas';

  @override
  String get spreadDifficultyAdvanced => '10 cartas';

  @override
  String get spreadOneCard => 'Una Carta';

  @override
  String get spreadThreeCard => 'Tres Cartas';

  @override
  String get spreadCelticCross => 'Cruz Celta';

  @override
  String get spreadRelationship => 'Tirada de Relaciones';

  @override
  String get spreadYesNo => 'Sí/No';

  @override
  String get selectCardTitle => 'Selecciona las cartas del destino';

  @override
  String get currentMoodLabel => 'Tu estado de ánimo actual: ';

  @override
  String get currentSpreadLabel => 'Tirada seleccionada: ';

  @override
  String get shufflingMessage => 'Los hilos del destino se entrelazan...';

  @override
  String get selectCardInstruction =>
      'Sigue tu intuición y selecciona las cartas';

  @override
  String cardsSelected(int count) {
    return '$count seleccionadas';
  }

  @override
  String cardsRemaining(int count) {
    return 'Selecciona $count más';
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
  String get typeMessageHint => 'Escribe un mensaje...';

  @override
  String get continueReading => 'Obtener consejos más profundos';

  @override
  String get watchAdPrompt =>
      'Para escuchar la voz del abismo más profundo,\ndebes revisar mensajes de otro mundo.';

  @override
  String get interpretingSpread =>
      'Interpretando los mensajes de las cartas...';

  @override
  String get menuHistory => 'Registros de Tarot Pasados';

  @override
  String get menuHistoryDesc => 'Revisa tus destinos pasados';

  @override
  String get menuStatistics => 'Estadísticas y Análisis';

  @override
  String get menuStatisticsDesc => 'Analiza tus patrones de destino';

  @override
  String get menuSettings => 'Configuración';

  @override
  String get menuSettingsDesc => 'Ajustar el entorno de la aplicación';

  @override
  String get menuAbout => 'Acerca de';

  @override
  String get menuAboutDesc => 'Moroka - Oráculo de Sombras';

  @override
  String get logoutButton => 'Cerrar sesión';

  @override
  String get logoutTitle => '¿Realmente te vas?';

  @override
  String get logoutMessage =>
      'Cuando la puerta del destino se cierre\ndeberás regresar nuevamente';

  @override
  String get logoutCancel => 'Quedarme';

  @override
  String get logoutConfirm => 'Irme';

  @override
  String get errorOccurred => 'Ocurrió un error';

  @override
  String get errorEmailEmpty => 'Por favor ingresa tu correo electrónico';

  @override
  String get errorEmailInvalid => 'Formato de correo electrónico inválido';

  @override
  String get errorPasswordEmpty => 'Por favor ingresa tu contraseña';

  @override
  String get errorPasswordShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get errorNameEmpty => 'Por favor ingresa tu nombre';

  @override
  String get errorLoginFailed => 'Error al iniciar sesión';

  @override
  String get errorSignupFailed => 'Error al registrarse';

  @override
  String get errorGoogleLoginFailed => 'Error al iniciar sesión con Google';

  @override
  String get errorNetworkFailed => 'Por favor verifica tu conexión a internet';

  @override
  String get errorNotEnoughCards => 'Por favor selecciona más cartas';

  @override
  String get successLogin => 'Bienvenido';

  @override
  String get successSignup => 'Tu alma ha sido registrada';

  @override
  String get successLogout => 'Adiós';

  @override
  String get successCardsSelected => 'Todas las cartas han sido seleccionadas';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsLanguageLabel => 'Idioma de la aplicación';

  @override
  String get settingsLanguageDesc => 'Selecciona tu idioma preferido';

  @override
  String get settingsNotificationTitle => 'Configuración de notificaciones';

  @override
  String get settingsDailyNotification => 'Notificación diaria de tarot';

  @override
  String get settingsDailyNotificationDesc =>
      'Recibe tu fortuna diaria cada mañana';

  @override
  String get settingsWeeklyReport => 'Reporte semanal de tarot';

  @override
  String get settingsWeeklyReportDesc => 'Recibe tu fortuna semanal cada lunes';

  @override
  String get settingsDisplayTitle => 'Configuración de pantalla';

  @override
  String get settingsVibration => 'Efectos de vibración';

  @override
  String get settingsVibrationDesc => 'Vibración al seleccionar cartas';

  @override
  String get settingsAnimations => 'Efectos de animación';

  @override
  String get settingsAnimationsDesc => 'Animaciones de transición de pantalla';

  @override
  String get settingsDataTitle => 'Gestión de datos';

  @override
  String get settingsBackupData => 'Copia de seguridad';

  @override
  String get settingsBackupDataDesc => 'Respaldar tus datos en la nube';

  @override
  String get settingsClearCache => 'Limpiar caché';

  @override
  String get settingsClearCacheDesc =>
      'Eliminar archivos temporales para liberar espacio';

  @override
  String get settingsDeleteData => 'Eliminar todos los datos';

  @override
  String get settingsDeleteDataDesc =>
      'Eliminar todos los registros de tarot y configuraciones';

  @override
  String get settingsAccountTitle => 'Cuenta';

  @override
  String get settingsChangePassword => 'Cambiar contraseña';

  @override
  String get settingsChangePasswordDesc =>
      'Cambia tu contraseña para seguridad de la cuenta';

  @override
  String get settingsDeleteAccount => 'Eliminar cuenta';

  @override
  String get settingsDeleteAccountDesc => 'Eliminar permanentemente tu cuenta';

  @override
  String get dialogBackupTitle => 'Copia de seguridad';

  @override
  String get dialogBackupMessage => '¿Respaldar tus datos en la nube?';

  @override
  String get dialogClearCacheTitle => 'Limpiar caché';

  @override
  String get dialogClearCacheMessage => '¿Eliminar archivos temporales?';

  @override
  String get dialogDeleteDataTitle => 'Eliminar todos los datos';

  @override
  String get dialogDeleteDataMessage =>
      'Todos los registros de tarot y configuraciones serán eliminados permanentemente.\nEsta acción no se puede deshacer.';

  @override
  String get dialogChangePasswordTitle => 'Cambiar contraseña';

  @override
  String get dialogDeleteAccountTitle => 'Eliminar cuenta';

  @override
  String get dialogDeleteAccountMessage =>
      'Eliminar tu cuenta borrará permanentemente todos los datos.\nEsta acción no se puede deshacer.';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get cancel => 'Cancelar';

  @override
  String get backup => 'Respaldar';

  @override
  String get delete => 'Eliminar';

  @override
  String get change => 'Cambiar';

  @override
  String get successBackup => 'Copia de seguridad completada';

  @override
  String get successClearCache => 'Caché limpiado';

  @override
  String get successDeleteData => 'Todos los datos eliminados';

  @override
  String get successChangePassword => 'Contraseña cambiada';

  @override
  String get successDeleteAccount => 'Cuenta eliminada';

  @override
  String errorBackup(String error) {
    return 'Error al respaldar: $error';
  }

  @override
  String errorDeleteData(String error) {
    return 'Error al eliminar: $error';
  }

  @override
  String errorChangePassword(String error) {
    return 'Error al cambiar contraseña: $error';
  }

  @override
  String errorDeleteAccount(String error) {
    return 'Error al eliminar cuenta: $error';
  }

  @override
  String get errorPasswordMismatch => 'Las contraseñas nuevas no coinciden';

  @override
  String get passwordResetTitle => 'Restablecer contraseña';

  @override
  String get passwordResetMessage =>
      'Ingresa tu correo electrónico registrado.\nTe enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get passwordResetSuccess => 'Correo de restablecimiento enviado';

  @override
  String get send => 'Enviar';

  @override
  String get emailPlaceholder => 'tu@correo.com';

  @override
  String get passwordPlaceholder => '6+ caracteres';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get or => 'o';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get noAccount => '¿No tienes cuenta?';

  @override
  String get signUp => 'Registrarse';

  @override
  String get appBrandName => 'MOROKA';

  @override
  String get appBrandTagline => 'oráculo de sombras';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get aboutSubtitle => 'Las cartas del destino te esperan';

  @override
  String get aboutDescription =>
      'MOROKA\n\nLa puerta del destino se ha abierto\nEl oráculo de sombras interpretará tu futuro\n\nInterpretación tradicional del tarot con IA mística\nProporcionando perspectivas profundas y sabiduría';

  @override
  String get featuresTitle => 'Características principales';

  @override
  String get feature78Cards => '78 Cartas de tarot tradicionales';

  @override
  String get feature78CardsDesc =>
      'Baraja completa con 22 Arcanos Mayores y 56 Arcanos Menores';

  @override
  String get feature5Spreads => '5 Tiradas profesionales';

  @override
  String get feature5SpreadsDesc =>
      'Varios métodos de lectura desde Una Carta hasta Cruz Celta';

  @override
  String get featureAI => 'Maestro de tarot con IA';

  @override
  String get featureAIDesc =>
      'Interpretaciones profundas como un maestro de tarot con 100 años de experiencia';

  @override
  String get featureChat => 'Consulta interactiva';

  @override
  String get featureChatDesc => 'Haz preguntas libremente sobre tus cartas';

  @override
  String get termsAndPolicies => 'Términos y políticas';

  @override
  String get termsOfService => 'Términos de servicio';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get marketingConsent => 'Información de marketing';

  @override
  String get customerSupport => 'Soporte al cliente';

  @override
  String get emailSupport => 'Soporte por correo';

  @override
  String get website => 'Sitio web';

  @override
  String cannotOpenUrl(String url) {
    return 'No se puede abrir URL: $url';
  }

  @override
  String get lastModified => 'Última modificación: 3 de julio de 2025';

  @override
  String get confirm => 'Confirmar';

  @override
  String get companyName => 'Today\'s Studio';

  @override
  String get companyTagline => 'Creando experiencias místicas';

  @override
  String get copyright =>
      '© 2025 Today\'s Studio. Todos los derechos reservados.';

  @override
  String get anonymousSoul => 'Alma anónima';

  @override
  String get totalReadings => 'Lecturas totales';

  @override
  String get joinDate => 'Fecha de registro';

  @override
  String get errorLogout => 'Error al cerrar sesión';

  @override
  String get soulContract => 'Contrato del alma';

  @override
  String get termsAgreementMessage =>
      'Por favor acepta los términos para usar el servicio';

  @override
  String get agreeAll => 'Aceptar todo';

  @override
  String get required => 'Requerido';

  @override
  String get optional => 'Opcional';

  @override
  String get agreeAndStart => 'Aceptar y comenzar';

  @override
  String get agreeToRequired => 'Por favor acepta los términos requeridos';

  @override
  String get nickname => 'Apodo';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get nextStep => 'Siguiente paso';

  @override
  String get errorNameTooShort => 'Ingresa al menos 2 caracteres';

  @override
  String get errorConfirmPassword => 'Por favor confirma tu contraseña';

  @override
  String get errorPasswordsDontMatch => 'Las contraseñas no coinciden';

  @override
  String get emailInUse => 'Correo electrónico ya en uso';

  @override
  String get emailAvailable => 'Correo electrónico disponible';

  @override
  String get nicknameInUse => 'Apodo ya en uso';

  @override
  String get nicknameAvailable => 'Apodo disponible';

  @override
  String get passwordWeak => 'Débil';

  @override
  String get passwordFair => 'Regular';

  @override
  String get passwordStrong => 'Fuerte';

  @override
  String get passwordVeryStrong => 'Muy fuerte';

  @override
  String get emailVerificationTitle => 'Verificación de correo';

  @override
  String emailVerificationMessage(String email) {
    return 'Hemos enviado un correo de verificación a $email.\nPor favor revisa tu correo y haz clic en el enlace de verificación.';
  }

  @override
  String get resendEmail => 'Reenviar correo';

  @override
  String get emailResent => 'Correo de verificación reenviado';

  @override
  String get checkEmailAndReturn =>
      'Después de verificar, por favor regresa a la aplicación';

  @override
  String get noHistoryTitle => 'Aún no hay registros de tarot';

  @override
  String get noHistoryMessage => 'Lee tu primer destino';

  @override
  String get startReading => 'Iniciar lectura de tarot';

  @override
  String get deleteReadingTitle => '¿Eliminar este registro?';

  @override
  String get deleteReadingMessage =>
      'Los registros eliminados no se pueden recuperar';

  @override
  String get cardOfFate => 'Carta del Destino';

  @override
  String get cardCallingYou => 'Esta carta te está llamando';

  @override
  String get selectThisCard => '¿La seleccionarás?';

  @override
  String get viewAgain => 'Ver de Nuevo';

  @override
  String get select => 'Seleccionar';

  @override
  String get shufflingCards => 'Mezclando las cartas del destino...';

  @override
  String get selectCardsIntuition =>
      'Sigue tu intuición y selecciona las cartas';

  @override
  String selectMoreCards(int count) {
    return 'Selecciona $count cartas más';
  }

  @override
  String get selectionComplete => '¡Selección completa!';

  @override
  String get tapToSelect => 'Toca una carta para seleccionar';

  @override
  String get preparingInterpretation => 'Preparando interpretación...';

  @override
  String get cardMessage => 'Mensaje de las cartas';

  @override
  String get cardsStory => 'La historia que cuentan tus cartas';

  @override
  String get specialInterpretation => 'Una interpretación especial para ti';

  @override
  String get interpretingCards =>
      'Interpretando el significado de las cartas...';

  @override
  String get todaysChatEnded => 'La conversación de hoy ha terminado';

  @override
  String get askQuestions => 'Haz tus preguntas...';

  @override
  String get continueConversation => 'Continuar conversación';

  @override
  String get wantDeeperTruth => '¿Quieres conocer verdades más profundas?';

  @override
  String get watchAdToContinue =>
      'Ve un anuncio para continuar\ntu conversación con el Maestro del Tarot';

  @override
  String get later => 'Más tarde';

  @override
  String get watchAd => 'Ver anuncio';

  @override
  String get emailVerification => 'Verificación de correo';

  @override
  String get checkYourEmail => 'Revisa tu correo electrónico';

  @override
  String get verificationEmailSent =>
      'Hemos enviado un correo de verificación a la dirección anterior.\nPor favor revisa tu bandeja de entrada y haz clic en el enlace de verificación.';

  @override
  String get verifyingEmail => 'Verificando correo...';

  @override
  String get noEmailReceived => '¿No recibiste el correo?';

  @override
  String get checkSpamFolder =>
      'Revisa tu carpeta de spam.\nSi aún no está ahí, haz clic en el botón de abajo para reenviar.';

  @override
  String resendIn(int seconds) {
    return 'Reenviar en ${seconds}s';
  }

  @override
  String get resendVerificationEmail => 'Reenviar correo de verificación';

  @override
  String get alreadyVerified => 'Ya he verificado';

  @override
  String get openGateOfFate => 'Abrir la Puerta del Destino';

  @override
  String get skip => 'SKIP';

  @override
  String get willYouSelectIt => '¿La seleccionarás?';

  @override
  String get selectCardByHeart => 'Selecciona la carta que atraiga tu corazón';

  @override
  String moreToSelect(int count) {
    return '$count más para seleccionar';
  }

  @override
  String get tapToSelectCard => 'Toca la carta para seleccionar';

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
  String get drawAddedMessage => '¡1 tirada añadida! ✨';

  @override
  String get adLoadFailed =>
      'No se pudo cargar el anuncio. Por favor, inténtalo más tarde.';

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
      'Pregúntame cualquier cosa sobre tu lectura de tarot';

  @override
  String get chatHistory => 'Historial de Chat';

  @override
  String get chatHistoryDescription =>
      'Tu conversación con el Maestro del Tarot';

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
