import 'package:pool_calculator/domain/table/angle_calculator.dart';

import '../coordinates/screen_coordinate.dart';

class CalculationEngine {
  const CalculationEngine._();

  static (double? angleDegrees, double fraction, double sarthakFraction, ScreenCoordinate? ghostBallCenter) compute({
    required ScreenCoordinate? cue,
    required ScreenCoordinate? object,
    required ScreenCoordinate? pocket,
    required double ballRadiusPixels,
  }) {
    if (cue == null || object == null || pocket == null) {
      return (null, 0.0, 0.0, null);
    }

    final result = AngleCalculator.calculate(
      cueBall: cue,
      objectBall: object,
      pocket: pocket,
      ballRadiusPixels: ballRadiusPixels,
    );

    final fraction = result.hitFraction.clamp(0.0, 1.0);
    final sarthakFraction = result.sarthakFraction.clamp(-1.0, 1.0);

    return (
      result.angleDegrees,
      fraction,
      sarthakFraction,
      result.ghostBallCenter,
    );
  }
}

