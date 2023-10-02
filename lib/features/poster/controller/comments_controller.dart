import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/list/repository/list_repository.dart';
import 'package:poster_stock/features/poster/repository/post_repository.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/my_lists_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/features/profile/repository/profile_repository.dart';
import 'package:poster_stock/features/profile/state_holders/my_profile_info_state_holder.dart';

final commentsControllerProvider = Provider<CommentsController>(
      (ref) =>
      CommentsController(
        commentsStateHolder: ref.watch(commentsStateHolderProvider.notifier),
        posterStateHolder: ref.watch(posterStateHolderProvider.notifier),
        myProfileInfoStateHolder: ref.watch(myProfileInfoStateHolderProvider.notifier),
        myListsStateHolder: ref.watch(myListsStateHolderProvider.notifier),
      ),
);

class CommentsController {
  final CommentsStateHolder commentsStateHolder;
  final PosterStateHolder posterStateHolder;
  final MyProfileInfoStateHolder myProfileInfoStateHolder;
  final MyListsStateHolder myListsStateHolder;
  final ListRepository listRepository = ListRepository();
  final profileRepo = ProfileRepository();
  final postRepository = PostRepository();
  bool loadingComments = false;
  bool loadingPost = false;

  CommentsController({
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
    print('comm$id');
    if (loadingComments) return;
    loadingComments = true;
    final result =
    await postRepository.getComments(id);
    print(result);
    await commentsStateHolder.updateComments(result);
    loadingComments = false;
  }

  Future<void> getPost(final int id) async {
    print('comm$id');
    print('aa $id');
    if (loadingPost) return;
    print(11);
    //await Future.delayed(Duration(milliseconds: 500));
    loadingPost = true;
    var result = await postRepository.getPost(id);
    var splitted = result.tmdbLink!.split('/');
    if (splitted.last.isEmpty) splitted.removeLast();
    int tmdbId = result.mediaId ?? int.parse(splitted.last);
    final hasInCollection = await postRepository.getInCollection(tmdbId);
    result = result.copyWith(hasInCollection: hasInCollection);
    await posterStateHolder.updateState(result);
    loadingPost = false;
  }

  Future<void> deletePost(final int id) async {
    await postRepository.deletePost(id);
  }

  Future<void> addPosterToList(int listId, int postId) async {
    final list = await listRepository.getPost(listId);
    await postRepository.addPosterToList(list, postId);
  }

  Future<void> getMyLists() async {
    final result = await profileRepo.getProfileLists(myProfileInfoStateHolder.state!.id);
    myListsStateHolder.updateLists(result);
  }

  Future<void> setBookmarked(int id, bool bookmarked) async {
    await posterStateHolder.updateBookmarked(bookmarked);
    postRepository.setBookmarked(id, bookmarked);
  }
}
