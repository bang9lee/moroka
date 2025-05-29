class AppAssets {
  // Images
  static const String imagesPath = 'assets/images';
  static const String cardsPath = '$imagesPath/cards';
  static const String backgroundsPath = '$imagesPath/backgrounds';
  static const String iconsPath = '$imagesPath/icons';
  
  // Card Images (Major Arcana)
  static const String cardFool = '$cardsPath/00_fool.png';
  static const String cardMagician = '$cardsPath/01_magician.png';
  static const String cardHighPriestess = '$cardsPath/02_high_priestess.png';
  static const String cardEmpress = '$cardsPath/03_empress.png';
  static const String cardEmperor = '$cardsPath/04_emperor.png';
  static const String cardHierophant = '$cardsPath/05_hierophant.png';
  static const String cardLovers = '$cardsPath/06_lovers.png';
  static const String cardChariot = '$cardsPath/07_chariot.png';
  static const String cardStrength = '$cardsPath/08_strength.png';
  static const String cardHermit = '$cardsPath/09_hermit.png';
  static const String cardWheelOfFortune = '$cardsPath/10_wheel.png';
  static const String cardJustice = '$cardsPath/11_justice.png';
  static const String cardHangedMan = '$cardsPath/12_hanged.png';
  static const String cardDeath = '$cardsPath/13_death.png';
  static const String cardTemperance = '$cardsPath/14_temperance.png';
  static const String cardDevil = '$cardsPath/15_devil.png';
  static const String cardTower = '$cardsPath/16_tower.png';
  static const String cardStar = '$cardsPath/17_star.png';
  static const String cardMoon = '$cardsPath/18_moon.png';
  static const String cardSun = '$cardsPath/19_sun.png';
  static const String cardJudgement = '$cardsPath/20_judgement.png';
  static const String cardWorld = '$cardsPath/21_world.png';
  
  // Card Pattern
  static const String cardPattern = '$imagesPath/card_pattern.png';
  
  // Backgrounds
  static const String backgroundDark = '$backgroundsPath/dark_bg.png';
  static const String backgroundMystic = '$backgroundsPath/mystic_bg.png';
  static const String backgroundStars = '$backgroundsPath/stars_bg.png';
  
  // Icons
  static const String iconEye = '$iconsPath/eye_icon.png';
  static const String iconMoon = '$iconsPath/moon_icon.png';
  static const String iconStar = '$iconsPath/star_icon.png';
  static const String iconSkull = '$iconsPath/skull_icon.png';
  
  // Animations (Lottie)
  static const String animationsPath = 'assets/animations';
  static const String animationLoading = '$animationsPath/loading.json';
  static const String animationShuffling = '$animationsPath/shuffling.json';
  static const String animationReveal = '$animationsPath/reveal.json';
  static const String animationGlow = '$animationsPath/glow.json';
  
  // Fonts
  static const String fontsPath = 'assets/fonts';
  
  // Get card image by index
  static String getCardImage(int index) {
    final cardImages = [
      cardFool,
      cardMagician,
      cardHighPriestess,
      cardEmpress,
      cardEmperor,
      cardHierophant,
      cardLovers,
      cardChariot,
      cardStrength,
      cardHermit,
      cardWheelOfFortune,
      cardJustice,
      cardHangedMan,
      cardDeath,
      cardTemperance,
      cardDevil,
      cardTower,
      cardStar,
      cardMoon,
      cardSun,
      cardJudgement,
      cardWorld,
    ];
    
    if (index >= 0 && index < cardImages.length) {
      return cardImages[index];
    }
    return cardFool; // Default
  }
}