import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/list/repository/list_repository.dart';
import 'package:poster_stock/features/list/state_holder/list_state_holder.dart';
import 'package:poster_stock/features/poster/repository/post_repository.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';

final listsControllerProvider = Provider<ListsController>(
  (ref) => ListsController(
    commentsStateHolder: ref.watch(commentsStateHolderProvider.notifier),
    posterStateHolder: ref.watch(listsStateHolderProvider.notifier),
  ),
);

class ListsController {
  final CommentsStateHolder commentsStateHolder;
  final ListStateHolder posterStateHolder;
  final postRepository = ListRepository();
  bool loadingComments = false;
  bool loadingPost = false;

  ListsController({
    required this.commentsStateHolder,
    required this.posterStateHolder,
  });

  Future<void> clear() async {
    commentsStateHolder.clearComments();
    posterStateHolder.clear();
  }

  Future<void> postComment(final int id, final String text) async {
    final result = await postRepository.postComment(id, text);
    await commentsStateHolder.updateComments([result]);
  }

  Future<void> updateComments(final int id) async {
    if (loadingComments) return;
    loadingComments = true;
    final result = await postRepository.getComments(id);
    await commentsStateHolder.updateComments(result);
    loadingComments = false;
  }

  Future<void> getPost(final int id) async {
    print('aab $id');
    if (loadingPost) return;
    loadingPost = true;
    print(11);
    try {
      final result = await postRepository.getPost(id);
      print(result);
      await posterStateHolder.updateState(result);
    } catch (e) {
      print(e);
      loadingPost = false;
    }
    loadingPost = false;
  }
}
