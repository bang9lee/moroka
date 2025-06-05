// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Moroka';

  @override
  String get appTagline => 'Oracle des Ombres';

  @override
  String get appTitle => 'Moroka - Murmures Sinistres';

  @override
  String get onboardingTitle1 => 'La Porte du Destin s\'Ouvre';

  @override
  String get onboardingDesc1 =>
      'La sagesse ancienne rencontre la technologie moderne\npour murmurer votre avenir';

  @override
  String get onboardingTitle2 => 'Vérité dans les Ténèbres';

  @override
  String get onboardingDesc2 =>
      'Les cartes de tarot ne mentent jamais\nElles ne montrent que la vérité que vous pouvez supporter';

  @override
  String get onboardingTitle3 => 'L\'IA Lit Votre Destin';

  @override
  String get onboardingDesc3 =>
      'L\'intelligence artificielle interprète vos cartes\net guide votre chemin à travers des conversations profondes';

  @override
  String get onboardingTitle4 => 'Êtes-vous Prêt?';

  @override
  String get onboardingDesc4 =>
      'Chaque choix a son prix\nSi vous êtes prêt à affronter votre destin...';

  @override
  String get loginTitle => 'Vous Êtes de Retour';

  @override
  String get loginSubtitle => 'Nous vous attendions';

  @override
  String get signupTitle => 'Contrat du Destin';

  @override
  String get signupSubtitle => 'Enregistrez votre âme';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get nameLabel => 'Nom';

  @override
  String get loginButton => 'Entrer';

  @override
  String get signupButton => 'Enregistrer l\'Âme';

  @override
  String get googleLogin => 'Connexion avec Google';

  @override
  String get googleSignup => 'Commencer avec Google';

  @override
  String get alreadyHaveAccount => 'Déjà un compte? Connectez-vous';

  @override
  String get dontHaveAccount => 'Première fois? Inscrivez-vous';

  @override
  String get moodQuestion => 'Comment vous sentez-vous maintenant?';

  @override
  String get selectSpreadButton => 'Sélectionner un Tirage de Tarot';

  @override
  String get moodAnxious => 'Anxieux';

  @override
  String get moodLonely => 'Seul';

  @override
  String get moodCurious => 'Curieux';

  @override
  String get moodFearful => 'Craintif';

  @override
  String get moodHopeful => 'Plein d\'espoir';

  @override
  String get moodConfused => 'Confus';

  @override
  String get moodDesperate => 'Désespéré';

  @override
  String get moodExpectant => 'Dans l\'attente';

  @override
  String get moodMystical => 'Mystique';

  @override
  String get spreadSelectionTitle => 'Sélectionner un Tirage';

  @override
  String get spreadSelectionSubtitle =>
      'Choisissez un tirage basé sur vos sentiments actuels';

  @override
  String get spreadDifficultyBeginner => '1-3 cartes';

  @override
  String get spreadDifficultyIntermediate => '5-7 cartes';

  @override
  String get spreadDifficultyAdvanced => '10 cartes';

  @override
  String get spreadOneCard => 'Une Carte';

  @override
  String get spreadThreeCard => 'Trois Cartes';

  @override
  String get spreadCelticCross => 'Croix Celtique';

  @override
  String get spreadRelationship => 'Tirage Relationnel';

  @override
  String get spreadYesNo => 'Oui/Non';

  @override
  String get selectCardTitle => 'Sélectionnez les cartes du destin';

  @override
  String get currentMoodLabel => 'Votre humeur actuelle: ';

  @override
  String get currentSpreadLabel => 'Tirage sélectionné: ';

  @override
  String get shufflingMessage => 'Les fils du destin s\'entrelacent...';

  @override
  String get selectCardInstruction =>
      'Suivez votre intuition et sélectionnez les cartes';

  @override
  String cardsSelected(int count) {
    return '$count sélectionnées';
  }

  @override
  String cardsRemaining(int count) {
    return 'Sélectionnez $count de plus';
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
  String get typeMessageHint => 'Tapez un message...';

  @override
  String get continueReading => 'Obtenir des conseils plus profonds';

  @override
  String get watchAdPrompt =>
      'Pour entendre la voix des abysses plus profondes,\nvous devez vérifier les messages d\'un autre monde.';

  @override
  String get interpretingSpread => 'Interprétation des messages des cartes...';

  @override
  String get menuHistory => 'Historique des Tirages';

  @override
  String get menuHistoryDesc => 'Revoyez vos destins passés';

  @override
  String get menuStatistics => 'Statistiques et Analyses';

  @override
  String get menuStatisticsDesc => 'Analysez vos schémas de destin';

  @override
  String get menuSettings => 'Paramètres';

  @override
  String get menuSettingsDesc => 'Ajuster l\'environnement de l\'application';

  @override
  String get menuAbout => 'À propos';

  @override
  String get menuAboutDesc => 'Moroka - Oracle des Ombres';

  @override
  String get logoutButton => 'Déconnexion';

  @override
  String get logoutTitle => 'Partez-vous vraiment?';

  @override
  String get logoutMessage =>
      'Quand la porte du destin se ferme\nvous devrez revenir à nouveau';

  @override
  String get logoutCancel => 'Rester';

  @override
  String get logoutConfirm => 'Partir';

  @override
  String get errorOccurred => 'Une erreur s\'est produite';

  @override
  String get errorEmailEmpty => 'Veuillez entrer votre email';

  @override
  String get errorEmailInvalid => 'Format d\'email invalide';

  @override
  String get errorPasswordEmpty => 'Veuillez entrer votre mot de passe';

  @override
  String get errorPasswordShort =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get errorNameEmpty => 'Veuillez entrer votre nom';

  @override
  String get errorLoginFailed => 'Échec de la connexion';

  @override
  String get errorSignupFailed => 'Échec de l\'inscription';

  @override
  String get errorGoogleLoginFailed => 'Échec de la connexion Google';

  @override
  String get errorNetworkFailed => 'Veuillez vérifier votre connexion réseau';

  @override
  String get errorNotEnoughCards => 'Veuillez sélectionner plus de cartes';

  @override
  String get successLogin => 'Bienvenue';

  @override
  String get successSignup => 'Votre âme a été enregistrée';

  @override
  String get successLogout => 'Au revoir';

  @override
  String get successCardsSelected => 'Toutes les cartes ont été sélectionnées';

  @override
  String get settingsLanguageTitle => 'Langue';

  @override
  String get settingsLanguageLabel => 'Langue de l\'Application';

  @override
  String get settingsLanguageDesc => 'Sélectionnez votre langue préférée';

  @override
  String get settingsNotificationTitle => 'Paramètres de Notification';

  @override
  String get settingsDailyNotification => 'Notification de Tarot Quotidienne';

  @override
  String get settingsDailyNotificationDesc =>
      'Recevez votre fortune quotidienne chaque matin';

  @override
  String get settingsWeeklyReport => 'Rapport de Tarot Hebdomadaire';

  @override
  String get settingsWeeklyReportDesc =>
      'Recevez votre fortune hebdomadaire chaque lundi';

  @override
  String get settingsDisplayTitle => 'Paramètres d\'Affichage';

  @override
  String get settingsVibration => 'Effets de Vibration';

  @override
  String get settingsVibrationDesc =>
      'Retour vibratoire lors de la sélection des cartes';

  @override
  String get settingsAnimations => 'Effets d\'Animation';

  @override
  String get settingsAnimationsDesc => 'Animations de transition d\'écran';

  @override
  String get settingsDataTitle => 'Gestion des Données';

  @override
  String get settingsBackupData => 'Sauvegarde des Données';

  @override
  String get settingsBackupDataDesc => 'Sauvegardez vos données dans le cloud';

  @override
  String get settingsClearCache => 'Vider le Cache';

  @override
  String get settingsClearCacheDesc =>
      'Supprimer les fichiers temporaires pour libérer de l\'espace';

  @override
  String get settingsDeleteData => 'Supprimer Toutes les Données';

  @override
  String get settingsDeleteDataDesc =>
      'Supprimer tous les enregistrements de tarot et les paramètres';

  @override
  String get settingsAccountTitle => 'Compte';

  @override
  String get settingsChangePassword => 'Changer le Mot de Passe';

  @override
  String get settingsChangePasswordDesc =>
      'Modifiez votre mot de passe pour la sécurité du compte';

  @override
  String get settingsDeleteAccount => 'Supprimer le Compte';

  @override
  String get settingsDeleteAccountDesc =>
      'Supprimer définitivement votre compte';

  @override
  String get dialogBackupTitle => 'Sauvegarde des Données';

  @override
  String get dialogBackupMessage => 'Sauvegarder vos données dans le cloud?';

  @override
  String get dialogClearCacheTitle => 'Vider le Cache';

  @override
  String get dialogClearCacheMessage => 'Supprimer les fichiers temporaires?';

  @override
  String get dialogDeleteDataTitle => 'Supprimer Toutes les Données';

  @override
  String get dialogDeleteDataMessage =>
      'Tous les enregistrements de tarot et les paramètres seront définitivement supprimés.\nCette action ne peut pas être annulée.';

  @override
  String get dialogChangePasswordTitle => 'Changer le Mot de Passe';

  @override
  String get dialogDeleteAccountTitle => 'Supprimer le Compte';

  @override
  String get dialogDeleteAccountMessage =>
      'La suppression de votre compte entraînera la suppression définitive de toutes les données.\nCette action ne peut pas être annulée.';

  @override
  String get currentPassword => 'Mot de Passe Actuel';

  @override
  String get newPassword => 'Nouveau Mot de Passe';

  @override
  String get confirmNewPassword => 'Confirmer le Nouveau Mot de Passe';

  @override
  String get cancel => 'Annuler';

  @override
  String get backup => 'Sauvegarder';

  @override
  String get delete => 'Supprimer';

  @override
  String get change => 'Modifier';

  @override
  String get successBackup => 'Sauvegarde terminée';

  @override
  String get successClearCache => 'Cache vidé';

  @override
  String get successDeleteData => 'Toutes les données supprimées';

  @override
  String get successChangePassword => 'Mot de passe modifié';

  @override
  String get successDeleteAccount => 'Compte supprimé';

  @override
  String errorBackup(String error) {
    return 'Échec de la sauvegarde: $error';
  }

  @override
  String errorDeleteData(String error) {
    return 'Échec de la suppression: $error';
  }

  @override
  String errorChangePassword(String error) {
    return 'Échec du changement de mot de passe: $error';
  }

  @override
  String errorDeleteAccount(String error) {
    return 'Échec de la suppression du compte: $error';
  }

  @override
  String get errorPasswordMismatch =>
      'Les nouveaux mots de passe ne correspondent pas';

  @override
  String get passwordResetTitle => 'Réinitialiser le Mot de Passe';

  @override
  String get passwordResetMessage =>
      'Entrez votre adresse email enregistrée.\nNous vous enverrons un lien de réinitialisation du mot de passe.';

  @override
  String get passwordResetSuccess =>
      'Email de réinitialisation du mot de passe envoyé';

  @override
  String get send => 'Envoyer';

  @override
  String get emailPlaceholder => 'votre@email.com';

  @override
  String get passwordPlaceholder => '6+ caractères';

  @override
  String get forgotPassword => 'Mot de passe oublié?';

  @override
  String get login => 'Connexion';

  @override
  String get or => 'ou';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get noAccount => 'Pas de compte?';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get appBrandName => 'MOROKA';

  @override
  String get appBrandTagline => 'oracle des ombres';

  @override
  String get aboutTitle => 'À propos';

  @override
  String get aboutSubtitle => 'Les cartes du destin vous attendent';

  @override
  String get aboutDescription =>
      'MOROKA\n\nLa porte du destin s\'est ouverte\nL\'oracle des ombres interprétera votre avenir\n\nInterprétation traditionnelle du tarot avec l\'IA mystique\nOffrant des aperçus profonds et de la sagesse';

  @override
  String get featuresTitle => 'Fonctionnalités Principales';

  @override
  String get feature78Cards => '78 Cartes de Tarot Traditionnelles';

  @override
  String get feature78CardsDesc =>
      'Jeu complet avec 22 Arcanes Majeurs et 56 Arcanes Mineurs';

  @override
  String get feature5Spreads => '5 Tirages Professionnels';

  @override
  String get feature5SpreadsDesc =>
      'Diverses méthodes de lecture d\'Une Carte à la Croix Celtique';

  @override
  String get featureAI => 'Maître de Tarot IA';

  @override
  String get featureAIDesc =>
      'Interprétations profondes comme un maître de tarot avec 100 ans d\'expérience';

  @override
  String get featureChat => 'Consultation Interactive';

  @override
  String get featureChatDesc => 'Posez librement des questions sur vos cartes';

  @override
  String get termsAndPolicies => 'Conditions et Politiques';

  @override
  String get termsOfService => 'Conditions d\'Utilisation';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get marketingConsent => 'Informations Marketing';

  @override
  String get customerSupport => 'Support Client';

  @override
  String get emailSupport => 'Support par Email';

  @override
  String get website => 'Site Web';

  @override
  String cannotOpenUrl(String url) {
    return 'Impossible d\'ouvrir l\'URL: $url';
  }

  @override
  String get lastModified => 'Dernière modification: 3 juillet 2025';

  @override
  String get confirm => 'Confirmer';

  @override
  String get companyName => 'Today\'s Studio';

  @override
  String get companyTagline => 'Créer des expériences mystiques';

  @override
  String get copyright => '© 2025 Today\'s Studio. Tous droits réservés.';

  @override
  String get anonymousSoul => 'Âme Anonyme';

  @override
  String get totalReadings => 'Total des Lectures';

  @override
  String get joinDate => 'Date d\'Inscription';

  @override
  String get errorLogout => 'Erreur survenue lors de la déconnexion';

  @override
  String get soulContract => 'Contrat de l\'Âme';

  @override
  String get termsAgreementMessage =>
      'Veuillez accepter les conditions pour utiliser le service';

  @override
  String get agreeAll => 'Tout Accepter';

  @override
  String get required => 'Obligatoire';

  @override
  String get optional => 'Optionnel';

  @override
  String get agreeAndStart => 'Accepter et Commencer';

  @override
  String get agreeToRequired => 'Veuillez accepter les conditions obligatoires';

  @override
  String get nickname => 'Pseudonyme';

  @override
  String get confirmPassword => 'Confirmer le Mot de Passe';

  @override
  String get nextStep => 'Étape Suivante';

  @override
  String get errorNameTooShort => 'Entrez au moins 2 caractères';

  @override
  String get errorConfirmPassword => 'Veuillez confirmer votre mot de passe';

  @override
  String get errorPasswordsDontMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get emailInUse => 'Email déjà utilisé';

  @override
  String get emailAvailable => 'Email disponible';

  @override
  String get nicknameInUse => 'Pseudonyme déjà utilisé';

  @override
  String get nicknameAvailable => 'Pseudonyme disponible';

  @override
  String get passwordWeak => 'Faible';

  @override
  String get passwordFair => 'Moyen';

  @override
  String get passwordStrong => 'Fort';

  @override
  String get passwordVeryStrong => 'Très Fort';

  @override
  String get emailVerificationTitle => 'Vérification de l\'Email';

  @override
  String emailVerificationMessage(String email) {
    return 'Nous avons envoyé un email de vérification à $email.\nVeuillez vérifier votre email et cliquer sur le lien de vérification.';
  }

  @override
  String get resendEmail => 'Renvoyer l\'Email';

  @override
  String get emailResent => 'Email de vérification renvoyé';

  @override
  String get checkEmailAndReturn =>
      'Après vérification, veuillez revenir à l\'application';

  @override
  String get noHistoryTitle => 'Pas encore d\'enregistrements de tarot';

  @override
  String get noHistoryMessage => 'Lisez votre premier destin';

  @override
  String get startReading => 'Commencer la Lecture du Tarot';

  @override
  String get deleteReadingTitle => 'Supprimer cet enregistrement?';

  @override
  String get deleteReadingMessage =>
      'Les enregistrements supprimés ne peuvent pas être récupérés';

  @override
  String get cardOfFate => 'Carte du Destin';

  @override
  String get cardCallingYou => 'Cette carte vous appelle';

  @override
  String get selectThisCard => 'Voulez-vous la sélectionner?';

  @override
  String get viewAgain => 'Revoir';

  @override
  String get select => 'Sélectionner';

  @override
  String get shufflingCards => 'Mélange des cartes du destin...';

  @override
  String get selectCardsIntuition =>
      'Suivez votre intuition et sélectionnez les cartes';

  @override
  String selectMoreCards(int count) {
    return 'Sélectionnez $count cartes de plus';
  }

  @override
  String get selectionComplete => 'Sélection terminée!';

  @override
  String get tapToSelect => 'Touchez une carte pour la sélectionner';

  @override
  String get preparingInterpretation => 'Préparation de l\'interprétation...';

  @override
  String get cardMessage => 'Message des Cartes';

  @override
  String get cardsStory => 'L\'Histoire que Racontent Vos Cartes';

  @override
  String get specialInterpretation => 'Une Interprétation Spéciale pour Vous';

  @override
  String get interpretingCards =>
      'Interprétation de la signification des cartes...';

  @override
  String get todaysChatEnded => 'La conversation d\'aujourd\'hui est terminée';

  @override
  String get askQuestions => 'Posez vos questions...';

  @override
  String get continueConversation => 'Continuer la Conversation';

  @override
  String get wantDeeperTruth =>
      'Voulez-vous connaître des vérités plus profondes?';

  @override
  String get watchAdToContinue =>
      'Regardez une publicité pour continuer\nvotre conversation avec le Maître du Tarot';

  @override
  String get later => 'Plus tard';

  @override
  String get watchAd => 'Regarder la Publicité';

  @override
  String get emailVerification => 'Vérification de l\'Email';

  @override
  String get checkYourEmail => 'Vérifiez votre email';

  @override
  String get verificationEmailSent =>
      'Nous avons envoyé un email de vérification à l\'adresse ci-dessus.\nVeuillez vérifier votre boîte de réception et cliquer sur le lien de vérification.';

  @override
  String get verifyingEmail => 'Vérification de l\'email...';

  @override
  String get noEmailReceived => 'Vous n\'avez pas reçu l\'email?';

  @override
  String get checkSpamFolder =>
      'Vérifiez votre dossier spam.\nS\'il n\'y est toujours pas, cliquez sur le bouton ci-dessous pour renvoyer.';

  @override
  String resendIn(int seconds) {
    return 'Renvoyer dans ${seconds}s';
  }

  @override
  String get resendVerificationEmail => 'Renvoyer l\'Email de Vérification';

  @override
  String get alreadyVerified => 'J\'ai déjà vérifié';

  @override
  String get openGateOfFate => 'Ouvrir la Porte du Destin';

  @override
  String get skip => 'PASSER';

  @override
  String get willYouSelectIt => 'Allez-vous la sélectionner ?';

  @override
  String get selectCardByHeart => 'Sélectionnez la carte qui attire votre cœur';

  @override
  String moreToSelect(int count) {
    return '$count encore à sélectionner';
  }

  @override
  String get tapToSelectCard => 'Touchez la carte pour sélectionner';

  @override
  String get currentSituation => 'Situation actuelle';

  @override
  String get practicalAdvice => 'Conseils pratiques';

  @override
  String get futureForecast => 'Prévisions futures';

  @override
  String get overallFlow => 'Flux général';

  @override
  String get timeBasedInterpretation => 'Interprétation temporelle';

  @override
  String get pastInfluence => 'Influence du passé';

  @override
  String get upcomingFuture => 'Futur proche';

  @override
  String get actionGuidelines => 'Lignes directrices d\'action';

  @override
  String get coreAdvice => 'Conseil principal';

  @override
  String get coreSituationAnalysis => 'Analyse de la situation centrale';

  @override
  String get innerConflict => 'Conflit intérieur';

  @override
  String get timelineAnalysis => 'Analyse chronologique';

  @override
  String get externalFactors => 'Facteurs externes';

  @override
  String get finalForecast => 'Prévision finale';

  @override
  String get stepByStepPlan => 'Plan étape par étape';

  @override
  String get twoPersonEnergy => 'Énergie à deux';

  @override
  String get heartTemperatureDifference => 'Différence de température du cœur';

  @override
  String get relationshipObstacles => 'Obstacles relationnels';

  @override
  String get futurePossibility => 'Possibilité future';

  @override
  String get adviceForLove => 'Conseils pour l\'amour';

  @override
  String get oneLineAdvice => 'Conseil en une ligne';

  @override
  String get judgmentBasis => 'Base de jugement';

  @override
  String get coreMessage => 'Message principal';

  @override
  String get successConditions => 'Conditions de succès';

  @override
  String get timingPrediction => 'Prédiction temporelle';

  @override
  String get actionGuide => 'Guide d\'action';

  @override
  String get future => 'Futur';

  @override
  String get advice => 'Conseil';

  @override
  String get message => 'Message';

  @override
  String get meaning => 'Signification';

  @override
  String get interpretation => 'Interprétation';

  @override
  String get overallMeaning => 'Signification globale';

  @override
  String get comprehensiveInterpretation => 'Interprétation complète';

  @override
  String get futureAdvice => 'Conseils pour l\'avenir';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get conditionalYes => 'Oui conditionnel';

  @override
  String get analyzingDestiny => 'Analyse de votre destin...';

  @override
  String get noDataToAnalyze => 'Aucune donnée à analyser pour le moment';

  @override
  String get startTarotReading => 'Commencez votre lecture de tarot';

  @override
  String get totalTarotReadings => 'Total des lectures de tarot';

  @override
  String get mostFrequentCard => 'Carte la plus fréquente';

  @override
  String get cardFrequencyTop5 => 'Fréquence des cartes TOP 5';

  @override
  String get moodAnalysis => 'Analyse des lectures par humeur';

  @override
  String get monthlyReadingTrend => 'Tendance mensuelle des lectures';

  @override
  String get noData => 'Aucune donnée disponible';

  @override
  String timesCount(int count) {
    return '$count fois';
  }

  @override
  String monthLabel(String month) {
    return '$month';
  }

  @override
  String get remainingDraws => 'Tirages restants';

  @override
  String get noDrawsRemaining => 'Aucun tirage restant';

  @override
  String get adDraws => 'Pub';

  @override
  String get dailyLimitReached => 'Limite quotidienne atteinte';

  @override
  String get watchAdForMore =>
      'Regardez une publicité pour obtenir plus de tirages de cartes. Vous pouvez obtenir jusqu\'à 10 tirages supplémentaires par jour.';

  @override
  String get drawAddedMessage => '1 tirage ajouté ! ✨';

  @override
  String get adLoadFailed =>
      'Échec du chargement de la publicité. Veuillez réessayer plus tard.';

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
      'Demandez-moi n\'importe quoi sur votre tirage de tarot';

  @override
  String get chatHistory => 'Historique du Chat';

  @override
  String get chatHistoryDescription =>
      'Votre conversation avec le Maître du Tarot';

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
