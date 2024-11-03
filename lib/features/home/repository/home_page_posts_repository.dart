import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:poster_stock/features/home/data/home_page_api.dart';
import 'package:poster_stock/features/home/data/i_home_page_api.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/repository/i_home_page_posts_repository.dart';

class HomePagePostsRepository implements IHomePagePostsRepository {
  final IHomePageApi api = HomePageApi();

  @override
  Future<(List<PostBaseModel>?, bool)?> getPosts(String lang,
      {bool getNesPosts = false}) async {
    try {
      final apiResult = await api.getPosts(lang, getNewPosts: getNesPosts);
      if (apiResult == null) return null;
      List<PostBaseModel> result = [];
      final list = apiResult.$1?['entries'] ?? [];
      for (var element in list) {
        if (element['type'] == 'poster') {
          result.add(PostMovieModel.fromJson(element, previewPrimary: true));
        } else if (element['type'] == 'list') {
          result.add(MultiplePostModel.fromJson(element, previewPrimary: true));
        } else {}
      }
      return (result, apiResult.$2);
    } catch (e) {
      Logger.e('Ошибка при получении постов $e');
    }
    return null;
  }

  @override
  Future<void> setLike(int? id, bool like) async {
    if (id == null) return;
    try {
      await api.setLike(id, like);
    } catch (e) {
      Logger.e('Ошибка при установке лайка $e');
    }
  }

  @override
  Future<void> setLikeList(int? id, bool like) async {
    if (id == null) return;
    try {
      await api.setLikeList(id, like);
    } catch (e) {
      Logger.e('Ошибка при установке лайка на список $e');
    }
  }
}
