import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/account/account_network.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';

final accountBookmarksStateNotifier =
    StateNotifierProvider<BookmarksNotifier, List<PostMovieModel?>>(
  (ref) => BookmarksNotifier(),
);

class BookmarksNotifier extends StateNotifier<List<PostMovieModel?>> {
  BookmarksNotifier() : super(List.generate(12, (_) => null));
  final AccountNetwork network = AccountNetwork();
  bool _hasMore = true;
  bool _loading = false;

  Future<void> load() async {
    if (!_hasMore) return;
    final result = await network.getBookmarks();
    state = result.$1 ?? [];
    _hasMore = result.$2;
  }

  Future<void> reload() async {
    final result = await network.getBookmarks();
    state = result.$1 ?? [];
    _hasMore = result.$2;
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    if (_loading) return;
    _loading = true;
    final result = await network.getBookmarks();
    _loading = false;
    state = state + result.$1!;
    _hasMore = result.$2;
  }
}
