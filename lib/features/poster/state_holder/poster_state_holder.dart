import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';

final posterStateHolderProvider =
StateNotifierProvider<PosterStateHolder, PostMovieModel?>(
      (ref) => PosterStateHolder(null),
);

class PosterStateHolder extends StateNotifier<PostMovieModel?> {
  PosterStateHolder(super.state);

  Future<void> updateState(PostMovieModel? post) async {
    state = post;
  }

  Future<void> clear() async {
    state = null;
  }
}
