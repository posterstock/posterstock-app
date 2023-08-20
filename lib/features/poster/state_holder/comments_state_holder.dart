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

  Future<void> clearComments() async {
    state = null;
  }
}
