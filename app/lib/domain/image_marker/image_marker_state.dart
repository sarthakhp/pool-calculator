import 'dart:typed_data';
import 'package:pool_calculator/backend/models/image_mark.dart';

class ImageMarkerState {
  Uint8List? imageBytes;
  int? imageWidth;
  int? imageHeight;
  final List<ImageMark> marks = [];
  bool isMarking = false;
  double? currentTouchX;
  double? currentTouchY;

  bool get hasImage => imageBytes != null;
  bool get hasImageDimensions => imageWidth != null && imageHeight != null;
  int get markCount => marks.length;
  bool get canAddMark => markCount < 2;
  bool get hasBothMarks => markCount >= 2;

  void setImage(Uint8List bytes, int width, int height) {
    imageBytes = bytes;
    imageWidth = width;
    imageHeight = height;
    marks.clear();
  }

  void clearImage() {
    imageBytes = null;
    imageWidth = null;
    imageHeight = null;
    marks.clear();
  }

  void addMark(ImageMark mark) {
    if (canAddMark) {
      marks.add(mark);
    }
  }

  void undoLastMark() {
    if (marks.isNotEmpty) {
      marks.removeLast();
    }
  }

  void clearAllMarks() {
    marks.clear();
  }

  void startMarking(double touchX, double touchY) {
    isMarking = true;
    currentTouchX = touchX;
    currentTouchY = touchY;
  }

  void updateTouchPosition(double touchX, double touchY) {
    currentTouchX = touchX;
    currentTouchY = touchY;
  }

  void endMarking() {
    isMarking = false;
    currentTouchX = null;
    currentTouchY = null;
  }

  ImageMark? getMark(int index) {
    if (index >= 0 && index < marks.length) {
      return marks[index];
    }
    return null;
  }
}

