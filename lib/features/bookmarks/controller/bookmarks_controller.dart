import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/bookmarks/repository/bookmarks_repository.dart';
import 'package:poster_stock/features/bookmarks/state_holders/bookmark_id_state_holder.dart';
import 'package:poster_stock/features/bookmarks/state_holders/bookmark_list_state_holder.dart';

final bookmarksControllerProvider = Provider<BookmarksController>(
  (ref) => BookmarksController(
    bookmarksIdStateHolder: ref.watch(bookmarksIdStateHolderProvider.notifier),
    bookmarksListStateHolder:
        ref.watch(bookmarksListStateHolderProvider.notifier),
  ),
);

class BookmarksController {
  final BookmarksIdStateHolder bookmarksIdStateHolder;
  final BookmarksListStateHolder bookmarksListStateHolder;
  final repository = BookmarksRepository();
  bool gettingBookmarks = false;
  bool gotAll = false;

  BookmarksController({
    required this.bookmarksIdStateHolder,
    required this.bookmarksListStateHolder,
  });

  Future<void> getBookmarks({bool restart = false}) async {
    int? id = bookmarksIdStateHolder.state;
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
