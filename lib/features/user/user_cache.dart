import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:poster_stock/features/account/profile_mapper.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

class UserCache {
  Future<UserDetailsModel?> getProfileInfo(int id) async {
    var box = await Hive.openBox('profileBox');
    var result = box.get(id);
    if (result == null) return null;
    return ProfileMapper.fromJson(json.decode(result));
  }

  Future<void> cacheUserInfo(int id, UserDetailsModel userDetailsModel) async {
    var box = await Hive.openBox('profileBox');
    box.put(id, json.encode(userDetailsModel));
  }

  Future<List<PostMovieModel>?> getUserPosts(int id) async {
    var box = await Hive.openBox('posterBox');
    var result = box.get(id);
    if (result == null) {
      return null;
    }
    return List<PostMovieModel>.from(
        jsonDecode(result).map((model) => PostMovieModel.fromJson(model)));
  }

  Future<void> cacheUserPosts(int id, List<PostMovieModel>? posters) async {
    if (posters?.isEmpty ?? true) {
      return;
    }
    var box = await Hive.openBox('posterBox');
    box.put(
        id, jsonEncode(posters?.map((i) => i.toJson()).toList()).toString());
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
