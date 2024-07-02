import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:poster_stock/features/home/data/cached_home_service.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';

class CachedHomeRepository {
  final CachedHomeService service = CachedHomeService();

  Future<List<PostBaseModel>?> getPosts() async {
    try {
      var result = await service.getPosts();
      if (result == null) return null;
      return List<PostBaseModel>.from(jsonDecode(result).map((model) {
        if (model['type'] == 'poster') {
          return PostMovieModel.fromJson(model);
        } else if (model['type'] == 'list') {
          return MultiplePostModel.fromJson(model);
        }
      }));
    } catch (e) {
      if (kDebugMode) {
        Logger.e('Ошибка getPosts $e ');
      }
    }
    return null;
  }

  Future<void> cachePosts(List<PostBaseModel> postMovieModels) async {
    try {
      await service.cachePosts(postMovieModels);
    } catch (e) {
      if (kDebugMode) {
        Logger.e('Ошибка cachePosts $e ');
      }
    }
  }
}
