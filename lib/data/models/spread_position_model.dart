class SpreadPosition {
  final int index;
  final String title;
  final String titleKr;
  final String description;
  final double x; // 0.0 ~ 1.0 (화면 비율)
  final double y; // 0.0 ~ 1.0 (화면 비율)
  final double rotation; // 회전 각도 (도)
  
  const SpreadPosition({
    required this.index,
    required this.title,
    required this.titleKr,
    required this.description,
    required this.x,
    required this.y,
    this.rotation = 0,
  });
}