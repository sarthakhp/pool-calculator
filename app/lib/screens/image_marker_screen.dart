import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pool_calculator/backend/models/ball_position.dart';
import 'package:pool_calculator/backend/models/image_mark.dart';
import 'package:pool_calculator/backend/repositories/ball_position_repository.dart';
import 'package:pool_calculator/backend/services/coordinate_conversion_service.dart';
import 'package:pool_calculator/domain/table/table_dimensions.dart';
import 'package:pool_calculator/presentation/widgets/image_marker/image_marker_widgets.dart';

class ImageMarkerScreen extends StatefulWidget {
  const ImageMarkerScreen({super.key});

  @override
  State<ImageMarkerScreen> createState() => _ImageMarkerScreenState();
}

class _StoredResponse {
  final double cueBallX;
  final double cueBallY;
  final double objectBallX;
  final double objectBallY;

  _StoredResponse({
    required this.cueBallX,
    required this.cueBallY,
    required this.objectBallX,
    required this.objectBallY,
  });
}

class _ImageMarkerScreenState extends State<ImageMarkerScreen> {
  final ImagePicker _picker = ImagePicker();
  final CoordinateConversionService _conversionService = CoordinateConversionService();
  final BallPositionRepository _ballPositionRepository = BallPositionRepository();

  Uint8List? _imageBytes;
  int? _imageWidth;
  int? _imageHeight;
  final List<ImageMark> _marks = [];
  bool _isLoading = false;
  bool _isUploading = false;

  final List<_StoredResponse> _storedResponses = [];

  bool get _hasImage => _imageBytes != null;
  bool get _canAddMark => _marks.length < 2;
  bool get _hasBothMarks => _marks.length >= 2;
  bool get _canUndo => _marks.isNotEmpty;
  int get _photosProcessed => _storedResponses.length;

  Future<void> _captureImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (image == null) return;

      setState(() => _isLoading = true);

      final bytes = await image.readAsBytes();
      final dimensions = await _getImageDimensions(bytes);

