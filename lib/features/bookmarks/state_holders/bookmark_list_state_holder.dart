import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';

final bookmarksListStateHolderProvider =
    StateNotifierProvider<BookmarksListStateHolder, List<PostMovieModel>?>(
  (ref) => BookmarksListStateHolder(null),
);

class BookmarksListStateHolder extends StateNotifier<List<PostMovieModel>?> {
  BookmarksListStateHolder(super.state);

  void updateState(List<PostMovieModel>? value) {
    state = [...?state, ...?value];
  }

  void setState(List<PostMovieModel>? value) {
    state = value;
  }

  void clearState() {
    state = null;
  }
}
