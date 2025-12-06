import 'package:flutter/material.dart';

class TableGridOverlay extends StatelessWidget {
  final double width;
  final double height;
  final int columns;
  final int rows;
  final Color lineColor;
  final double strokeWidth;

  const TableGridOverlay({
    super.key,
    required this.width,
    required this.height,
    this.columns = 6,
    this.rows = 3,
    this.lineColor = const Color.fromARGB(100, 255, 255, 255),
    this.strokeWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _TableGridPainter(
        columns: columns,
        rows: rows,
        lineColor: lineColor,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _TableGridPainter extends CustomPainter {
  final int columns;
  final int rows;
  final Color lineColor;
  final double strokeWidth;

  _TableGridPainter({
    required this.columns,
    required this.rows,
    required this.lineColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final colWidth = size.width / columns;
    final rowHeight = size.height / rows;

    for (var i = 1; i < columns; i++) {
      final x = colWidth * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (var j = 1; j < rows; j++) {
      final y = rowHeight * j;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TableGridPainter oldDelegate) {
    return columns != oldDelegate.columns ||
        rows != oldDelegate.rows ||
        lineColor != oldDelegate.lineColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}

