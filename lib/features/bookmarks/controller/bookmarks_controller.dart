import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/bookmarks/repository/bookmarks_repository.dart';
import 'package:poster_stock/features/bookmarks/state_holders/bookmark_id_state_holder.dart';
import 'package:poster_stock/features/bookmarks/state_holders/bookmark_list_state_holder.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';

final bookmarksControllerProvider = Provider<BookmarksController>(
  (ref) => BookmarksController(
    bookmarksIdStateHolder: ref.watch(bookmarksIdStateHolderProvider.notifier),
    // bookmarkHolder: ref.watch(bookmarkStateHolder.notifier),
    bookmarksListStateHolder:
        ref.watch(bookmarksListStateHolderProvider.notifier),
  ),
);

class BookmarksController {
  final BookmarksIdStateHolder bookmarksIdStateHolder;
  // final BookmarkStateHolder bookmarkHolder;
  final BookmarksListStateHolder bookmarksListStateHolder;
  final repository = BookmarksRepository();
  bool gettingBookmarks = false;
  bool gotAll = false;

  BookmarksController({
    required this.bookmarksIdStateHolder,
    // required this.bookmarkHolder,
    required this.bookmarksListStateHolder,
  });

  Future<void> getBookmarks({bool restart = false}) async {
    int? id = bookmarksIdStateHolder.currentState;
    if (gettingBookmarks) return;
    gettingBookmarks = true;
    if (id == null) {
      gettingBookmarks = false;
      return;
    }
    if (restart) gotAll = false;
    if (gotAll) {
      gettingBookmarks = false;
      return;
    }
    final result = await repository.getBookmarks(id, restart: restart);
    gotAll = result.$2;
    if (restart) {
      bookmarksListStateHolder.setState(result.$1);
    } else {
      bookmarksListStateHolder.updateState(result.$1);
    }
    gettingBookmarks = false;
  }

  Future<void> clearBookmarks() async {
    bookmarksListStateHolder.clearState();
  }

  Future<void> setId(int id) async {
    bookmarksIdStateHolder.setState(id);
  }
}

final bookmarkStateHolder =
    StateNotifierProvider<BookmarkStateHolder, PostMovieModel?>(
        (ref) => BookmarkStateHolder());

class BookmarkStateHolder extends StateNotifier<PostMovieModel?> {
  BookmarkStateHolder() : super(null);

  void setModel(PostMovieModel state) {
    state = state;
  }
}

/*
final bookmarksListStateHolderProvider =
    StateNotifierProvider<BookmarksListStateHolder, List<PostMovieModel>?>(
  (ref) => BookmarksListStateHolder(null),
);

class BookmarksListStateHolder extends StateNotifier<List<PostMovieModel>?> {
  BookmarksListStateHolder(super.state);

  void updateState(List<PostMovieModel>? value) {
    state = [...?state, ...?value];
  }

  void setState(List<PostMovieModel>? value) {
    state = value;
  }

  void clearState() {
    state = null;
  }
}
*/
