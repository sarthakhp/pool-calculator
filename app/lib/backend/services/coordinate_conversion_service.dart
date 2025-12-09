import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CoordinateConversionResponse {
  final bool success;
  final BallTablePosition? cueBallTable;
  final BallTablePosition? objectBallTable;
  final String? error;

  CoordinateConversionResponse({
    required this.success,
    this.cueBallTable,
    this.objectBallTable,
    this.error,
  });

  factory CoordinateConversionResponse.fromJson(Map<String, dynamic> json) {
    return CoordinateConversionResponse(
      success: json['success'] as bool,
      cueBallTable: json['cue_ball_table'] != null
          ? BallTablePosition.fromJson(json['cue_ball_table'])
          : null,
      objectBallTable: json['object_ball_table'] != null
          ? BallTablePosition.fromJson(json['object_ball_table'])
          : null,
      error: json['error'] as String?,
    );
  }
}

class BallTablePosition {
  final double x;
  final double y;
  final String unit;

  BallTablePosition({
    required this.x,
    required this.y,
    required this.unit,
  });

  factory BallTablePosition.fromJson(Map<String, dynamic> json) {
    return BallTablePosition(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      unit: json['unit'] as String,
    );
  }
}

class CoordinateConversionService {
  static const String _baseUrl = 'https://hypocotylous-krysten-abominably.ngrok-free.dev';
  static const String _endpoint = '/convert-coordinates';

  Future<CoordinateConversionResponse> convertCoordinates({
    required Uint8List imageBytes,
    required String imageFileName,
    required double cueBallX,
    required double cueBallY,
    required double objectBallX,
    required double objectBallY,
    required double tableWidth,
    required double tableHeight,
  }) async {
    final uri = Uri.parse('$_baseUrl$_endpoint');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(http.MultipartFile.fromBytes(
      'image',
      imageBytes,
      filename: imageFileName,
    ));

    request.fields['cue_ball_x'] = cueBallX.round().toString();
    request.fields['cue_ball_y'] = cueBallY.round().toString();
    request.fields['object_ball_x'] = objectBallX.round().toString();
    request.fields['object_ball_y'] = objectBallY.round().toString();
    request.fields['table_width'] = tableWidth.toString();
    request.fields['table_height'] = tableHeight.toString();

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return CoordinateConversionResponse.fromJson(jsonData);
    } else {
      return CoordinateConversionResponse(
        success: false,
        error: 'HTTP ${response.statusCode}: ${response.body}',
      );
    }
  }
}

