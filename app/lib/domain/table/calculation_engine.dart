import 'package:pool_calculator/domain/coordinates/table_coordinate.dart';
import 'package:pool_calculator/domain/table/angle_calculator.dart';

import '../coordinates/screen_coordinate.dart';

class CalculationEngine {
  const CalculationEngine._();

  static (String angleText, String fractionText) computeAngleAndFractionTexts({
    required ScreenCoordinate? cue,
    required ScreenCoordinate? object,
    required ScreenCoordinate? pocket,
    required double ballRadius,
  }) {
    if (cue == null || object == null || pocket == null) {
      return ('Missing cue, object, or pocket selection', '');
    }

    final result = AngleCalculator.calculate(
      cueBall: cue,
      objectBall: object,
      pocket: pocket,
      ballRadius: ballRadius,
    );

    final fractionPercent = (result.hitFraction.clamp(0.0, 1.0)) * 100;

    return (
      '${result.angleDegrees.toStringAsFixed(2)}°',
      '${fractionPercent.toStringAsFixed(2)}%',
    );
  }
}

