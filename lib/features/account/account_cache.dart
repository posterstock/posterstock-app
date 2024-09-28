import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:poster_stock/features/account/profile_mapper.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

class AccountCache {
  Future<UserDetailsModel?> getProfileInfo() async {
    var box = await Hive.openBox('profileBox');
    var result = box.get('/');
    if (result == null) return null;
    return ProfileMapper.fromJson(json.decode(result));
  }

  Future<void> cacheProfileInfo(UserDetailsModel userDetailsModel) async {
    var box = await Hive.openBox('profileBox');
    box.put('/', json.encode(userDetailsModel));
  }

  Future<List<PostMovieModel>?> getPosters(int id, {required bool restart}) async {
    var box = await Hive.openBox('posterBox');
    var result = box.get(id);
    if (result == null) {
      return null;
    }
    return List<PostMovieModel>.from(
        jsonDecode(result).map((model) => PostMovieModel.fromJson(model)));
  }

  Future<void> cachePosters(int id, List<PostMovieModel>? posters) async {
    if (posters?.isEmpty ?? true) {
      return;
    }
    var box = await Hive.openBox('posterBox');
    box.put(
        id, jsonEncode(posters?.map((i) => i.toJson()).toList()).toString());
  }

  Future<List<PostMovieModel>?> getBookmarks() async {
    var box = await Hive.openBox('bookmarksBox');
    var result = box.get('my');
    if (result == null) {
      return null;
    }
    return List<PostMovieModel>.from(
        jsonDecode(result).map((model) => PostMovieModel.fromJson(model)));
  }

  Future<void> cacheBookmarks(List<PostMovieModel>? bookmarks) async {
    if (bookmarks?.isEmpty ?? true) {
      return;
    }
    var box = await Hive.openBox('bookmarksBox');
    box.put('my',
        jsonEncode(bookmarks?.map((i) => i.toJson()).toList()).toString());
  }

  Future<List<ListBaseModel>?> getLists(int id) async {
    var box = await Hive.openBox('listsBox');
    var result = box.get(id);
    if (result == null) {
      return null;
    }
    return List<ListBaseModel>.from(
        jsonDecode(result).map((model) => ListBaseModel.fromJson(model)));
  }

  Future<void> cacheLists(int id, List<ListBaseModel>? lists) async {
    if (lists?.isEmpty ?? true) {
      return;
    }
    var box = await Hive.openBox('listsBox');
    box.put(id, jsonEncode(lists?.map((i) => i.toJson()).toList()).toString());
  }
}
