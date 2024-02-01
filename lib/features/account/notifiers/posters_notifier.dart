import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/account/account_network.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';

final accountPostersStateNotifier =
    StateNotifierProvider<PostersNotifier, List<PostMovieModel?>>(
  (ref) => PostersNotifier(),
);

class PostersNotifier extends StateNotifier<List<PostMovieModel?>> {
  PostersNotifier() : super(List.generate(12, (_) => null));
  final AccountNetwork network = AccountNetwork();
  bool _hasMore = true;

  void load(int id) async {
    if (!_hasMore) return;
    final result = await network.getPosters(id);
    state = result.$1 ?? [];
    _hasMore = result.$2;
  }
}
