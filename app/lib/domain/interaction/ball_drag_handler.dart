import 'package:pool_calculator/domain/coordinates/coordinate_converter.dart';
import 'package:pool_calculator/domain/coordinates/screen_coordinate.dart';
import 'package:pool_calculator/domain/coordinates/table_coordinate.dart';
import 'package:pool_calculator/domain/table/pool_table_state.dart';

class BallDragHandler {
  final PoolTableState tableState;
  final CoordinateConverter converter;

  const BallDragHandler({
    required this.tableState,
    required this.converter,
  });

  TableCoordinate handleDrag({
    required String ballId,
    required double deltaX,
    required double deltaY,
  }) {
    final ball = tableState.getBall(ballId);
    if (ball == null) {
      throw ArgumentError('Ball with id $ballId not found');
    }

    final deltaTable = converter.screenDeltaToTableDelta(
      ScreenCoordinate(deltaX, deltaY),
    );

    final newPosition = ball.position + deltaTable;
    tableState.moveBall(ballId, newPosition);

    return ball.position;
  }

  void completeDrag(String ballId) {}
}
