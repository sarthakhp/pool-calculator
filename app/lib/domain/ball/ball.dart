import 'package:pool_calculator/domain/ball/ball_type.dart';
import 'package:pool_calculator/domain/coordinates/table_coordinate.dart';
import 'package:pool_calculator/domain/table/table_dimensions.dart';

class Ball {
  final String id;
  final BallType type;
  final int? number;
  TableCoordinate position;

  Ball({
    required this.id,
    required this.type,
    required this.position,
    this.number,
  });

  factory Ball.cue({required TableCoordinate position}) {
    return Ball(
      id: 'cue',
      type: BallType.cue,
      position: position,
    );
  }

  factory Ball.solid({
    required int number,
    required TableCoordinate position,
  }) {
    return Ball(
      id: 'solid_$number',
      type: BallType.solid,
      number: number,
      position: position,
    );
  }

  factory Ball.stripe({
    required int number,
    required TableCoordinate position,
  }) {
    return Ball(
      id: 'stripe_$number',
      type: BallType.stripe,
      number: number,
      position: position,
    );
  }

  factory Ball.eight({required TableCoordinate position}) {
    return Ball(
      id: 'eight',
      type: BallType.eight,
      number: 8,
      position: position,
    );
  }

  factory Ball.ghost({required TableCoordinate position}) {
    return Ball(
      id: 'ghost',
      type: BallType.ghost,
      position: position,
    );
  }

  factory Ball.ghostAdjusted({required TableCoordinate position}) {
    return Ball(
      id: 'ghost_adjusted',
      type: BallType.ghost,
      position: position,
    );
  }

  TableCoordinate get center => position;

  double radiusNormalized(TableDimensions dimensions) {
    return dimensions.ballRadiusNormalized;
  }

  double diameterNormalized(TableDimensions dimensions) {
    return dimensions.ballDiameterNormalized;
  }

  double radiusInches(TableDimensions dimensions) {
    return dimensions.ballRadiusInches;
  }

  double diameterInches(TableDimensions dimensions) {
    return dimensions.ballDiameterInches;
  }

  void moveTo(TableCoordinate newPosition, TableDimensions dimensions) {

    double xMargin = 0, yMargin = 0;
    if (type == BallType.target) {
      xMargin = 0.07;
      yMargin = xMargin*2;
    }

    position = newPosition.clamp(
      dimensions.minBallX - xMargin,
      dimensions.maxBallX + xMargin,
      dimensions.minBallY - yMargin,
      dimensions.maxBallY + yMargin,
    );
  }

  @override
  String toString() => 'Ball($id, position: $position)';
}
