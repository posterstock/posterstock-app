import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/bookmarks/state_holders/bookmark_list_state_holder.dart';

import 'package:poster_stock/features/home/models/post_movie_model.dart';

final bookmarkDetailsStateHolderProvider = StateNotifierProvider.family
    .autoDispose<BookmarkDetailsStateHolder, PostMovieModel?, int>(
        (ref, mediaId) {
  final bookmarks = ref.watch(bookmarksListStateHolderProvider);

  Logger.d('profileBookmarks ${bookmarks?.length}');

  final bookmark = bookmarks?.firstWhere((it) => it.mediaId == mediaId);
  Logger.i('bookmark $bookmark');
  return BookmarkDetailsStateHolder(bookmark);
});

class BookmarkDetailsStateHolder extends StateNotifier<PostMovieModel?> {
  BookmarkDetailsStateHolder(super.state);
}
