import 'package:pool_calculator/domain/table/angle_calculator.dart';

import '../coordinates/screen_coordinate.dart';

class CalculationEngine {
  const CalculationEngine._();

  static (double? angleDegrees, double fraction, double sarthakFraction, ScreenCoordinate? ghostBallCenter, ScreenCoordinate? ghostBallAdjustedCenter) compute({
    required ScreenCoordinate? cue,
    required ScreenCoordinate? object,
    required ScreenCoordinate? target,
    required double ballRadiusPixels,
    required double cueBallSpeed,
    required double friction,
  }) {

    if (cue == null || object == null || target == null) {
      return (null, 0.0, 0.0, null, null);
    }

    final result = AngleCalculator.calculate(
      cueBall: cue,
      objectBall: object,
      target: target,
      ballRadiusPixels: ballRadiusPixels,
      friction: friction,
      cueBallSpeed: cueBallSpeed
    );

    final fraction = result.hitFraction.clamp(0.0, 1.0);
    final sarthakFraction = result.sarthakFraction.clamp(-1.0, 1.0);

    return (
      result.angleDegrees,
      fraction,
      sarthakFraction,
      result.ghostBallCenter,
      result.ghostBallAdjustedCenter
    );
  }
}

