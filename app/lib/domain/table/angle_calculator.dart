import 'dart:math';

import 'package:pool_calculator/domain/coordinates/table_coordinate.dart';

class AngleCalculationResult {
  final double angleRadians;
  final double angleDegrees;
  final double hitFraction;

  const AngleCalculationResult({
    required this.angleRadians,
    required this.angleDegrees,
    required this.hitFraction,
  });
}

class AngleCalculator {
  const AngleCalculator._();

  static AngleCalculationResult calculate({
    required TableCoordinate cueBall,
    required TableCoordinate objectBall,
    required TableCoordinate pocket,
    required double ballRadius,
  }) {
    // Debug: print coordinates before calculation
    print('AngleCalculator.calculate -> cueBall: '
        '(${cueBall.x.toStringAsFixed(4)}, ${cueBall.y.toStringAsFixed(4)})');
    print('AngleCalculator.calculate -> objectBall: '
        '(${objectBall.x.toStringAsFixed(4)}, ${objectBall.y.toStringAsFixed(4)})');
    print('AngleCalculator.calculate -> pocket: '
        '(${pocket.x.toStringAsFixed(4)}, ${pocket.y.toStringAsFixed(4)})');

    final vCO = TableCoordinate(
      objectBall.x - cueBall.x,
      objectBall.y - cueBall.y,
    );
    final vOP = TableCoordinate(
      pocket.x - objectBall.x,
      pocket.y - objectBall.y,
    );

    final magCO = vCO.magnitude;
    final magOP = vOP.magnitude;

    if (magCO == 0 || magOP == 0) {
      return const AngleCalculationResult(
        angleRadians: 0,
        angleDegrees: 0,
        hitFraction: 0,
      );
    }

    final vCOUnit = TableCoordinate(vCO.x / magCO, vCO.y / magCO);
    final vOPUnit = TableCoordinate(vOP.x / magOP, vOP.y / magOP);

    print('AngleCalculator.calculate -> vector vCO: '
        '(${vCOUnit.x.toStringAsFixed(4)}, ${vCO.y.toStringAsFixed(4)})');

    print('AngleCalculator.calculate -> vector vOP: '
        '(${vOPUnit.x.toStringAsFixed(4)}, ${vOP.y.toStringAsFixed(4)})');

    final dot = (vCOUnit.x * vOPUnit.x) + (vCOUnit.y * vOPUnit.y);
    var cosTheta = dot;
    if (cosTheta > 1) cosTheta = 1;
    if (cosTheta < -1) cosTheta = -1;

    final angleRadians = acos(cosTheta);
    final angleDegrees = angleRadians * 180 / pi;

    final hitFraction = 1 - sin(angleRadians);

    return AngleCalculationResult(
      angleRadians: angleRadians,
      angleDegrees: angleDegrees,
      hitFraction: hitFraction,
    );
  }
}
