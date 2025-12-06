import 'package:flutter/material.dart';
import 'package:pool_calculator/domain/ball/ball.dart';
import 'package:pool_calculator/domain/ball/ball_type.dart';

class BallWidget extends StatelessWidget {
  final Ball ball;
  final double diameter;
  final VoidCallback? onTap;

  const BallWidget({
    super.key,
    required this.ball,
    required this.diameter,
    this.onTap,
  });

  Color get _ballColor {
    switch (ball.type) {
      case BallType.cue:
        return Colors.white;
      case BallType.solid:
        return _solidBallColor(ball.number ?? 1);
      case BallType.stripe:
        return _stripeBallColor(ball.number ?? 9);
      case BallType.eight:
        return Colors.black;
    }
  }

  Color _solidBallColor(int number) {
    const colors = {
      1: Colors.yellow,
      2: Colors.blue,
      3: Colors.red,
      4: Colors.purple,
      5: Colors.orange,
      6: Colors.green,
      7: Colors.brown,
    };
    return colors[number] ?? Colors.red;
  }

  Color _stripeBallColor(int number) {
    return _solidBallColor(number - 8);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _ballColor,
          border: Border.all(color: Colors.black, width: 2),
        ),
      ),
    );
  }
}

