import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/list/data/list_service.dart';
import 'package:poster_stock/features/poster/data/comments_service.dart';
import 'package:poster_stock/features/poster/model/comment.dart';

class ListRepository {
  final service = ListService();

  Future<List<Comment>> getComments(int id) async {
    return (await service.getComments(id))
        .map((e) => Comment.fromJson(e))
        .toList();
  }

  Future<Comment> postComment(int id, String text) async {
    return Comment.fromJson(await service.postComment(id, text));
  }

  Future<MultiplePostModel> getPost(int id) async {
    print(18);
    return MultiplePostModel.fromJson(await service.getPost(id));
  }
}
