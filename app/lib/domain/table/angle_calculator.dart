import 'dart:math';

import '../coordinates/screen_coordinate.dart';

class AngleCalculationResult {
  final double angleRadians;
  final double angleDegrees;
  final double hitFraction;
  final double sarthakFraction;
  final ScreenCoordinate ghostBallCenter;
  final ScreenCoordinate ghostBallAdjustedCenter;

  const AngleCalculationResult({
    required this.angleRadians,
    required this.angleDegrees,
    required this.hitFraction,
    required this.sarthakFraction,
    required this.ghostBallCenter,
    required this.ghostBallAdjustedCenter,
  });
}

class AngleCalculator {
  const AngleCalculator._();

  static const double k = 0.5;

  static AngleCalculationResult calculate({
    required ScreenCoordinate cueBall,
    required ScreenCoordinate objectBall,
    required ScreenCoordinate target,
    required double ballRadiusPixels,
    double friction = 0.0,
    double cueBallSpeed = 0.0,
  }) {
    final vCO = objectBall - cueBall;
    final vOT = target - objectBall;

    final magCO = vCO.magnitude;
    final magOT = vOT.magnitude;

    if (magCO == 0 || magOT == 0) {
      return AngleCalculationResult(
        angleRadians: 0,
        angleDegrees: 0,
        hitFraction: 0,
        sarthakFraction: 0,
        ghostBallCenter: ScreenCoordinate(objectBall.x, objectBall.y),
        ghostBallAdjustedCenter: ScreenCoordinate(objectBall.x, objectBall.y),
      );
    }

    final vCOUnit = vCO.normalized();
    final vOTUnit = vOT.normalized();

    final dot = vCOUnit.dot(vOTUnit);
    var cosTheta = dot;
    if (cosTheta > 1) cosTheta = 1;
    if (cosTheta < -1) cosTheta = -1;

    final angleRadians = acos(cosTheta);
    final angleDegrees = angleRadians * 180 / pi;

    final ballDiameter = ballRadiusPixels * 2;
    final vTOUnit = ScreenCoordinate(-vOTUnit.x, -vOTUnit.y);

    final double throwAngle = atan(friction * sin(angleRadians)) / (1 + k * cueBallSpeed);

    final cross = vCO.x * vOT.y - vCO.y * vOT.x;
    final cutSign = cross < 0 ? 1.0 : (cross > 0 ? -1.0 : 0.0);
    final compensationAngle = -cutSign * throwAngle;

    final cosComp = cos(compensationAngle);
    final sinComp = sin(compensationAngle);
    final adjustedTOUnit = ScreenCoordinate(
      vTOUnit.x * cosComp - vTOUnit.y * sinComp,
      vTOUnit.x * sinComp + vTOUnit.y * cosComp,
    );

    final ghostBallAdjustedCenter = ScreenCoordinate(
      objectBall.x + adjustedTOUnit.x * ballDiameter,
      objectBall.y + adjustedTOUnit.y * ballDiameter,
    );

    final ghostBallCenter = ScreenCoordinate(
      objectBall.x + vTOUnit.x * ballDiameter,
      objectBall.y + vTOUnit.y * ballDiameter,
    );

    final hitFraction = 1 - sin(angleRadians + compensationAngle.abs());
    double sarthakFraction = calculateSarthakFraction(ghostBallAdjustedCenter, cueBall, objectBall, ballRadiusPixels);

    return AngleCalculationResult(
      angleRadians: angleRadians,
      angleDegrees: angleDegrees,
      hitFraction: hitFraction,
      sarthakFraction: sarthakFraction,
      ghostBallCenter: ghostBallCenter,
      ghostBallAdjustedCenter: ghostBallAdjustedCenter,
    );
  }

  static double calculateSarthakFraction(ScreenCoordinate ghostBallCenter, ScreenCoordinate cueBall, ScreenCoordinate objectBall, double ballRadiusPixels) {

    final vCG = ghostBallCenter - cueBall;
    final vOG = ghostBallCenter - objectBall;

    // left perpendicular to vCG
    var vPerpendicularDirection = ScreenCoordinate(vCG.y, -vCG.x).normalized().dot(vOG);
    final sarthakFraction = vPerpendicularDirection.sign * (1 - (vPerpendicularDirection.abs() / (ballRadiusPixels * 2)));
    return sarthakFraction;
  }
}
