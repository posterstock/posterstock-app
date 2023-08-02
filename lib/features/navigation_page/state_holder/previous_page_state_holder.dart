import 'package:flutter_riverpod/flutter_riverpod.dart';

final previousPageStateHolderProvider = StateNotifierProvider<PreviousPageStateHolder, List<int>>(
  (ref) => PreviousPageStateHolder([]),
);

class PreviousPageStateHolder extends StateNotifier<List<int>> {
  PreviousPageStateHolder(super.state);

  void updatePage(int page) {
    state.add(page);
    state = [...state];
  }

  void removeLast() {
    state.removeLast();
    state = [...state];
  }
}
