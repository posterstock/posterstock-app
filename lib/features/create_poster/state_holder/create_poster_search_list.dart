import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/create_poster/model/media_model.dart';

final createPosterSearchListStateHolderProvider =
StateNotifierProvider<CreatePosterSearchListStateHolder, List<MediaModel>?>(
      (ref) => CreatePosterSearchListStateHolder(null),
);

class CreatePosterSearchListStateHolder extends StateNotifier<List<MediaModel>?> {
  CreatePosterSearchListStateHolder(super.state);

  void updateValue(List<MediaModel> value) {
    state = [...?state, ...value];
  }

  void setValue(List<MediaModel>? value) {
    state = value;
  }
}
