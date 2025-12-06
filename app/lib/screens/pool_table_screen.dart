import 'package:flutter/material.dart';
import 'package:pool_calculator/backend/models/ball_position.dart';
import 'package:pool_calculator/backend/repositories/ball_position_repository.dart';
import 'package:pool_calculator/backend/database/storage_helper.dart';
import 'package:pool_calculator/domain/domain.dart';
import 'package:pool_calculator/presentation/widgets/widgets.dart';

class PoolTableScreen extends StatefulWidget {
  const PoolTableScreen({super.key});

  @override
  State<PoolTableScreen> createState() => _PoolTableScreenState();
}

class _PoolTableScreenState extends State<PoolTableScreen> {
  final BallPositionRepository _ballPositionRepository = BallPositionRepository();
  final StorageHelper _storageHelper = StorageHelper();
  late final PoolTableState _tableState;
  bool _isLoading = true;
  String? _selectedPositionName;

  @override
  void initState() {
    super.initState();
    _tableState = PoolTableState();
    _tableState.initializeDefaultBalls();
    _loadBallPositions();
  }

  Future<void> _loadBallPositions() async {
    try {
      final cueBallPos = await _ballPositionRepository.getCueBallPosition();
      final objectBallPos = await _ballPositionRepository.getObjectBallPosition();
      final selectedPositionName = await _storageHelper.getSelectedPosition();
      final savedBallDiameter = await _storageHelper.getBallDiameterInches();
      final savedBorderThickness = await _storageHelper.getBorderThicknessInches();

      setState(() {
        if (cueBallPos != null) {
          _tableState.moveBall('cue', TableCoordinate(cueBallPos.x, cueBallPos.y));
        }
        if (objectBallPos != null) {
          _tableState.moveBall('object', TableCoordinate(objectBallPos.x, objectBallPos.y));
        }
        if (selectedPositionName != null) {
          _selectedPositionName = selectedPositionName;
        } else {
          _selectedPositionName = PocketPositions.topLeftCorner;
        }
        if (savedBallDiameter != null) {
          _tableState.updateBallDiameter(savedBallDiameter);
        }
        if (savedBorderThickness != null) {
          _tableState.updateBorderThickness(savedBorderThickness);
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading ball positions: $e')),
        );
      }
    }
  }

  Future<void> _saveBallPosition(String ballId) async {
    try {
      final ball = _tableState.getBall(ballId);
      if (ball == null) return;

      final position = BallPosition(x: ball.position.x, y: ball.position.y);
      if (ballId == 'cue') {
        await _ballPositionRepository.setCueBallPosition(position);
      } else if (ballId == 'object') {
        await _ballPositionRepository.setObjectBallPosition(position);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving ball position: $e')),
        );
      }
    }
  }

  Future<void> _resetBallPositions() async {
    try {
      await _ballPositionRepository.resetBallPositions();
      await _storageHelper.clearSelectedPosition();
      setState(() {
        _tableState.resetToDefaults();
        _selectedPositionName = PocketPositions.topLeftCorner;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error resetting ball positions: $e')),
        );
      }
    }
  }

  TableCoordinate? _getSelectedPocketCoordinate() {
    return PocketPositions.getTableCoordinate(_selectedPositionName);
  }

