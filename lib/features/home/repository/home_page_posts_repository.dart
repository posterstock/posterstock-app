import 'package:poster_stock/features/home/data/home_page_api.dart';
import 'package:poster_stock/features/home/data/i_home_page_api.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/repository/i_home_page_posts_repository.dart';

class HomePagePostsRepository implements IHomePagePostsRepository {
  final IHomePageApi api = HomePageApi();

  @override
  Future<(List<List<PostBaseModel>>?, bool)?> getPosts(
      {bool getNesPosts = false}) async {
    try {
      final apiResult = await api.getPosts(getNewPosts: getNesPosts);
      if (apiResult == null) return null;
      List<List<PostBaseModel>> result = [];
      final list = apiResult.$1?['entries'];
      for (var element in list) {
        if (element['type'] == 'poster') {
          result.add([PostMovieModel.fromJson(element)]);
        } else if (element['type'] == 'list') {
          result.add([MultiplePostModel.fromJson(element)]);
        } else {}
      }
      return (result, apiResult.$2);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> setLike(int? id, bool like) async {
    if (id == null) return;
    try {
      await api.setLike(id, like);
    } catch (e) {
      print(e);
    }
  }
}
