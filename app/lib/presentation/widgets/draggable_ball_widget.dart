import 'package:flutter/material.dart';
import 'package:pool_calculator/domain/domain.dart';
import 'package:pool_calculator/presentation/widgets/ball_widget.dart';

class DraggableBallWidget extends StatelessWidget {
  final Ball ball;
  final BallDragHandler dragHandler;
  final CoordinateConverter converter;
  final VoidCallback onPositionChanged;
  final VoidCallback? onDragEnd;

  const DraggableBallWidget({
    super.key,
    required this.ball,
    required this.dragHandler,
    required this.converter,
    required this.onPositionChanged,
    this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    final topLeft = converter.ballTopLeftScreen(ball.center);
    final diameter = converter.ballDiameterPixels();

    return Positioned(
      left: topLeft.x,
      top: topLeft.y,
      child: GestureDetector(
        onPanUpdate: (details) {
          dragHandler.handleDrag(
            ballId: ball.id,
            deltaX: details.delta.dx,
            deltaY: details.delta.dy,
          );
          onPositionChanged();
        },
        onPanEnd: (_) {
          dragHandler.completeDrag(ball.id);
          onDragEnd?.call();
        },
        child: BallWidget(
          ball: ball,
          diameter: diameter,
        ),
      ),
    );
  }
}
