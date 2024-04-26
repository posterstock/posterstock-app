import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class CachedPostService {
  Future<Map<String, dynamic>?> getPost(int id) async {
    var box = await Hive.openBox('postBox');
    var result = box.get(id);
    if (result == null) return null;
    return jsonDecode(result);
  }

  Future<void> cachePost(int id, String post) async {
    var box = await Hive.openBox('postBox');
    box.put(id, post);
  }

  Future<List?> getComments(int id) async {
    var box = await Hive.openBox('commentsBox');
    var result = box.get(id);
    if (result == null) return null;
    return jsonDecode(result);
  }

  Future<void> cacheComments(int id, String comments) async {
    var box = await Hive.openBox('commentsBox');
    box.put(id, comments);
  }

  Future<bool?> getInCollection(int id) async {
    var box = await Hive.openBox('collectionBox');
    var result = box.get(id);
    if (result == null) return null;
    return result;
  }

  Future<void> cacheCollection(int id, bool collection) async {
    var box = await Hive.openBox('collectionBox');
    box.put(id, collection);
  }
}
