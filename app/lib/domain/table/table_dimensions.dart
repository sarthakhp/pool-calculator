class TableDimensions {
  final double lengthInches;
  final double widthInches;
  final double ballDiameterInches;
  final double borderThicknessInches;

  const TableDimensions({
    required this.lengthInches,
    required this.widthInches,
    required this.ballDiameterInches,
    required this.borderThicknessInches,
  });

  static const TableDimensions standard = TableDimensions(
    lengthInches: 92.0,
    widthInches: 46.0,
    ballDiameterInches: 2.25,
    borderThicknessInches: 2.0,
  );

  TableDimensions copyWith({
    double? lengthInches,
    double? widthInches,
    double? ballDiameterInches,
    double? borderThicknessInches,
  }) {
    return TableDimensions(
      lengthInches: lengthInches ?? this.lengthInches,
      widthInches: widthInches ?? this.widthInches,
      ballDiameterInches: ballDiameterInches ?? this.ballDiameterInches,
      borderThicknessInches: borderThicknessInches ?? this.borderThicknessInches,
    );
  }

  double get aspectRatio => 2;

  double get ballRadiusInches => ballDiameterInches / 2;

  double get ballRadiusNormalized => ballRadiusInches / lengthInches;

  double get ballDiameterNormalized => ballDiameterInches / lengthInches;

  double get ballRadiusNormalizedY => ballRadiusInches / widthInches;

  double get minBallX => ballRadiusNormalized;
  double get maxBallX => 1.0 - ballRadiusNormalized;
  double get minBallY => ballRadiusNormalizedY;
  double get maxBallY => 1.0 - ballRadiusNormalizedY;

  double get borderThicknessNormalized => borderThicknessInches / lengthInches;

  double inchesToNormalizedX(double inches) => inches / lengthInches;
  double inchesToNormalizedY(double inches) => inches / widthInches;

  double normalizedXToInches(double normalized) => normalized * lengthInches;
  double normalizedYToInches(double normalized) => normalized * widthInches;

  @override
  String toString() =>
      'TableDimensions(length: $lengthInches", width: $widthInches", ball: $ballDiameterInches")';
}

