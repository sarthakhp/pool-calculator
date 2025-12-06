import 'package:pool_calculator/domain/coordinates/table_coordinate.dart';

class PocketPositions {
  static const String bottomLeftCorner = 'bottom_left_corner';
  static const String topLeftCorner = 'top_left_corner';
  static const String bottomRightCorner = 'bottom_right_corner';
  static const String topRightCorner = 'top_right_corner';
  static const String leftSide = 'left_side';
  static const String rightSide = 'right_side';

  static const Map<String, TableCoordinate> tableCoordinates = {
    bottomLeftCorner: TableCoordinate(0, 0),
    topLeftCorner: TableCoordinate(1, 0),
    bottomRightCorner: TableCoordinate(0, 1),
    topRightCorner: TableCoordinate(1, 1),
    leftSide: TableCoordinate(0.5, 0),
    rightSide: TableCoordinate(0.5, 1),
  };

  static TableCoordinate? getTableCoordinate(String? name) {
    if (name == null) return null;
    return tableCoordinates[name];
  }
}
