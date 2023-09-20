import 'package:poster_stock/features/bookmarks/data/bookmarks_service.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';

class BookmarksRepository {
  final _service = BookmarksService();

  Future<(List<PostMovieModel>?, bool)> getBookmarks(int id, {bool restart = false}) async {
    final result = await _service.getBookmarks(id, restart: restart);
    return (result.$1.map((e) => PostMovieModel.fromJson(e)).toList(), result.$2);
  }
}