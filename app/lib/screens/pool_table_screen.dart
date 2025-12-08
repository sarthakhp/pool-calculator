import 'package:flutter/material.dart';
import 'package:pool_calculator/backend/models/ball_position.dart';
import 'package:pool_calculator/backend/repositories/ball_position_repository.dart';
import 'package:pool_calculator/backend/database/storage_helper.dart';
import 'package:pool_calculator/domain/domain.dart';
import 'package:pool_calculator/presentation/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _isSideDeckExpanded = true;

  double _tableWidthPixels = 0;
  double _tableHeightPixels = 0;
  double _tableLeftPixels = 0;
  double _tableTopPixels = 0;
  CoordinateConverter? _converter;

  @override
  void initState() {
    super.initState();
    _tableState = PoolTableState();
    _tableState.initializeDefaultBalls();
    _loadBallPositions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      InfoDialog.show(context);
    });
  }

  Future<void> _loadBallPositions() async {
    try {
      final cueBallPos = await _ballPositionRepository.getCueBallPosition();
      final objectBallPos = await _ballPositionRepository.getObjectBallPosition();
      final savedBallDiameter = await _storageHelper.getBallDiameterInches();
      final savedBorderThickness = await _storageHelper.getBorderThicknessInches();
      final savedCueBallSpeed = await _storageHelper.getCueBallSpeed();
      final savedFriction = await _storageHelper.getFriction();

      setState(() {
        if (cueBallPos != null) {
          _tableState.moveBall('cue', TableCoordinate(cueBallPos.x, cueBallPos.y));
        }
        if (objectBallPos != null) {
          _tableState.moveBall('object', TableCoordinate(objectBallPos.x, objectBallPos.y));
        }
        if (savedBallDiameter != null) {
          _tableState.updateBallDiameter(savedBallDiameter);
        }
        if (savedBorderThickness != null) {
          _tableState.updateBorderThickness(savedBorderThickness);
        }
        if (savedCueBallSpeed != null) {
          _tableState.updateCueBallSpeed(savedCueBallSpeed);
        }
        if (savedFriction != null) {
          _tableState.updateFriction(savedFriction);
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
      setState(() {
        _tableState.resetToDefaults();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error resetting ball positions: $e')),
        );
      }
    }
  }

  (double? angleDegrees, double fraction, double sarthakFraction, ScreenCoordinate? ghostBallCenter, ScreenCoordinate? ghostBallAdjustedCenter) _compute() {
    final converter = _converter;
    if (converter == null) {
      return (null, 0.0, 0.0, null, null);
    }

    final cue = _tableState.getBallCenter('cue');
    final object = _tableState.getBallCenter('object');
    final target = _tableState.getBallCenter('target');

    return CalculationEngine.compute(
      cue: cue != null ? converter.tableToScreen(cue) : null,
      object: object != null ? converter.tableToScreen(object) : null,
      target: target != null ? converter.tableToScreen(target) : null,
      ballRadiusPixels: converter.ballRadiusPixels(),
      cueBallSpeed: _tableState.cueBallSpeed,
      friction: _tableState.friction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '8 BALL POOL Calculator',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'How to Use',
            onPressed: () => InfoDialog.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: _resetBallPositions,
          ),
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'View on GitHub',
            onPressed: () {
              launchUrl(Uri.parse('https://github.com/sarthakhp/pool-calculator'));
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final dimensions = _tableState.dimensions;
                final aspectRatio = dimensions.aspectRatio;
                final borderNormalized = dimensions.borderThicknessNormalized;

                final sideDeckExpandedWidth = constraints.maxWidth * 0.3;
                final sideDeckCollapsedWidth = sideDeckExpandedWidth * 0.13;
                final sideDeckWidth = _isSideDeckExpanded ? sideDeckExpandedWidth : sideDeckCollapsedWidth;
                final maxWidth = constraints.maxWidth - sideDeckWidth;
                final maxHeight = constraints.maxHeight;

                final widthDenominator = 1 + (2 * borderNormalized);
                final heightDenominator = (1 / aspectRatio) + (2 * borderNormalized);

                final rawTableWidthByWidth = maxWidth / widthDenominator;
                final rawTableWidthByHeight = maxHeight / heightDenominator;
                final rawTableWidth = rawTableWidthByWidth < rawTableWidthByHeight
                    ? rawTableWidthByWidth
                    : rawTableWidthByHeight;

                final outerMargin = rawTableWidth / 25;

                if (constraints.maxWidth <= outerMargin * 2 ||
                    constraints.maxHeight <= outerMargin * 2) {
                  return const SizedBox.shrink();
                }

                final availableWidthForTable = maxWidth - (outerMargin * 4);
                final availableHeightForTable = maxHeight - (outerMargin * 2);

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

                _tableWidthPixels = tableWidthPixels;
                _tableHeightPixels = tableHeightPixels;
                _tableLeftPixels = groupLeft + outerMargin + borderThicknessPixels;
                _tableTopPixels = groupTop + outerMargin + borderThicknessPixels;

                _converter = CoordinateConverter(
                  tableDimensions: dimensions,
                  screenLayout: ScreenTableLayout(
                    tableWidthPixels: _tableWidthPixels,
                    tableHeightPixels: _tableHeightPixels,
                    tableLeftPixels: _tableLeftPixels,
                    tableTopPixels: _tableTopPixels,
                  ),
                );

                final dragHandler = BallDragHandler(
                  tableState: _tableState,
                  converter: _converter!,
                );

                final (angleDegrees, fraction, sarthakFraction, ghostBallCenter, ghostBallAdjustedCenter) = _compute();
                // if (ghostBallCenter != null) {
                //   _tableState.updateGhostBall(_converter!.screenToTable(ghostBallCenter));
                // } else {
                //   _tableState.updateGhostBall(null);
                // }
                if (ghostBallAdjustedCenter != null) {
                  _tableState.updateGhostBallAdjusted(_converter!.screenToTable(ghostBallAdjustedCenter));
                } else {
                  _tableState.updateGhostBallAdjusted(null);
                }

                return Row(
                  children: [
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: _converter!.tableLeftPixels - borderThicknessPixels,
                            top: _converter!.tableTopPixels - borderThicknessPixels,
                            child: TableBoundaryWidget(
                              tableWidth: _converter!.tableWidthPixels,
                              tableHeight: _converter!.tableHeightPixels,
                              borderThickness: borderThicknessPixels,
                            ),
                          ),
                          Positioned(
                            left: _converter!.tableLeftPixels,
                            top: _converter!.tableTopPixels,
                            child: Stack(
                              children: [
                                PoolTableWidget(
                                  width: _converter!.tableWidthPixels,
                                  height: _converter!.tableHeightPixels,
                                ),
                                TableGridOverlay(
                                  width: _converter!.tableWidthPixels,
                                  height: _converter!.tableHeightPixels,
                                  columns: 8,
                                  rows: 4,
                                ),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: ShotGuideOverlay(
                              converter: _converter!,
                              cueBallCenter: _tableState.getBallCenter('cue'),
                              objectBallCenter: _tableState.getBallCenter('object'),
                              ghostBallAdjustedCenter: _tableState.getBallCenter('ghost_adjusted'),
                              targetBallCenter: _tableState.getBallCenter('target'),
                            ),
                          ),
                          ..._tableState.allBalls.where((ball) => ball.type != BallType.ghost).map((ball) => DraggableBallWidget(
                                key: ValueKey(ball.id),
                                ball: ball,
                                dragHandler: dragHandler,
                                converter: _converter!,
                                onPositionChanged: () => setState(() {}),
                                onDragEnd: () => _saveBallPosition(ball.id),
                              )),
                          if (_tableState.ghostBall != null)
                            Positioned(
                              left: _converter!.ballTopLeftScreen(_tableState.ghostBall!.center).x,
                              top: _converter!.ballTopLeftScreen(_tableState.ghostBall!.center).y,
                              child: BallWidget(
                                ball: _tableState.ghostBall!,
                                diameter: _converter!.ballDiameterPixels(),
                              ),
                            ),
                          if (_tableState.ghostBallAdjusted != null)
                            Positioned(
                              left: _converter!.ballTopLeftScreen(_tableState.ghostBallAdjusted!.center).x,
                              top: _converter!.ballTopLeftScreen(_tableState.ghostBallAdjusted!.center).y,
                              child: BallWidget(
                                ball: _tableState.ghostBallAdjusted!,
                                diameter: _converter!.ballDiameterPixels(),
                              ),
                            ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: sideDeckWidth,
                      child: _isSideDeckExpanded
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isSideDeckExpanded = false;
                                    });
                                  },
                                  child: Container(
                                    width: sideDeckCollapsedWidth,
                                    color: Colors.blueAccent,
                                    child: const Center(
                                      child: Icon(Icons.chevron_right, color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SideDeck(
                                    width: sideDeckExpandedWidth - sideDeckCollapsedWidth,
                                    items: [
                                      DeckOverlapItem(
                                        fraction: sarthakFraction,
                                      ),
                                      DeckResultItem(
                                        angleDegrees: angleDegrees,
                                        fraction: fraction,
                                        sarthakFraction: sarthakFraction,
                                      ),
                                      SliderDeckItem(
                                        label: 'Ball Size',
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
                                        label: 'Cue Ball Speed',
                                        value: _tableState.cueBallSpeed,
                                        min: 0,
                                        max: 2,
                                        onChanged: (value) {
                                          setState(() {
                                            _tableState.updateCueBallSpeed(value);
                                          });
                                          _storageHelper.setCueBallSpeed(value);
                                        },
                                        unit: '',
                                      ),
                                      SliderDeckItem(
                                        label: 'Friction',
                                        value: _tableState.friction,
                                        min: 0,
                                        max: 0.3,
                                        onChanged: (value) {
                                          setState(() {
                                            _tableState.updateFriction(value);
                                          });
                                          _storageHelper.setFriction(value);
                                        },
                                        unit: '',
                                      ),
                                      CoordinateInputDeckItem(
                                        label: 'Cue Ball Position',
                                        coordinate: _tableState.getBall('cue')?.position ?? const TableCoordinate(0, 0),
                                        onChanged: (coord) {
                                          setState(() {
                                            _tableState.moveBall('cue', coord);
                                          });
                                          _saveBallPosition('cue');
                                        },
                                      ),
                                      CoordinateInputDeckItem(
                                        label: 'Object Ball Position',
                                        coordinate: _tableState.getBall('object')?.position ?? const TableCoordinate(0, 0),
                                        onChanged: (coord) {
                                          setState(() {
                                            _tableState.moveBall('object', coord);
                                          });
                                          _saveBallPosition('object');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSideDeckExpanded = true;
                                });
                              },
                              child: Container(
                                width: sideDeckCollapsedWidth,
                                color: Colors.blueAccent,
                                child: const Center(
                                  child: Icon(Icons.chevron_left, color: Colors.white),
                                ),
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
