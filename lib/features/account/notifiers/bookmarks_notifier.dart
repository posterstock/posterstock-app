import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/account/account_network.dart';
import 'package:poster_stock/features/account/notifiers/account_notifier.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

final accountBookmarksStateNotifier =
    StateNotifierProvider<BookmarksNotifier, BookmarksState>(
  (ref) => BookmarksNotifier(ref.watch(accountNotifier.notifier)).._init(),
);

class BookmarksNotifier extends StateNotifier<BookmarksState> {
  BookmarksNotifier(this.accountNotifier)
      : super(const BookmarksState.holder());
  final AccountNotifier accountNotifier;
  final AccountNetwork network = AccountNetwork();
  bool _hasMore = true;
  bool _loading = false;

  int get _id => accountNotifier.account!.id;

  Future<void> _init() async {
    log('account: ${accountNotifier.account}, state: $state');
    if (accountNotifier.account == null) return;
    load();
  }

  Future<void> tryLoad() async {
    if (!_hasMore) return;
    await reload();
  }

  //TODO: redundant, replace by tryLoad() and load()
  Future<void> load() async {
    if (!_hasMore) return;
    final (list, more) = await network.getBookmarks();
    if (list?.isEmpty ?? true) {
      state = const BookmarksState.empty();
    } else {
      state = BookmarksState.list(list!);
    }
    _hasMore = more;
  }

  Future<void> deleteBookmark(int bookmarkId) async {
    await network.removeBookmark(bookmarkId);
    final (list, more) = await network.getBookmarks(restart: true);
    state = BookmarksState.top(list!);
    _hasMore = more;
    await accountNotifier.load();
  }

  Future<void> reload() async {
    final (list, more) = await network.getBookmarks(restart: true);
    state = BookmarksState.top(list!);
    _hasMore = more;
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    if (_loading) return;
    _loading = true;
    final (list, hasMore) = await network.getBookmarks();
    _loading = false;
    state = state + list!;
    _hasMore = hasMore;
  }
}

class BookmarksState {
  final bool top;
  final List<PostMovieModel?> bookmarks;

  const BookmarksState(this.top, this.bookmarks);

  const BookmarksState.list(this.bookmarks) : top = false;

  const BookmarksState.top(this.bookmarks) : top = true;

  const BookmarksState.holder()
      : top = false,
        bookmarks = const [
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null
        ]; //9

  const BookmarksState.empty()
      : top = false,
        bookmarks = const [];

  operator +(List<PostMovieModel> moreBookmarks) =>
      BookmarksState(false, bookmarks + moreBookmarks);
}
