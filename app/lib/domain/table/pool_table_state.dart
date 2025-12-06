import 'package:pool_calculator/domain/ball/ball.dart';
import 'package:pool_calculator/domain/ball/ball_type.dart';
import 'package:pool_calculator/domain/coordinates/table_coordinate.dart';
import 'package:pool_calculator/domain/table/table_dimensions.dart';

class PoolTableState {
  TableDimensions dimensions;
  final Map<String, Ball> _balls = {};

  PoolTableState({
    this.dimensions = TableDimensions.standard,
  });

  void updateBallDiameter(double diameterInches) {
    dimensions = dimensions.copyWith(ballDiameterInches: diameterInches);
  }

  void updateBorderThickness(double thicknessInches) {
    dimensions = dimensions.copyWith(borderThicknessInches: thicknessInches);
  }

  static const TableCoordinate defaultCueBallPosition = TableCoordinate(0.25, 0.5);
  static const TableCoordinate defaultObjectBallPosition = TableCoordinate(0.75, 0.5);

  void addBall(Ball ball) {
    _balls[ball.id] = ball;
  }

  void removeBall(String ballId) {
    _balls.remove(ballId);
  }

  Ball? getBall(String ballId) => _balls[ballId];

  Ball? get cueBall => _balls['cue'];

  List<Ball> get allBalls => _balls.values.toList();

  List<Ball> get objectBalls =>
      _balls.values.where((b) => b.type != BallType.cue).toList();

  void moveBall(String ballId, TableCoordinate newPosition) {
    final ball = _balls[ballId];
    if (ball != null) {
      ball.moveTo(newPosition, dimensions);
    }
  }

  TableCoordinate? getBallCenter(String ballId) {
    return _balls[ballId]?.center;
  }

  double get ballRadiusNormalized => dimensions.ballRadiusNormalized;
  double get ballDiameterNormalized => dimensions.ballDiameterNormalized;
  double get ballRadiusNormalizedY => dimensions.ballRadiusNormalizedY;

  List<(Ball, Ball)> findCollisions() {
    final collisions = <(Ball, Ball)>[];
    final ballList = allBalls;

    for (var i = 0; i < ballList.length; i++) {
      for (var j = i + 1; j < ballList.length; j++) {
        if (ballList[i].isCollidingWith(ballList[j], dimensions)) {
          collisions.add((ballList[i], ballList[j]));
        }
      }
    }

    return collisions;
  }

  double distanceBetweenBalls(String ballId1, String ballId2) {
    final ball1 = _balls[ballId1];
    final ball2 = _balls[ballId2];
    if (ball1 == null || ball2 == null) return double.infinity;
    return ball1.position.distanceTo(ball2.position);
  }

  void initializeDefaultBalls() {
    addBall(Ball.cue(position: defaultCueBallPosition));
    addBall(Ball(
      id: 'object',
      type: BallType.solid,
      number: 1,
      position: defaultObjectBallPosition,
    ));
  }

  void resetToDefaults() {
    _balls.clear();
    initializeDefaultBalls();
  }
}
