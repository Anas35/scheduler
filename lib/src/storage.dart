
import 'dart:convert';

import 'package:scheduler/src/content.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {

  late final SharedPreferences sharedPreferences;

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static final instance = Storage._();

  Storage._();

  void addItem(List<Content> content) async {
    await sharedPreferences.setStringList('key', content.map((e) => jsonEncode(e.toJson())).toList());
  }

  List<Content> getItem() {
    final data = sharedPreferences.getStringList('key');
    if (data == null) {
      return [];
    }
    return data.map((e) => Content.fromJson(jsonDecode(e))).toList();
  }

  void setFile(String path) async {
    await sharedPreferences.setString('file', path);
  }

  String? getFile() {
    return sharedPreferences.getString('file');
  }

}