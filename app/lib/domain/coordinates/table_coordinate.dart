import 'dart:math';

class TableCoordinate {
  final double x;
  final double y;

  const TableCoordinate(this.x, this.y);

  const TableCoordinate.zero() : x = 0, y = 0;

  TableCoordinate operator +(TableCoordinate other) {
    return TableCoordinate(x + other.x, y + other.y);
  }

  TableCoordinate operator -(TableCoordinate other) {
    return TableCoordinate(x - other.x, y - other.y);
  }

  TableCoordinate clamp(double minX, double maxX, double minY, double maxY) {
    return TableCoordinate(
      x.clamp(minX, maxX),
      y.clamp(minY, maxY),
    );
  }

  TableCoordinate normalized() {
    final magnitude = sqrt(x * x + y * y);
    if (magnitude == 0) return const TableCoordinate.zero();
    return TableCoordinate(x / magnitude, y / magnitude);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TableCoordinate && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => 'TableCoordinate($x, $y)';

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  factory TableCoordinate.fromJson(Map<String, dynamic> json) {
    return TableCoordinate(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
    );
  }
}

