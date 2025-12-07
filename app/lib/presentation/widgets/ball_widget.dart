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
      case BallType.ghost:
        return Colors.white.withValues(alpha: 0.4);
      case BallType.target:
        return Colors.black;
    }
  }

  Color get _borderColor {
    if (ball.type == BallType.ghost) {
      return Colors.white.withValues(alpha: 0.8);
    }
    if (ball.type == BallType.target) {
      return Colors.green;
    }
    return Colors.transparent;
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
    var radius = ball.type == BallType.target ? diameter * 1.9 : diameter;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _ballColor,
          border: Border.all(color: _borderColor, width: 2),
        ),
      ),
    );
  }
}

