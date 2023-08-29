import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';

final profilePostsStateHolderProvider =
    StateNotifierProvider<ProfilePostsStateHolder, List<PostMovieModel>?>(
  (ref) => ProfilePostsStateHolder(null),
);

class ProfilePostsStateHolder extends StateNotifier<List<PostMovieModel>?> {
  ProfilePostsStateHolder(super.state);

  void updateState(List<PostMovieModel>? list) {
    state = [...(state ?? []), ...?list];
  }

  void setState(List<PostMovieModel>? list) {
    state = [...?list];
  }

  Future<void> clearState() async {
    state = null;
  }
}
