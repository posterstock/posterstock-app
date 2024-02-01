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

  void load() async {
    if (!_hasMore) return;
    final result = await network.getBookmarks();
    state = result.$1 ?? [];
    _hasMore = result.$2;
  }
}
