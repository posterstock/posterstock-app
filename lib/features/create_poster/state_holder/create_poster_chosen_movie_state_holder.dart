import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/create_poster/model/media_model.dart';

final createPosterChoseMovieStateHolderProvider =
    StateNotifierProvider<CreatePosterChoseMovieStateHolder, MediaModel?>(
  (ref) => CreatePosterChoseMovieStateHolder(null),
);

class CreatePosterChoseMovieStateHolder
    extends StateNotifier<MediaModel?> {
  CreatePosterChoseMovieStateHolder(super.state);

  void updateValue(MediaModel? value) {
    state = value;
  }
}
