import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static final StorageHelper _instance = StorageHelper._internal();
  SharedPreferences? _prefs;

  factory StorageHelper() {
    return _instance;
  }

  StorageHelper._internal();

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<double?> getCueBallX() async {
    final preferences = await prefs;
    return preferences.getDouble('cue_ball_x');
  }

  Future<double?> getCueBallY() async {
    final preferences = await prefs;
    return preferences.getDouble('cue_ball_y');
  }

  Future<void> setCueBallPosition(double x, double y) async {
    final preferences = await prefs;
    await preferences.setDouble('cue_ball_x', x);
    await preferences.setDouble('cue_ball_y', y);
  }

  Future<double?> getObjectBallX() async {
    final preferences = await prefs;
    return preferences.getDouble('object_ball_x');
  }

  Future<double?> getObjectBallY() async {
    final preferences = await prefs;
    return preferences.getDouble('object_ball_y');
  }

  Future<void> setObjectBallPosition(double x, double y) async {
    final preferences = await prefs;
    await preferences.setDouble('object_ball_x', x);
    await preferences.setDouble('object_ball_y', y);
  }

  Future<void> resetBallPositions() async {
    final preferences = await prefs;
    await preferences.remove('cue_ball_x');
    await preferences.remove('cue_ball_y');
    await preferences.remove('object_ball_x');
    await preferences.remove('object_ball_y');
  }

  Future<String?> getSelectedPosition() async {
    final preferences = await prefs;
    return preferences.getString('selected_position_name');
  }

  Future<void> setSelectedPosition(String positionName) async {
    final preferences = await prefs;
    await preferences.setString('selected_position_name', positionName);
  }

  Future<void> clearSelectedPosition() async {
    final preferences = await prefs;
    await preferences.remove('selected_position_name');
  }

  Future<double?> getBallDiameterInches() async {
    final preferences = await prefs;
    return preferences.getDouble('ball_diameter_inches');
  }

  Future<void> setBallDiameterInches(double value) async {
    final preferences = await prefs;
    await preferences.setDouble('ball_diameter_inches', value);
  }

  Future<double?> getBorderThicknessInches() async {
    final preferences = await prefs;
    return preferences.getDouble('border_thickness_inches');
  }

  Future<void> setBorderThicknessInches(double value) async {
    final preferences = await prefs;
    await preferences.setDouble('border_thickness_inches', value);
  }
}

