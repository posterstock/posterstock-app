import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/account/account_cache.dart';
import 'package:poster_stock/features/account/account_network.dart';
import 'package:poster_stock/features/account/notifiers/account_notifier.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';

final accountBookmarksStateNotifier =
    StateNotifierProvider.autoDispose<BookmarksNotifier, BookmarksState>(
  (ref) => BookmarksNotifier(ref.watch(accountNotifier.notifier)).._init(),
);

class BookmarksNotifier extends StateNotifier<BookmarksState> {
  BookmarksNotifier(this.accountNotifier)
      : super(const BookmarksState.holder());
  final AccountNotifier accountNotifier;
  final AccountNetwork network = AccountNetwork();
  final AccountCache cache = AccountCache();
  bool _hasMore = true;
  bool _loading = false;

  int get _id => accountNotifier.account!.id;

  Future<void> _init() async {
    if (accountNotifier.account == null) return;
    load();
  }

  Future<void> tryLoad() async {
    if (!_hasMore) return;
    await reload();
  }

  //TODO: redundant, replace by tryLoad() and load()
  Future<void> load() async {
    if (!_hasMore || _loading) return;

    var cachedList = await cache.getBookmarks();
    if (cachedList != null) {
      state = BookmarksState.list(cachedList);
    }

    final (list, more) = await network.getBookmarks();
    cache.cacheBookmarks(list);
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
