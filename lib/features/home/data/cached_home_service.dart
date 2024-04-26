import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';

class CachedHomeService {
  Future<String?> getPosts() async {
    var box = await Hive.openBox('postsBox');
    var result = box.get('feed');
    if (result == null) return null;
    return result;
  }

  Future<void> cachePosts(List<PostBaseModel> posts) async {
    var box = await Hive.openBox('postsBox');
    String encoded = jsonEncode(posts.map((element) {
      if (element is PostMovieModel) {
        return element.toJson();
      } else if (element is MultiplePostModel) {
        return element.toJson();
      } else {}
    }).toList())
        .toString();
    box.put('feed', encoded);
  }
}
