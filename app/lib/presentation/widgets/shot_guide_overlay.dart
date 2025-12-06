import 'package:flutter/material.dart';
import 'package:pool_calculator/domain/domain.dart';

class ShotGuideOverlay extends StatelessWidget {
  final CoordinateConverter converter;
  final TableCoordinate? cueBallCenter;
  final TableCoordinate? objectBallCenter;
  final TableCoordinate? ghostBallCenter;
  final TableCoordinate? pocket;
  final Color cueToObjectColor;
  final Color objectToPocketColor;
  final double strokeWidth;

  const ShotGuideOverlay({
    super.key,
    required this.converter,
    required this.cueBallCenter,
    required this.objectBallCenter,
    required this.ghostBallCenter,
    required this.pocket,
    this.cueToObjectColor = Colors.white,
    this.objectToPocketColor = Colors.red,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    if (cueBallCenter == null || objectBallCenter == null || pocket == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      painter: _ShotGuidePainter(
        converter: converter,
        cueBallCenter: cueBallCenter!,
        objectBallCenter: objectBallCenter!,
        ghostBallCenter: ghostBallCenter!,
        pocket: pocket!,
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
  final TableCoordinate ghostBallCenter;
  final TableCoordinate pocket;
  final Color cueToObjectColor;
  final Color objectToPocketColor;
  final double strokeWidth;

  _ShotGuidePainter({
    required this.converter,
    required this.cueBallCenter,
    required this.objectBallCenter,
    required this.ghostBallCenter,
    required this.pocket,
    required this.cueToObjectColor,
    required this.objectToPocketColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cueScreen = converter.tableToScreen(cueBallCenter);
    final objectScreen = converter.tableToScreen(objectBallCenter);
    final ghostScreen = converter.tableToScreen(ghostBallCenter);
    final pocketScreen = converter.tableToScreen(pocket);

    final ghostScreenExtented = ((ghostScreen - cueScreen).normalized() * 1000) + ghostScreen;

    final cueToObjectPaint = Paint()
      ..color = cueToObjectColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final objectToPocketPaint = Paint()
      ..color = objectToPocketColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(cueScreen.x, cueScreen.y),
      Offset(ghostScreenExtented.x, ghostScreenExtented.y),
      cueToObjectPaint,
    );

    canvas.drawLine(
      Offset(objectScreen.x, objectScreen.y),
      Offset(pocketScreen.x, pocketScreen.y),
      objectToPocketPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ShotGuidePainter oldDelegate) {
    return
        cueBallCenter != oldDelegate.cueBallCenter ||
        objectBallCenter != oldDelegate.objectBallCenter ||
        pocket != oldDelegate.pocket ||
        converter != oldDelegate.converter ||
        cueToObjectColor != oldDelegate.cueToObjectColor ||
        objectToPocketColor != oldDelegate.objectToPocketColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}

