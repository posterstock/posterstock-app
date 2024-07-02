import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/list/data/list_service.dart';
import 'package:poster_stock/features/list/view/list_page.dart';
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

  Future<void> deleteComment(int postId, int id) async {
    await service.deleteComment(postId, id);
  }

  Future<MultiplePostModel> getPost(int id) async {
    return MultiplePostModel.fromJson(await service.getPost(id));
  }

  Future<MultiplePostModel> getSpecialList(int userId, ListType type) async {
    final json = await service.getSpecialList(userId, type);
    return MultiplePostModel.fromJson(json);
  }

  Future<void> deleteList(int id) async {
    await service.deleteList(id);
  }

  Future<void> changeDefaultLang(String lang) async {
    await service.changeDefaultLang(lang);
  }
}
