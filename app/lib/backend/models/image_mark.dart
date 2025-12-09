import 'dart:convert';

class ImageMark {
  final String id;
  final int markIndex;
  final double pixelX;
  final double pixelY;
  final int imageWidth;
  final int imageHeight;
  final DateTime createdAt;

  ImageMark({
    required this.id,
    required this.markIndex,
    required this.pixelX,
    required this.pixelY,
    required this.imageWidth,
    required this.imageHeight,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'markIndex': markIndex,
      'pixelX': pixelX,
      'pixelY': pixelY,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ImageMark.fromJson(Map<String, dynamic> json) {
    return ImageMark(
      id: json['id'] as String,
      markIndex: json['markIndex'] as int,
      pixelX: (json['pixelX'] as num).toDouble(),
      pixelY: (json['pixelY'] as num).toDouble(),
      imageWidth: json['imageWidth'] as int,
      imageHeight: json['imageHeight'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory ImageMark.fromJsonString(String jsonString) {
    return ImageMark.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  ImageMark copyWith({
    String? id,
    int? markIndex,
    double? pixelX,
    double? pixelY,
    int? imageWidth,
    int? imageHeight,
    DateTime? createdAt,
  }) {
    return ImageMark(
      id: id ?? this.id,
      markIndex: markIndex ?? this.markIndex,
      pixelX: pixelX ?? this.pixelX,
      pixelY: pixelY ?? this.pixelY,
      imageWidth: imageWidth ?? this.imageWidth,
      imageHeight: imageHeight ?? this.imageHeight,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ImageMark(id: $id, mark: $markIndex, pixel: ($pixelX, $pixelY), imageSize: ${imageWidth}x$imageHeight)';
  }
}

