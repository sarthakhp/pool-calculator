import 'package:flutter/material.dart';

class PoolTableWidget extends StatelessWidget {
  final double width;
  final double height;

  const PoolTableWidget({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

