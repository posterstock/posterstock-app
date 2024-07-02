import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/list/repository/list_repository.dart';
import 'package:poster_stock/features/poster/repository/post_repository.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/my_lists_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/features/profile/repository/profile_repository.dart';
import 'package:poster_stock/features/profile/state_holders/my_profile_info_state_holder.dart';

final postControllerProvider = Provider<PostController>(
  (ref) => PostController(
    commentsStateHolder: ref.watch(commentsStateHolderProvider.notifier),
    posterStateHolder: ref.watch(posterStateHolderProvider.notifier),
    myProfileInfoStateHolder:
        ref.watch(myProfileInfoStateHolderProvider.notifier),
    myListsStateHolder: ref.watch(myListsStateHolderProvider.notifier),
  ),
);

class PostController {
  final CommentsStateHolder commentsStateHolder;
  final PosterStateHolder posterStateHolder;
  final MyProfileInfoStateHolder myProfileInfoStateHolder;
  final MyListsStateHolder myListsStateHolder;
  final ListRepository listRepository = ListRepository();
  final profileRepo = ProfileRepository();
  final postRepository = PostRepository();
  final cachedPostRepository = CachedPostRepository();

  bool loadingComments = false;
  bool loadingPost = false;

  PostController({
    required this.commentsStateHolder,
    required this.posterStateHolder,
    required this.myProfileInfoStateHolder,
    required this.myListsStateHolder,
  });

  Future<void> clear() async {
    commentsStateHolder.clearComments();
    posterStateHolder.clear();
  }

  Future<void> postComment(final int id, final String text) async {
    final result = await postRepository.postComment(id, text);
    await commentsStateHolder.updateMoreComments([result]);
  }

  Future<void> deleteComment(final int postId, final int id) async {
    await postRepository.deleteComment(postId, id);
    commentsStateHolder.deleteComment(id);
  }

  Future<void> postCommentList(final int id, final String text) async {
    final result = await postRepository.postCommentList(id, text);
    await commentsStateHolder.updateMoreComments([result]);
  }

  Future<void> updateComments(final int id) async {
    if (loadingComments) return;
    loadingComments = true;

    var result = await cachedPostRepository.getComments(id);
    if (result != null) {
      await commentsStateHolder.updateComments(result);
      loadingComments = false;
    }

    result = await postRepository.getComments(id);
    cachedPostRepository.cacheComments(id, result);
    await commentsStateHolder.updateComments(result);
    loadingComments = false;
  }

  Future<void> getPost(final int id) async {
    if (loadingPost) return;
    //await Future.delayed(Duration(milliseconds: 500));
    loadingPost = true;
    var result = await cachedPostRepository.getPost(id);
    if (result != null) {
      result = await _prepareData(result, cached: true);
      await posterStateHolder.updateState(result);
      loadingPost = false;
    }

    result = await postRepository.getPost(id);
    cachedPostRepository.cachePost(id, result);
    result = await _prepareData(result);
    await posterStateHolder.updateState(result);
    loadingPost = false;
  }

  Future<PostMovieModel> _prepareData(PostMovieModel result,
      {bool cached = false}) async {
    var splitted = result.tmdbLink!.split('/');
    if (splitted.last.isEmpty) splitted.removeLast();
    int tmdbId = result.mediaId ?? int.parse(splitted.last);
    bool? hasInCollection = await cachedPostRepository.getInCollection(tmdbId);
    if (!cached || hasInCollection == null) {
      hasInCollection = await postRepository.getInCollection(tmdbId);
      cachedPostRepository.cacheCollection(tmdbId, hasInCollection);
    }
    return result.copyWith(hasInCollection: hasInCollection);
  }

  Future<void> deletePost(final int id) async {
    await postRepository.deletePost(id);
  }

  Future<void> addPosterToList(int listId, int postId) async {
    final list = await listRepository.getPost(listId);
    await postRepository.addPosterToList(list, postId);
  }

  Future<void> getMyLists() async {
    final result = await profileRepo
        .getProfileLists(myProfileInfoStateHolder.currentState!.id);
    myListsStateHolder.updateLists(result);
  }

  Future<void> setBookmarked(int id, bool bookmarked) async {
    await posterStateHolder.updateBookmarked(bookmarked);
    postRepository.setBookmarked(id, bookmarked);
  }
}
