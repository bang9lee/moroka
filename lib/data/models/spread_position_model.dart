import 'spread_position_localizations.dart';

class SpreadPosition {
  final int index;
  final String title;
  final String titleKr;
  final String description;
  final double x; // 0.0 ~ 1.0 (화면 비율)
  final double y; // 0.0 ~ 1.0 (화면 비율)
  final double rotation; // 회전 각도 (도)
  final String? spreadType; // 스프레드 타입 (localization을 위해)
  
  const SpreadPosition({
    required this.index,
    required this.title,
    required this.titleKr,
    required this.description,
    required this.x,
    required this.y,
    this.rotation = 0,
    this.spreadType,
  });
  
  // 현재 로케일에 따른 제목 반환
  String getLocalizedTitle(String locale) {
    switch (locale) {
      case 'ko':
        return titleKr;
      case 'en':
        return title;
      default:
        // Use SpreadPositionLocalizations for other languages
        if (spreadType != null) {
          return SpreadPositionLocalizations.getLocalizedPosition(
            spreadType!,
            title,
            locale,
          );
        }
        return title;
    }
  }
}