import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';

final profileBookmarksStateHolderProvider =
StateNotifierProvider<ProfileBookmarksStateHolder, List<PostMovieModel>?>(
      (ref) => ProfileBookmarksStateHolder(null),
);

class ProfileBookmarksStateHolder extends StateNotifier<List<PostMovieModel>?> {
  ProfileBookmarksStateHolder(super.state);

  void updateState(List<PostMovieModel>? list) {
    for (int i = 0; i < (list?.length ?? 0); i++) {
      for (int j = 0; j < (state?.length ?? 0); j++) {
        if (list![i].id == state![j].id) {
          state!.removeAt(j);
          j--;
        }
      }
    }
    state = [...(state ?? []), ...?list];
  }

  void setState(List<PostMovieModel>? list) {
    state = [...?list];
  }

  Future<void> clearState() async {
    state = null;
  }
}
