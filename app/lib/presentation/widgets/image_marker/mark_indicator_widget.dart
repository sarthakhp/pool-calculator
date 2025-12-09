import 'package:flutter/material.dart';

class MarkIndicatorWidget extends StatelessWidget {
  final int markNumber;
  final Color color;
  final double size;

  const MarkIndicatorWidget({
    super.key,
    required this.markNumber,
    this.color = Colors.red,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CrosshairPainter(color: color, markNumber: markNumber),
      ),
    );
  }
}

class _CrosshairPainter extends CustomPainter {
  final Color color;
  final int markNumber;

  _CrosshairPainter({required this.color, required this.markNumber});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    canvas.drawCircle(center, radius, paint);

    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      paint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: '$markNumber',
        style: TextStyle(
          color: color,
          fontSize: size.width * 0.35,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx + radius + 4,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _CrosshairPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.markNumber != markNumber;
  }
}

