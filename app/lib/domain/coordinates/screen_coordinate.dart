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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScreenCoordinate && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => 'ScreenCoordinate($x, $y)';
}

