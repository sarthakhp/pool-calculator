import 'package:pool_calculator/backend/database/storage_helper.dart';
import 'package:pool_calculator/backend/models/ball_position.dart';

class BallPositionRepository {
  final StorageHelper _storageHelper = StorageHelper();

  Future<BallPosition?> getCueBallPosition() async {
    final x = await _storageHelper.getCueBallX();
    final y = await _storageHelper.getCueBallY();
    
    if (x == null || y == null) {
      return null;
    }
    
    return BallPosition(x: x, y: y);
  }

  Future<void> setCueBallPosition(BallPosition position) async {
    await _storageHelper.setCueBallPosition(position.x, position.y);
  }

  Future<BallPosition?> getObjectBallPosition() async {
    final x = await _storageHelper.getObjectBallX();
    final y = await _storageHelper.getObjectBallY();
    
    if (x == null || y == null) {
      return null;
    }
    
    return BallPosition(x: x, y: y);
  }

  Future<void> setObjectBallPosition(BallPosition position) async {
    await _storageHelper.setObjectBallPosition(position.x, position.y);
  }

  Future<void> resetBallPositions() async {
    await _storageHelper.resetBallPositions();
  }
}

