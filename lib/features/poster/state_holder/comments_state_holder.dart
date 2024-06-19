import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/poster/model/comment.dart';

final commentsStateHolderProvider =
    StateNotifierProvider<CommentsStateHolder, List<Comment>?>(
  (ref) => CommentsStateHolder(null),
);

class CommentsStateHolder extends StateNotifier<List<Comment>?> {
  CommentsStateHolder(super.state);

  Future<void> updateMoreComments(List<Comment>? comments) async {
    state = [...?state, ...?comments];
  }

  Future<void> updateComments(List<Comment>? comments) async {
    state = [...?comments];
  }

  Future<void> deleteComment(int id) async {
    for (int i = 0; i < (state?.length ?? 0); i++) {
      if (state![i].id == id) {
        state!.removeAt(i);
      }
    }
    state = [...?state];
  }

  Future<void> clearComments() async {
    state = null;
  }

  Future<void> setFollowed(int id, bool followed) async {
    for (int i = 0; i < (state?.length ?? 0); i++) {
      if (state![i].model.id == id) {
        state![i] = state![i].copyWith(
          model: state![i].model.copyWith(
                followed: followed,
              ),
        );
      }
    }
    state = [...?state];
  }
}
