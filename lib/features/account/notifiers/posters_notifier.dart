import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/account/account_network.dart';
import 'package:poster_stock/features/account/notifiers/account_notifier.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

final accountPostersStateNotifier =
    StateNotifierProvider<PostersNotifier, PostersState>(
  (ref) => PostersNotifier(ref.watch(accountNotifier)).._init(),
);

class PostersNotifier extends StateNotifier<PostersState> {
  PostersNotifier(this.account) : super(const PostersState.holder());

  final UserDetailsModel? account;
  final AccountNetwork network = AccountNetwork();
  bool _hasMore = true;
  bool _loading = false;

  int get _id => account!.id;

  Future<void> _init() async {
    if (account == null) return;
    load();
  }

  Future<void> load() async {
    if (!_hasMore) return;
    final (list, more) = await network.getPosters(_id);
    if (list?.isEmpty ?? true) {
      state = const PostersState.empty();
    } else {
      state = PostersState.list(list!);
    }
    _hasMore = more;
  }

  Future<void> reload() async {
    final (list, more) = await network.getPosters(_id);
    state = PostersState.top(list!);
    _hasMore = more;
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    if (_loading) return;
    _loading = true;
    final result = await network.getPosters(_id);
    _loading = false;
    state = state + result.$1!;
    _hasMore = result.$2;
  }
}

class PostersState {
  final bool top;
  final List<PostMovieModel?> posters;

  const PostersState(this.top, this.posters);

  const PostersState.list(this.posters) : top = false;

  const PostersState.top(this.posters) : top = true;

  const PostersState.holder()
      : top = false,
        posters = const [
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

  const PostersState.empty()
      : top = false,
        posters = const [];

  operator +(List<PostMovieModel> morePosters) =>
      PostersState(false, posters + morePosters);
}
