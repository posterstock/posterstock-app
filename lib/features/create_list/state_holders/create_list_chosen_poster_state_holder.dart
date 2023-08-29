import 'package:flutter_riverpod/flutter_riverpod.dart';

final createListChosenPosterStateHolderProvider = StateNotifierProvider<
    CreateListChosenPosterStateHolder, List<(int, String)>>(
  (ref) => CreateListChosenPosterStateHolder([]),
);

class CreateListChosenPosterStateHolder
    extends StateNotifier<List<(int, String)>> {
  CreateListChosenPosterStateHolder(super.state);

  void switchElement((int, String) posterIdImage) {
    if (state.contains(posterIdImage)) {
      state.remove(posterIdImage);
    } else {
      state.add(posterIdImage);
    }
    state = [...state];
  }

  void clear() {
    state = [];
  }
}
