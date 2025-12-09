import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pool_calculator/backend/models/image_mark.dart';

class ImageMarkRepository {
  static const String _marksKey = 'image_marks';
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<List<ImageMark>> getMarks() async {
    final preferences = await prefs;
    final jsonString = preferences.getString(_marksKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => ImageMark.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveMarks(List<ImageMark> marks) async {
    final preferences = await prefs;
    final jsonList = marks.map((mark) => mark.toJson()).toList();
    await preferences.setString(_marksKey, jsonEncode(jsonList));
  }

  Future<void> addMark(ImageMark mark) async {
    final marks = await getMarks();
    marks.add(mark);
    await saveMarks(marks);
  }

  Future<void> clearMarks() async {
    final preferences = await prefs;
    await preferences.remove(_marksKey);
  }

  Future<void> removeMark(String markId) async {
    final marks = await getMarks();
    marks.removeWhere((mark) => mark.id == markId);
    await saveMarks(marks);
  }

  Future<void> removeLastMark() async {
    final marks = await getMarks();
    if (marks.isNotEmpty) {
      marks.removeLast();
      await saveMarks(marks);
    }
  }
}

