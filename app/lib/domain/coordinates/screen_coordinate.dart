import 'dart:math';

class ScreenCoordinate {
  final double x;
  final double y;

  const ScreenCoordinate(this.x, this.y);

  const ScreenCoordinate.zero() : x = 0, y = 0;

  ScreenCoordinate operator +(ScreenCoordinate other) {
    return ScreenCoordinate(x + other.x, y + other.y);
  }

  ScreenCoordinate operator -(ScreenCoordinate other) {
    return ScreenCoordinate(x - other.x, y - other.y);
  }

  ScreenCoordinate operator /(double value) {
    return ScreenCoordinate(x / value, y / value);
  }

  ScreenCoordinate operator *(double value) {
    return ScreenCoordinate(x * value, y * value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScreenCoordinate && other.x == x && other.y == y;
  }

  double get magnitude => sqrt(x * x + y * y);

  ScreenCoordinate normalized() {
    final magnitude = sqrt(x * x + y * y);
    if (magnitude == 0) return const ScreenCoordinate.zero();
    return ScreenCoordinate(x / magnitude, y / magnitude);
  }

  double dot(ScreenCoordinate other) {
    return (x * other.x) + (y * other.y);
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => 'ScreenCoordinate($x, $y)';
}

