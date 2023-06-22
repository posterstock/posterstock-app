import 'package:flutter_riverpod/flutter_riverpod.dart';

final createPosterChoseMovieStateHolderProvider =
    StateNotifierProvider<CreatePosterChoseMovieStateHolder, (String, String)?>(
  (ref) => CreatePosterChoseMovieStateHolder(null),
);

class CreatePosterChoseMovieStateHolder
    extends StateNotifier<(String, String)?> {
  CreatePosterChoseMovieStateHolder(super.state);

  void updateValue((String, String)? value) {
    state = value;
  }
}