  (String angleText, String fractionText) _computeAngleAndFractionTexts() {
    final cue = _tableState.getBallCenter('cue');
    final object = _tableState.getBallCenter('object');
    final pocket = _getSelectedPocketCoordinate();

    return CalculationEngine.computeAngleAndFractionTexts(
      cue: cue,
      object: object,
      pocket: pocket,
      ballRadius: _tableState.ballRadiusNormalized,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pool Angle Calculator'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const buttonSize = 32.0;
                      const buttonMargin = 8.0;
                      const outerMargin = buttonSize + buttonMargin;

                      if (constraints.maxWidth <= outerMargin * 2 ||
                          constraints.maxHeight <= outerMargin * 2) {
                        return const SizedBox.shrink();
                      }

                      final dimensions = _tableState.dimensions;
                      final aspectRatio = dimensions.aspectRatio;
                      final borderNormalized = dimensions.borderThicknessNormalized;

                      final maxWidth = constraints.maxWidth;
                      final maxHeight = constraints.maxHeight;

                      final availableWidthForTable = maxWidth - (outerMargin * 2);
                      final availableHeightForTable = maxHeight - (outerMargin * 2);

                      final widthDenominator = 1 + (2 * borderNormalized);
                      final heightDenominator = (1 / aspectRatio) + (2 * borderNormalized);

                      final tableWidthByWidth =
                          availableWidthForTable / (widthDenominator <= 0 ? 1 : widthDenominator);
                      final tableWidthByHeight =
                          availableHeightForTable / (heightDenominator <= 0 ? (1 / aspectRatio) : heightDenominator);

                      final tableWidthPixels = tableWidthByWidth < tableWidthByHeight
                          ? tableWidthByWidth
                          : tableWidthByHeight;
                      final tableHeightPixels = tableWidthPixels / aspectRatio;

                      final borderThicknessPixels =
                          dimensions.borderThicknessNormalized * tableWidthPixels;

                      final groupWidth =
                          tableWidthPixels + (2 * (borderThicknessPixels + outerMargin));
                      final groupHeight =
                          tableHeightPixels + (2 * (borderThicknessPixels + outerMargin));

                      final groupLeft = (maxWidth - groupWidth) / 2;
                      final groupTop = (maxHeight - groupHeight) / 2;

                      final tableLeft = groupLeft + outerMargin + borderThicknessPixels;
                      final tableTop = groupTop + outerMargin + borderThicknessPixels;

                      final converter = CoordinateConverter(
                        tableDimensions: dimensions,
                        screenLayout: ScreenTableLayout(
                          tableWidthPixels: tableWidthPixels,
                          tableHeightPixels: tableHeightPixels,
                          tableLeftPixels: tableLeft,
                          tableTopPixels: tableTop,
                        ),
                      );

                      final dragHandler = BallDragHandler(
                        tableState: _tableState,
                        converter: converter,
                      );

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: converter.tableLeftPixels - borderThicknessPixels,
                            top: converter.tableTopPixels - borderThicknessPixels,
                            child: TableBoundaryWidget(
                              tableWidth: converter.tableWidthPixels,
                              tableHeight: converter.tableHeightPixels,
                              borderThickness: borderThicknessPixels,
                            ),
                          ),
                          Positioned(
                            left: converter.tableLeftPixels,
                            top: converter.tableTopPixels,
                            child: Stack(
                              children: [
                                PoolTableWidget(
                                  width: converter.tableWidthPixels,
                                  height: converter.tableHeightPixels,
                                ),
                                TableGridOverlay(
                                  width: converter.tableWidthPixels,
                                  height: converter.tableHeightPixels,
                                  columns: 6,
                                  rows: 3,
                                ),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: ShotGuideOverlay(
                              converter: converter,
                              cueBallCenter: _tableState.getBallCenter('cue'),
                              objectBallCenter: _tableState.getBallCenter('object'),
                              pocket: _getSelectedPocketCoordinate(),
                            ),
                          ),
                          ..._tableState.allBalls.map((ball) => DraggableBallWidget(
                                key: ValueKey(ball.id),
                                ball: ball,
                                dragHandler: dragHandler,
                                converter: converter,
                                onPositionChanged: () => setState(() {}),
                                onDragEnd: () => _saveBallPosition(ball.id),
                              )),
                          PocketSelectorButtons(
                            converter: converter,
                            storageHelper: _storageHelper,
                            selectedPositionName: _selectedPositionName,
                            onSelectionChanged: (name) {
                              setState(() {
                                _selectedPositionName = name;
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Builder(
                  builder: (context) {
                    final (angleText, fractionText) = _computeAngleAndFractionTexts();

                    return BottomDeck(
                      height: 140,
                      items: [
                        SliderDeckItem(
                          label: 'Ball',
                          value: _tableState.dimensions.ballDiameterInches,
                          min: 1.0,
                          max: 5.0,
                          onChanged: (value) {
                            setState(() {
                              _tableState.updateBallDiameter(value);
                            });
                            _storageHelper.setBallDiameterInches(value);
                          },
                        ),
                        SliderDeckItem(
                          label: 'Border',
                          value: _tableState.dimensions.borderThicknessInches,
                          min: 0.5,
                          max: 6.0,
                          onChanged: (value) {
                            setState(() {
                              _tableState.updateBorderThickness(value);
                            });
                            _storageHelper.setBorderThicknessInches(value);
                          },
                        ),
                        DeckResultItem(
                          angleText: angleText,
                          fractionText: fractionText,
                        ),
                        ResetDeckItem(onTap: _resetBallPositions),
                      ],
                    );
                  },
                ),
              ],
            ),
    );
  }
}
