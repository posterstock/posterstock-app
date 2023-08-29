import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';

final searchPostsStateHolderProvider =
    StateNotifierProvider<SearchPostsStateHolder, List<PostMovieModel>?>(
  (ref) => SearchPostsStateHolder(null),
);

class SearchPostsStateHolder extends StateNotifier<List<PostMovieModel>?> {
  SearchPostsStateHolder(super.state);

  void updateState(List<PostMovieModel>? newValue) {
    state = [...?state, ...?newValue];
  }

  void setLikeId(int id, bool liked) {
    for (int i = 0; i < (state?.length ?? 0); i++) {
      if (state![i].id == id) {
        state![i] = state![i].copyWith(
            liked: liked,
            likes: liked ? state![i].likes + 1 : state![i].likes - 1);
      }
    }
    state = [...?state];
  }

  void setState(List<PostMovieModel>? newValue) {
    state = newValue;
  }
}
