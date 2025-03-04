import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/list/repository/list_repository.dart';
import 'package:poster_stock/features/list/state_holder/list_state_holder.dart';
import 'package:poster_stock/features/list/view/list_page.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/profile/state_holders/my_profile_info_state_holder.dart';

final listsControllerProvider = Provider<ListsController>(
  (ref) => ListsController(
    commentsStateHolder: ref.watch(commentsStateHolderProvider.notifier),
    posterStateHolder: ref.watch(listsStateHolderProvider.notifier),
    profileStateHolder: ref.watch(myProfileInfoStateHolderProvider.notifier),
  ),
);

class ListsController {
  final CommentsStateHolder commentsStateHolder;
  final ListStateHolder posterStateHolder;
  final MyProfileInfoStateHolder profileStateHolder;
  final postRepository = ListRepository();
  bool loadingComments = false;
  bool loadingPost = false;

  ListsController({
    required this.commentsStateHolder,
    required this.posterStateHolder,
    required this.profileStateHolder,
  });

  Future<void> clear() async {
    commentsStateHolder.clearComments();
    posterStateHolder.clear();
  }

  Future<void> postComment(final int id, final String text) async {
    final result = await postRepository.postComment(id, text);
    await commentsStateHolder.updateComments([result]);
  }

  Future<void> deleteComment(final int postId, final int id) async {
    await postRepository.deleteComment(postId, id);
    commentsStateHolder.deleteComment(id);
  }

  Future<void> updateComments(final int id) async {
    if (loadingComments) return;
    loadingComments = true;
    final result = await postRepository.getComments(id);
    await commentsStateHolder.updateComments(result);
    loadingComments = false;
  }

  Future<void> getPost(final int id) async {
    if (loadingPost) return;
    loadingPost = true;
    try {
      final result = await postRepository.getPost(id);
      await posterStateHolder.updateState(result);
    } catch (e) {
      Logger.e('Ошибка при получении поста $e');
      loadingPost = false;
    }
    loadingPost = false;
  }

  Future<void> getSpecialList(ListType type) async {
    final result = await postRepository.getSpecialList(
      profileStateHolder.currentState!.id,
      type,
    );
    await posterStateHolder.updateState(result);
  }

  Future<void> deleteList(int id) async {
    await postRepository.deleteList(id);
  }

  Future<MultiplePostModel> getPostbyId(int id) async {
    return await postRepository.getPost(id);
  }
}
