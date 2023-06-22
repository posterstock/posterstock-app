import 'package:flutter_riverpod/flutter_riverpod.dart';

final createPosterImagesStateHolderProvider =
    StateNotifierProvider<CreatePosterImagesStateHolder, List<String>>(
  (ref) => CreatePosterImagesStateHolder([]),
);

class CreatePosterImagesStateHolder extends StateNotifier<List<String>> {
  CreatePosterImagesStateHolder(super.state);

  void updateValue(List<String> value) {
    state = [...state, ...value];
  }

  void setValue(List<String> value) {
    state = value;
  }
}
