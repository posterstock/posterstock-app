import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
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

  Future<void> deleteComment(int postId, int id) async {
    return await service.deleteComment(postId, id);
  }

  Future<Comment> postCommentList(int id, String text) async {
    return Comment.fromJson(await service.postCommentList(id, text));
  }

  Future<PostMovieModel> getPost(int id) async {
    return PostMovieModel.fromJson(await service.getPost(id));
  }

  Future<bool> getInCollection(int id) async {
    return await service.getInCollection(id);
  }


  Future<void> deletePost(int id) async {
    await service.deletePost(id);
  }

  Future<void> addPosterToList(MultiplePostModel listId, int posterId) async {
    await service.addPosterToList(listId,posterId);
  }


  Future<void> setBookmarked(int id, bool bookmarked) async {
    await service.setBookmarked(id, bookmarked);
  }
}
