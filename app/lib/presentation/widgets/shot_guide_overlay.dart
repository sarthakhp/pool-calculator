import 'package:flutter/material.dart';
import 'package:pool_calculator/domain/domain.dart';

class ShotGuideOverlay extends StatelessWidget {
  final CoordinateConverter converter;
  final TableCoordinate? cueBallCenter;
  final TableCoordinate? objectBallCenter;
  final TableCoordinate? targetBallCenter;
  final TableCoordinate? ghostBallAdjustedCenter;
  final Color cueToObjectColor;
  final Color objectToPocketColor;
  final double strokeWidth;

  const ShotGuideOverlay({
    super.key,
    required this.converter,
    required this.cueBallCenter,
    required this.objectBallCenter,
    required this.targetBallCenter,
    required this.ghostBallAdjustedCenter,
    this.cueToObjectColor = Colors.white,
    this.objectToPocketColor = Colors.red,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    if (cueBallCenter == null || objectBallCenter == null || targetBallCenter == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      painter: _ShotGuidePainter(
        converter: converter,
        cueBallCenter: cueBallCenter!,
        objectBallCenter: objectBallCenter!,
        targetBallCenter: targetBallCenter!,
        ghostBallAdjustedCenter: ghostBallAdjustedCenter!,
        cueToObjectColor: cueToObjectColor,
        objectToPocketColor: objectToPocketColor,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _ShotGuidePainter extends CustomPainter {
  final CoordinateConverter converter;
  final TableCoordinate cueBallCenter;
  final TableCoordinate objectBallCenter;
  final TableCoordinate targetBallCenter;
  final TableCoordinate ghostBallAdjustedCenter;
  final Color cueToObjectColor;
  final Color objectToPocketColor;
  final double strokeWidth;

  _ShotGuidePainter({
    required this.converter,
    required this.cueBallCenter,
    required this.objectBallCenter,
    required this.targetBallCenter,
    required this.ghostBallAdjustedCenter,
    required this.cueToObjectColor,
    required this.objectToPocketColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cueScreen = converter.tableToScreen(cueBallCenter);
    final objectScreen = converter.tableToScreen(objectBallCenter);
    final targetScreen = converter.tableToScreen(targetBallCenter);
    final ghostAdjustedScreen = converter.tableToScreen(ghostBallAdjustedCenter);

    final targetScreenExtended = ((targetScreen - objectScreen).normalized() * 1000) + targetScreen;
    final ghostAdjustedScreenExtended = ((ghostAdjustedScreen - cueScreen).normalized() * 1000) + ghostAdjustedScreen;
    final adjustedPathExtended = ((objectScreen - ghostAdjustedScreen).normalized() * 1000) + objectScreen;

    final cueToObjectPaint = Paint()
      ..color = cueToObjectColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final objectToTargetPaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final ghostAdjustedToObjectPaint = Paint()
      ..color = Colors.lightGreen
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(cueScreen.x, cueScreen.y),
      Offset(ghostAdjustedScreenExtended.x, ghostAdjustedScreenExtended.y),
      cueToObjectPaint,
    );

    canvas.drawLine(
      Offset(objectScreen.x, objectScreen.y),
      Offset(targetScreenExtended.x, targetScreenExtended.y),
      objectToTargetPaint,
    );

    canvas.drawLine(
      Offset(ghostAdjustedScreen.x, ghostAdjustedScreen.y),
      Offset(adjustedPathExtended.x, adjustedPathExtended.y),
      ghostAdjustedToObjectPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ShotGuidePainter oldDelegate) {
    return
        cueBallCenter != oldDelegate.cueBallCenter ||
        objectBallCenter != oldDelegate.objectBallCenter ||
        converter != oldDelegate.converter ||
        cueToObjectColor != oldDelegate.cueToObjectColor ||
        objectToPocketColor != oldDelegate.objectToPocketColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}

