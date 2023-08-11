import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/poster/data/comments_service.dart';
import 'package:poster_stock/features/poster/model/comment.dart';

class PostRepository {
  final service = PostService();

  Future<List<Comment>> getComments(int id) async {
    return (await service.getComments(id))
        .map((e) => Comment.fromJson(e))
        .toList();
  }

  Future<Comment> postComment(int id, String text) async {
    return Comment.fromJson(await service.postComment(id, text));
  }

  Future<PostMovieModel> getPost(int id) async {
    return PostMovieModel.fromJson(await service.getPost(id));
  }
}
