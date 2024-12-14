import 'dart:convert';

import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/poster/data/cached_post_service.dart';
import 'package:poster_stock/features/poster/data/post_service.dart';
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

  Future<List<Map<String, dynamic>>> getNFT(String address) async {
    return await service.getNFT(address);
  }

  /// получение коллекций по адресу
  Future<Map<String, dynamic>> getCollections(String address) async {
    return await service.getCollections(address);
  }

  Future<bool> getInCollection(int id) async {
    return await service.getInCollection(id);
  }

  Future<void> deletePost(int id) async {
    await service.deletePost(id);
  }

  Future<void> addPosterToList(MultiplePostModel listId, int posterId) async {
    await service.addPosterToList(listId, posterId);
  }

  Future<void> setBookmarked(int id, bool bookmarked) async {
    await service.setBookmarked(id, bookmarked);
  }
}

class CachedPostRepository {
  final service = CachedPostService();

  Future<List<Comment>?> getComments(int id) async {
    var result = await service.getComments(id);
    if (result == null) return null;

    return result.map((e) => Comment.fromJson(e)).toList();
  }

  Future<void> cacheComments(int id, List<Comment> comments) async {
    await service.cacheComments(id, jsonEncode(comments));
  }

  // Future<Comment> postComment(int id, String text) async {
  //   return Comment.fromJson(await service.postComment(id, text));
  // }

  // Future<void> deleteComment(int postId, int id) async {
  //   return await service.deleteComment(postId, id);
  // }
  //
  // Future<Comment> postCommentList(int id, String text) async {
  //   return Comment.fromJson(await service.postCommentList(id, text));
  // }

  Future<PostMovieModel?> getPost(int id) async {
    var result = await service.getPost(id);
    if (result == null) return null;
    return PostMovieModel.fromJson(result);
  }

  Future<void> cachePost(int id, PostMovieModel postMovieModel) async {
    await service.cachePost(id, jsonEncode(postMovieModel));
  }

  Future<bool?> getInCollection(int id) async {
    return await service.getInCollection(id);
  }

  Future<void> cacheCollection(int id, bool value) async {
    await service.cacheCollection(id, value);
  }

// Future<void> deletePost(int id) async {
//   await service.deletePost(id);
// }

// Future<void> addPosterToList(MultiplePostModel listId, int posterId) async {
//   await service.addPosterToList(listId, posterId);
// }
//
// Future<void> setBookmarked(int id, bool bookmarked) async {
//   await service.setBookmarked(id, bookmarked);
// }
}
