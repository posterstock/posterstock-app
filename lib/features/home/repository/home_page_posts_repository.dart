import 'package:poster_stock/features/home/data/i_home_page_api.dart';
import 'package:poster_stock/features/home/data/mock_home_page_api.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/repository/i_home_page_posts_repository.dart';

class HomePagePostsRepository implements IHomePagePostsRepository {
  final IHomePageApi api = MockHomePageApi();

  @override
  Future<List<List<PostBaseModel>>> getPosts() async {
    final apiResult = await api.getPosts('MockToken', 0);
    List<List<PostBaseModel>> result = [];
    final list = apiResult['data']['posts'] as List<Map<String, dynamic>>;
    for (var element in list) {
      if (element['collection'] != null) {
        result.add(
          (element['collection'] as List<Map<String, dynamic>>)
              .map((e) => PostMovieModel.fromJson(e))
              .toList(),
        );
      } else if (element['year'] == null) {
        result.add([MultiplePostModel.fromJson(element)]);
      } else {
        result.add([PostMovieModel.fromJson(element)]);
      }
    }
    return result;
  }
}
