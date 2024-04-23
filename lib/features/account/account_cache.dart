import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:poster_stock/features/account/profile_mapper.dart';
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

  Future<List<PostMovieModel>?> getPosters(int id) async {
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

  PostMovieModel _fromJson(Map<String, dynamic> json) =>
      PostMovieModel.fromJson(json, previewPrimary: true);
}