      setState(() {
        _imageBytes = bytes;
        _imageWidth = dimensions.width;
        _imageHeight = dimensions.height;
        _marks.clear();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error capturing image: $e')),
        );
      }
    }
  }

  Future<({int width, int height})> _getImageDimensions(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    return (width: image.width, height: image.height);
  }

  void _onMarkPlaced(double pixelX, double pixelY) {
    if (!_canAddMark || _imageWidth == null || _imageHeight == null) return;

    final mark = ImageMark(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      markIndex: _marks.length + 1,
      pixelX: pixelX,
      pixelY: pixelY,
      imageWidth: _imageWidth!,
      imageHeight: _imageHeight!,
      createdAt: DateTime.now(),
    );

    setState(() => _marks.add(mark));
  }

  void _undoLastMark() {
    if (_canUndo) {
      setState(() => _marks.removeLast());
    }
  }

  void _clearAllMarks() {
    setState(() => _marks.clear());
  }

  Future<_StoredResponse?> _callApiForCurrentPhoto() async {
    if (!_hasBothMarks || _imageBytes == null) return null;

    final cueBallMark = _marks[0];
    final objectBallMark = _marks[1];
    const tableDimensions = TableDimensions.standard;

    final response = await _conversionService.convertCoordinates(
      imageBytes: _imageBytes!,
      imageFileName: 'pool_table.jpg',
      cueBallX: cueBallMark.pixelX,
      cueBallY: cueBallMark.pixelY,
      objectBallX: objectBallMark.pixelX,
      objectBallY: objectBallMark.pixelY,
      tableWidth: tableDimensions.lengthInches,
      tableHeight: tableDimensions.widthInches,
    );

    if (!response.success || response.cueBallTable == null || response.objectBallTable == null) {
      throw Exception(response.error ?? 'Failed to convert coordinates');
    }

    return _StoredResponse(
      cueBallX: response.cueBallTable!.x,
      cueBallY: response.cueBallTable!.y,
      objectBallX: response.objectBallTable!.x,
      objectBallY: response.objectBallTable!.y,
    );
  }

  Future<void> _addAnotherPhoto() async {
    if (!_hasBothMarks || _imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please place both marks first')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final response = await _callApiForCurrentPhoto();
      if (response != null) {
        _storedResponses.add(response);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Photo ${_storedResponses.length} processed. Take another photo.')),
        );
        setState(() {
          _imageBytes = null;
          _imageWidth = null;
          _imageHeight = null;
          _marks.clear();
          _isUploading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing: $e')),
        );
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _applyAndFinish() async {
    if (!_hasBothMarks || _imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please place both marks first')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final response = await _callApiForCurrentPhoto();
      if (response != null) {
        _storedResponses.add(response);
      }

      if (_storedResponses.isEmpty) {
        throw Exception('No valid responses to average');
      }

      double sumCueBallX = 0, sumCueBallY = 0, sumObjectBallX = 0, sumObjectBallY = 0;
      for (final r in _storedResponses) {
        sumCueBallX += r.cueBallX;
        sumCueBallY += r.cueBallY;
        sumObjectBallX += r.objectBallX;
        sumObjectBallY += r.objectBallY;
      }

      final count = _storedResponses.length;
      final avgCueBallX = sumCueBallX / count;
      final avgCueBallY = sumCueBallY / count;
      final avgObjectBallX = sumObjectBallX / count;
      final avgObjectBallY = sumObjectBallY / count;

      const tableDimensions = TableDimensions.standard;
      final cueBallNormalizedX = avgCueBallX / tableDimensions.lengthInches;
      final cueBallNormalizedY = avgCueBallY / tableDimensions.widthInches;
      final objectBallNormalizedX = avgObjectBallX / tableDimensions.lengthInches;
      final objectBallNormalizedY = avgObjectBallY / tableDimensions.widthInches;

      await _ballPositionRepository.setCueBallPosition(
        BallPosition(x: cueBallNormalizedX, y: cueBallNormalizedY),
      );
      await _ballPositionRepository.setObjectBallPosition(
        BallPosition(x: objectBallNormalizedX, y: objectBallNormalizedY),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Averaged $count photo(s). Ball positions updated!')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error applying: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Marker'),
        actions: [
          if (_canUndo)
            IconButton(
              icon: const Icon(Icons.undo),
              tooltip: 'Undo last mark',
              onPressed: _undoLastMark,
            ),
          if (_marks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear all marks',
              onPressed: _clearAllMarks,
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasImage) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Take a photo to start marking',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _captureImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MarkableImageWidget(
              imageBytes: _imageBytes!,
              imageWidth: _imageWidth!,
              imageHeight: _imageHeight!,
              marks: _marks,
              canAddMark: _canAddMark,
              onMarkPlaced: _onMarkPlaced,
            ),
          ),
        ),
        _buildInfoPanel(),
      ],
    );
  }

  Widget _buildInfoPanel() {
    final progressText = _photosProcessed > 0
        ? '$_photosProcessed photo${_photosProcessed > 1 ? 's' : ''} processed'
        : 'No photos processed yet';

    final instructionText = _canAddMark
        ? 'Tap and drag to place mark ${_marks.length + 1}'
        : 'Both marks placed. Add another photo or apply.';

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Image: ${_imageWidth}x$_imageHeight pixels',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _photosProcessed > 0 ? Colors.green[100] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  progressText,
                  style: TextStyle(
                    fontSize: 12,
                    color: _photosProcessed > 0 ? Colors.green[800] : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(instructionText, style: TextStyle(color: Colors.grey[700])),
          const SizedBox(height: 8),
          Text(_marks.isNotEmpty
              ? 'Cue Ball: (${_marks[0].pixelX.toStringAsFixed(1)}, ${_marks[0].pixelY.toStringAsFixed(1)}) px'
              : 'Cue Ball: --'),
          Text(_marks.length > 1
              ? 'Object Ball: (${_marks[1].pixelX.toStringAsFixed(1)}, ${_marks[1].pixelY.toStringAsFixed(1)}) px'
              : 'Object Ball: --'),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: (_hasBothMarks && !_isUploading) ? _addAnotherPhoto : null,
                  icon: _isUploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.add_a_photo, size: 18),
                  label: const Text('Add Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: (_hasBothMarks && !_isUploading) ? _applyAndFinish : null,
                  icon: _isUploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.check, size: 18),
                  label: const Text('Apply'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget? _buildFab() {
    if (!_hasImage) return null;
    return FloatingActionButton(
      onPressed: _captureImage,
      tooltip: 'Take new photo',
      child: const Icon(Icons.camera_alt),
    );
  }
}
