class ImageCoordinateConverter {
  final int imageWidth;
  final int imageHeight;
  final double displayedWidth;
  final double displayedHeight;
  final double displayedLeft;
  final double displayedTop;

  ImageCoordinateConverter({
    required this.imageWidth,
    required this.imageHeight,
    required this.displayedWidth,
    required this.displayedHeight,
    this.displayedLeft = 0,
    this.displayedTop = 0,
  });

  double get scaleX => imageWidth / displayedWidth;
  double get scaleY => imageHeight / displayedHeight;

  ({double pixelX, double pixelY}) screenToImagePixels(
    double screenX,
    double screenY,
  ) {
    final localX = screenX - displayedLeft;
    final localY = screenY - displayedTop;

    final pixelX = localX * scaleX;
    final pixelY = localY * scaleY;

    return (
      pixelX: pixelX.clamp(0, imageWidth.toDouble()),
      pixelY: pixelY.clamp(0, imageHeight.toDouble()),
    );
  }

  ({double screenX, double screenY}) imagePixelsToScreen(
    double pixelX,
    double pixelY,
  ) {
    final screenX = (pixelX / scaleX) + displayedLeft;
    final screenY = (pixelY / scaleY) + displayedTop;

    return (screenX: screenX, screenY: screenY);
  }

  ({double localX, double localY}) screenToLocal(
    double screenX,
    double screenY,
  ) {
    return (
      localX: screenX - displayedLeft,
      localY: screenY - displayedTop,
    );
  }

  bool isWithinImage(double screenX, double screenY) {
    final localX = screenX - displayedLeft;
    final localY = screenY - displayedTop;
    return localX >= 0 &&
        localX <= displayedWidth &&
        localY >= 0 &&
        localY <= displayedHeight;
  }
}

