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
    final touchPadding = diameter * 1;
    final touchAreaSize = diameter + (touchPadding * 2);

    return Positioned(
      left: topLeft.x - touchPadding,
      top: topLeft.y - touchPadding,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
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
        child: SizedBox(
          width: touchAreaSize,
          height: touchAreaSize,
          child: Center(
            child: BallWidget(
              ball: ball,
              diameter: diameter,
            ),
          ),
        ),
      ),
    );
  }
}
