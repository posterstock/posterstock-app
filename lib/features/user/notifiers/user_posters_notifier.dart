import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/user/user_network.dart';

final userPostersNotifier = StateNotifierProvider.family
    .autoDispose<UserPostersNotifier, List<PostMovieModel?>, int>(
  (ref, id) => UserPostersNotifier(id).._init(),
);

class UserPostersNotifier extends StateNotifier<List<PostMovieModel?>> {
  final UserNetwork network = UserNetwork();
  final int userId;
  bool _hasMore = true;
  bool _loading = false;
  UserPostersNotifier(this.userId) : super(List.generate(12, (_) => null));

  Future<void> _init() async {
    if (!_hasMore) return;
    final result = await network.getUserPosts(userId);
    state = result.$1 ?? [];
    _hasMore = result.$2;
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    if (_loading) return;
    _loading = true;
    final result = await network.getUserPosts(userId);
    _loading = false;
    state = state + result.$1!;
    _hasMore = result.$2;
  }
}
