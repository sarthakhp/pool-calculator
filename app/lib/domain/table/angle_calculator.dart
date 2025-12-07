import 'dart:math';

import '../coordinates/screen_coordinate.dart';

class AngleCalculationResult {
  final double angleRadians;
  final double angleDegrees;
  final double hitFraction;
  final double sarthakFraction;
  final ScreenCoordinate ghostBallCenter;

  const AngleCalculationResult({
    required this.angleRadians,
    required this.angleDegrees,
    required this.hitFraction,
    required this.sarthakFraction,
    required this.ghostBallCenter,
  });
}

class AngleCalculator {
  const AngleCalculator._();

  static AngleCalculationResult calculate({
    required ScreenCoordinate cueBall,
    required ScreenCoordinate objectBall,
    required ScreenCoordinate target,
    required double ballRadiusPixels,
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

    final hitFraction = 1 - sin(angleRadians);

    // Ghost ball center: position along the line from pocket through object ball,
    // at a distance of one ball diameter (2 * radius) from the object ball center
    final ballDiameter = ballRadiusPixels * 2;
    final vTOUnit = ScreenCoordinate(-vOTUnit.x, -vOTUnit.y);
    final ghostBallCenter = ScreenCoordinate(
      objectBall.x + vTOUnit.x * ballDiameter,
      objectBall.y + vTOUnit.y * ballDiameter,
    );

    final vCG = ghostBallCenter - cueBall;
    final vOG = ghostBallCenter - objectBall;

    // left perpendicular to vCG
    var vPerpendicularDirection = ScreenCoordinate(vCG.y, -vCG.x).normalized().dot(vOG);
    final sarthakFraction = vPerpendicularDirection.sign * (1 - (vPerpendicularDirection.abs() / (ballRadiusPixels * 2)));

    return AngleCalculationResult(
      angleRadians: angleRadians,
      angleDegrees: angleDegrees,
      hitFraction: hitFraction,
      sarthakFraction: sarthakFraction,
      ghostBallCenter: ghostBallCenter,
    );
  }
}
