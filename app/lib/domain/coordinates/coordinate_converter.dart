import 'package:pool_calculator/domain/coordinates/screen_coordinate.dart';
import 'package:pool_calculator/domain/coordinates/table_coordinate.dart';
import 'package:pool_calculator/domain/table/table_dimensions.dart';

class ScreenTableLayout {
  final double tableWidthPixels;
  final double tableHeightPixels;
  final double tableLeftPixels;
  final double tableTopPixels;

  const ScreenTableLayout({
    required this.tableWidthPixels,
    required this.tableHeightPixels,
    required this.tableLeftPixels,
    required this.tableTopPixels,
  });
}

class CoordinateConverter {
  final TableDimensions tableDimensions;
  final ScreenTableLayout screenLayout;

  const CoordinateConverter({
    required this.tableDimensions,
    required this.screenLayout,
  });

  factory CoordinateConverter.fromConstraints({
    required double maxWidth,
    required double maxHeight,
    required TableDimensions tableDimensions,
    double screenWidthFraction = 0.9,
    double screenHeightFraction = 0.8,
  }) {
    final availableWidth = maxWidth * screenWidthFraction;
    final availableHeight = maxHeight * screenHeightFraction;

    double tableWidth;
    double tableHeight;

    if (availableWidth / tableDimensions.aspectRatio <= availableHeight) {
      tableWidth = availableWidth;
      tableHeight = availableWidth / tableDimensions.aspectRatio;
    } else {
      tableHeight = availableHeight;
      tableWidth = availableHeight * tableDimensions.aspectRatio;
    }

    final tableLeft = (maxWidth - tableWidth) / 2;
    final tableTop = (maxHeight - tableHeight) / 2;

    return CoordinateConverter(
      tableDimensions: tableDimensions,
      screenLayout: ScreenTableLayout(
        tableWidthPixels: tableWidth,
        tableHeightPixels: tableHeight,
        tableLeftPixels: tableLeft,
        tableTopPixels: tableTop,
      ),
    );
  }

  ScreenCoordinate tableToScreen(TableCoordinate tableCoord) {
    return ScreenCoordinate(
      screenLayout.tableLeftPixels + (tableCoord.x * screenLayout.tableWidthPixels),
      screenLayout.tableTopPixels + (tableCoord.y * screenLayout.tableHeightPixels),
    );
  }

  TableCoordinate screenToTable(ScreenCoordinate screenCoord) {
    return TableCoordinate(
      (screenCoord.x - screenLayout.tableLeftPixels) / screenLayout.tableWidthPixels,
      (screenCoord.y - screenLayout.tableTopPixels) / screenLayout.tableHeightPixels,
    );
  }

  ScreenCoordinate tableDeltaToScreenDelta(TableCoordinate tableDelta) {
    return ScreenCoordinate(
      tableDelta.x * screenLayout.tableWidthPixels,
      tableDelta.y * screenLayout.tableHeightPixels,
    );
  }

  TableCoordinate screenDeltaToTableDelta(ScreenCoordinate screenDelta) {
    return TableCoordinate(
      screenDelta.x / screenLayout.tableWidthPixels,
      screenDelta.y / screenLayout.tableHeightPixels,
    );
  }

  double ballDiameterPixels() {
    return tableDimensions.ballDiameterNormalized * screenLayout.tableWidthPixels;
  }

  double ballRadiusPixels() {
    return ballDiameterPixels() / 2;
  }

  double borderThicknessPixels() {
    return tableDimensions.borderThicknessNormalized * screenLayout.tableWidthPixels;
  }

  ScreenCoordinate ballTopLeftScreen(TableCoordinate ballCenter) {
    final centerScreen = tableToScreen(ballCenter);
    final radius = ballRadiusPixels();
    return ScreenCoordinate(
      centerScreen.x - radius,
      centerScreen.y - radius,
    );
  }

  double get tableWidthPixels => screenLayout.tableWidthPixels;
  double get tableHeightPixels => screenLayout.tableHeightPixels;
  double get tableLeftPixels => screenLayout.tableLeftPixels;
  double get tableTopPixels => screenLayout.tableTopPixels;
}

