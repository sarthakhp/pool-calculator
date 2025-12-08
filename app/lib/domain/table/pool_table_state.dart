import 'package:pool_calculator/domain/ball/ball.dart';
import 'package:pool_calculator/domain/ball/ball_type.dart';
import 'package:pool_calculator/domain/coordinates/table_coordinate.dart';
import 'package:pool_calculator/domain/table/table_dimensions.dart';

class PoolTableState {
  TableDimensions dimensions;
  double cueBallSpeed = 0.0;
  double friction = 0.0;
  final Map<String, Ball> _balls = {};

  PoolTableState({
    this.dimensions = TableDimensions.standard,
  });

  void updateCueBallSpeed(double speed) {
    cueBallSpeed = speed;
  }

  void updateFriction(double friction) {
    this.friction = friction;
  }

  void updateBallDiameter(double diameterInches) {
    dimensions = dimensions.copyWith(ballDiameterInches: diameterInches);
  }

  void updateBorderThickness(double thicknessInches) {
    dimensions = dimensions.copyWith(borderThicknessInches: thicknessInches);
  }

  static const TableCoordinate defaultCueBallPosition = TableCoordinate(0.25, 0.5);
  static const TableCoordinate defaultObjectBallPosition = TableCoordinate(0.75, 0.5);
  static const TableCoordinate defaultTargetBallPosition = TableCoordinate(1, 1);

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

  void initializeDefaultBalls() {
    addBall(Ball(
      id: 'object',
      type: BallType.solid,
      number: 1,
      position: defaultObjectBallPosition,
    ));
    addBall(Ball(
      id: 'target',
      type: BallType.target,
      number: 1,
      position: defaultTargetBallPosition,
    ));
    addBall(Ball.cue(position: defaultCueBallPosition));
  }

  void resetToDefaults() {
    _balls.clear();
    initializeDefaultBalls();
  }

  void updateGhostBall(TableCoordinate? position) {
    if (position == null) {
      _balls.remove('ghost');
    } else {
      _balls['ghost'] = Ball.ghost(position: position);
    }
  }

  void updateGhostBallAdjusted(TableCoordinate? position) {
    if (position == null) {
      _balls.remove('ghost_adjusted');
    } else {
      _balls['ghost_adjusted'] = Ball.ghostAdjusted(position: position);
    }
  }

  Ball? get ghostBall => _balls['ghost'];
  Ball? get ghostBallAdjusted => _balls['ghost_adjusted'];
}
