import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/poster/repository/post_repository.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';

final commentsControllerProvider = Provider<CommentsController>(
  (ref) => CommentsController(
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

  Future<void> clearComments() async {
    commentsStateHolder.clearComments();
    posterStateHolder.clearComments();
  }

  Future<void> postComment(final int id, final String text) async {
    final result = await postRepository.postComment( id, text);
    await commentsStateHolder.updateComments([result]);
  }

  Future<void> updateComments(final int id) async {
    if (loadingComments) return;
    loadingComments = true;
    final result =
        await postRepository.getComments( id);
    await commentsStateHolder.updateComments(result);
    loadingComments = false;
  }

  Future<void> getPost(final int id) async {
    if (loadingPost) return;
    loadingPost = true;
    final result = await postRepository.getPost( id);
    print(result);
    await posterStateHolder.updateState(result);
    loadingPost = false;
  }
}
