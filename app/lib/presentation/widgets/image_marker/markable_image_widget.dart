import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pool_calculator/backend/models/image_mark.dart';
import 'package:pool_calculator/domain/image_marker/image_coordinate_converter.dart';
import 'package:pool_calculator/presentation/widgets/image_marker/magnifier_overlay.dart';
import 'package:pool_calculator/presentation/widgets/image_marker/mark_indicator_widget.dart';

class MarkableImageWidget extends StatefulWidget {
  final Uint8List imageBytes;
  final int imageWidth;
  final int imageHeight;
  final List<ImageMark> marks;
  final bool canAddMark;
  final void Function(double pixelX, double pixelY) onMarkPlaced;

  const MarkableImageWidget({
    super.key,
    required this.imageBytes,
    required this.imageWidth,
    required this.imageHeight,
    required this.marks,
    required this.canAddMark,
    required this.onMarkPlaced,
  });

  @override
  State<MarkableImageWidget> createState() => _MarkableImageWidgetState();
}

class _MarkableImageWidgetState extends State<MarkableImageWidget> {
  bool _isMarking = false;
  double? _touchX;
  double? _touchY;
  Size? _containerSize;

  ({double width, double height, double offsetX, double offsetY})? _getImageBounds() {
    if (_containerSize == null) return null;

    final containerWidth = _containerSize!.width;
    final containerHeight = _containerSize!.height;
    final imageAspect = widget.imageWidth / widget.imageHeight;
    final containerAspect = containerWidth / containerHeight;

    double renderedWidth, renderedHeight;

    if (imageAspect > containerAspect) {
      renderedWidth = containerWidth;
      renderedHeight = containerWidth / imageAspect;
    } else {
      renderedHeight = containerHeight;
      renderedWidth = containerHeight * imageAspect;
    }

    return (width: renderedWidth, height: renderedHeight, offsetX: 0, offsetY: 0);
  }

  ImageCoordinateConverter? get _converter {
    final bounds = _getImageBounds();
    if (bounds == null) return null;
    return ImageCoordinateConverter(
      imageWidth: widget.imageWidth,
      imageHeight: widget.imageHeight,
      displayedWidth: bounds.width,
      displayedHeight: bounds.height,
      displayedLeft: bounds.offsetX,
      displayedTop: bounds.offsetY,
    );
  }

  void _onPanStart(DragStartDetails details) {
    if (!widget.canAddMark) return;
    setState(() {
      _isMarking = true;
      _touchX = details.localPosition.dx;
      _touchY = details.localPosition.dy;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isMarking) return;
    setState(() {
      _touchX = details.localPosition.dx;
      _touchY = details.localPosition.dy;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isMarking || _touchX == null || _touchY == null) {
      setState(() => _isMarking = false);
      return;
    }

    final converter = _converter;
    if (converter != null && converter.isWithinImage(_touchX!, _touchY!)) {
      final pixels = converter.screenToImagePixels(_touchX!, _touchY!);
      widget.onMarkPlaced(pixels.pixelX, pixels.pixelY);
    }

    setState(() {
      _isMarking = false;
      _touchX = null;
      _touchY = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _containerSize = Size(constraints.maxWidth, constraints.maxHeight);
        final bounds = _getImageBounds();

        return GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Image.memory(
                widget.imageBytes,
                fit: BoxFit.contain,
                alignment: Alignment.topLeft,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                gaplessPlayback: true,
              ),
              ..._buildMarkIndicators(),
              if (_isMarking && _touchX != null && _touchY != null && bounds != null)
                MagnifierOverlay(
                  imageBytes: widget.imageBytes,
                  touchX: _touchX!,
                  touchY: _touchY!,
                  imageDisplayWidth: bounds.width,
                  imageDisplayHeight: bounds.height,
                  imageOffsetX: bounds.offsetX,
                  imageOffsetY: bounds.offsetY,
                ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildMarkIndicators() {
    final converter = _converter;
    if (converter == null) return [];

    return widget.marks.asMap().entries.map((entry) {
      final mark = entry.value;
      final screen = converter.imagePixelsToScreen(mark.pixelX, mark.pixelY);
      return Positioned(
        left: screen.screenX - 15,
        top: screen.screenY - 15,
        child: MarkIndicatorWidget(markNumber: mark.markIndex),
      );
    }).toList();
  }
}

