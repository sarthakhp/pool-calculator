import 'package:pool_calculator/domain/table/angle_calculator.dart';

import '../coordinates/screen_coordinate.dart';

class CalculationEngine {
  const CalculationEngine._();

  static (String angleText, String fractionText, String sarthakFractionText, ScreenCoordinate? ghostBallCenter) computeAngleAndFractionTexts({
    required ScreenCoordinate? cue,
    required ScreenCoordinate? object,
    required ScreenCoordinate? pocket,
    required double ballRadiusPixels,
  }) {
    if (cue == null || object == null || pocket == null) {
      return ('Missing cue, object, or pocket selection', '', '', null);
    }

    final result = AngleCalculator.calculate(
      cueBall: cue,
      objectBall: object,
      pocket: pocket,
      ballRadiusPixels: ballRadiusPixels,
    );

    final fractionPercent = (result.hitFraction.clamp(0.0, 1.0)) * 100;
    final sarthakFractionPercent = (result.sarthakFraction.clamp(0.0, 1.0)) * 100;

    return (
      '${result.angleDegrees.toStringAsFixed(2)}°',
      '${fractionPercent.toStringAsFixed(2)}%',
      '${sarthakFractionPercent.toStringAsFixed(2)}%',
      result.ghostBallCenter,
    );
  }
}

