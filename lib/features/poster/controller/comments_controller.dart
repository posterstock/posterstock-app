import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/poster/repository/post_repository.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';

final commentsControllerProvider = Provider<CommentsController>(
      (ref) =>
      CommentsController(
        commentsStateHolder: ref.watch(commentsStateHolderProvider.notifier),
        posterStateHolder: ref.watch(posterStateHolderProvider.notifier),
      ),
);

class CommentsController {
  final CommentsStateHolder commentsStateHolder;
  final PosterStateHolder posterStateHolder;
  final postRepository = PostRepository();
  bool loadingComments = false;
  bool loadingPost = false;

  CommentsController({
    required this.commentsStateHolder,
    required this.posterStateHolder,
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
    await Future.delayed(Duration(milliseconds: 500));
    loadingPost = true;
    final result = await postRepository.getPost(id);
    print(result);
    await posterStateHolder.updateState(result);
    loadingPost = false;
  }

  Future<void> deletePost(final int id) async {
    await postRepository.deletePost(id);
  }

  Future<void> setBookmarked(int id, bool bookmarked) async {
    await posterStateHolder.updateBookmarked(bookmarked);
    postRepository.setBookmarked(id, bookmarked);
  }
}
