import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/profile/state_holders/profile_bookmarks_state_holder.dart';

final bookmarkDetailsStateHolderProvider = StateNotifierProvider.family
    .autoDispose<BookmarkDetailsStateHolder, PostMovieModel, int>(
        (ref, mediaId) {
  final profileBookmarks = ref.read(profileBookmarksStateHolderProvider)!;
  final bookmark = profileBookmarks.firstWhere((it) => it.mediaId == mediaId);
  return BookmarkDetailsStateHolder(bookmark);
});

class BookmarkDetailsStateHolder extends StateNotifier<PostMovieModel> {
  BookmarkDetailsStateHolder(super.state);
}
