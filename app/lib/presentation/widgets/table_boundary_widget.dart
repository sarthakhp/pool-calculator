import 'package:flutter/material.dart';

class TableBoundaryWidget extends StatelessWidget {
  final double tableWidth;
  final double tableHeight;
  final double borderThickness;

  const TableBoundaryWidget({
    super.key,
    required this.tableWidth,
    required this.tableHeight,
    this.borderThickness = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tableWidth + (borderThickness * 2),
      height: tableHeight + (borderThickness * 2),
      decoration: BoxDecoration(
        color: Colors.green[900],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

