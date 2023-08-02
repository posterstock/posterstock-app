import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/poster/data/comments_service.dart';
import 'package:poster_stock/features/poster/model/comment.dart';

class PostRepository {
  final service = PostService();

  Future<List<Comment>> getComments(String token, int id) async {
    return (await service.getComments(token, id))
        .map((e) => Comment.fromJson(e))
        .toList();
  }

  Future<Comment> postComment(String token, int id, String text) async {
    return Comment.fromJson(await service.postComment(token, id, text));
  }


  Future<PostMovieModel> getPost(String token, int id) async {
      return PostMovieModel.fromJson(await service.getPost(token, id));
  }


}
