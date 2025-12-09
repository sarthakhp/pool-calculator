import 'dart:typed_data';
import 'package:flutter/material.dart';

class MagnifierOverlay extends StatelessWidget {
  final Uint8List imageBytes;
  final double touchX;
  final double touchY;
  final double imageDisplayWidth;
  final double imageDisplayHeight;
  final double imageOffsetX;
  final double imageOffsetY;
  final double magnification;
  final double magnifierSize;

  const MagnifierOverlay({
    super.key,
    required this.imageBytes,
    required this.touchX,
    required this.touchY,
    required this.imageDisplayWidth,
    required this.imageDisplayHeight,
    this.imageOffsetX = 0,
    this.imageOffsetY = 0,
    this.magnification = 2.5,
    this.magnifierSize = 120,
  });

  @override
  Widget build(BuildContext context) {
    final localTouchX = touchX - imageOffsetX;
    final localTouchY = touchY - imageOffsetY;

    final magnifierX = touchX - magnifierSize / 2;
    final magnifierY = touchY - magnifierSize - 60;

    final containerWidth = imageDisplayWidth + imageOffsetX * 2;
    final containerHeight = imageDisplayHeight + imageOffsetY * 2;

    final clampedY = magnifierY < 10 ? touchY + 60 : magnifierY;

    return Positioned(
      left: magnifierX.clamp(10, containerWidth - magnifierSize - 10),
      top: clampedY.clamp(10, containerHeight - magnifierSize - 10),
      child: Container(
        width: magnifierSize,
        height: magnifierSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            children: [
              Positioned(
                left: -(localTouchX * magnification) + magnifierSize / 2,
                top: -(localTouchY * magnification) + magnifierSize / 2,
                child: Image.memory(
                  imageBytes,
                  width: imageDisplayWidth * magnification,
                  height: imageDisplayHeight * magnification,
                  fit: BoxFit.fill,
                  gaplessPlayback: true,
                ),
              ),
              Center(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                  child: Center(
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

