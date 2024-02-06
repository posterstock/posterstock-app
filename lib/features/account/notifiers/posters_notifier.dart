import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/account/account_network.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';

final accountPostersStateNotifier =
    StateNotifierProvider<PostersNotifier, List<PostMovieModel?>>(
  (ref) => PostersNotifier(),
);

class PostersNotifier extends StateNotifier<List<PostMovieModel?>> {
  //TODO: pass id to constructor
  PostersNotifier() : super(List.generate(12, (_) => null));
  final AccountNetwork network = AccountNetwork();
  bool _hasMore = true;
  bool _loading = false;

  void load(int id) async {
    if (!_hasMore) return;
    final result = await network.getPosters(id);
    state = result.$1 ?? [];
    _hasMore = result.$2;
  }

  Future<void> loadMore(int id) async {
    if (!_hasMore) return;
    if (_loading) return;
    _loading = true;
    final result = await network.getPosters(id);
    _loading = false;
    state = state + result.$1!;
    _hasMore = result.$2;
  }
}
