import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';

final createListChosenPosterStateHolderProvider = StateNotifierProvider<
    CreateListChosenPosterStateHolder, List<(int, String)>>(
  (ref) => CreateListChosenPosterStateHolder([]),
);

class CreateListChosenPosterStateHolder
    extends StateNotifier<List<(int, String)>> {
  CreateListChosenPosterStateHolder(super.state);

  void switchElement((int, String) poster) {
    if (state.any((e) => e.$1 == poster.$1)) {
      state.removeWhere((e) => e.$1 == poster.$1);
      // state.remove(poster);
    } else {
      state.add(poster);
    }
    state = [...state];
  }

  void setElements(List<MultiplePostSingleModel> list) {
    for (var item in list) {
      if (!state.contains(item.image)) {
        state.add((item.id, item.image));
      }
      state = [...state];
    }
  }

  void clear() {
    state = [];
  }
}
