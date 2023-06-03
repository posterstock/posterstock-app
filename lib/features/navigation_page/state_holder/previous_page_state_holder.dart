import 'package:flutter_riverpod/flutter_riverpod.dart';

final previousPageStateHolderProvider = StateNotifierProvider<PreviousPageStateHolder, int>(
  (ref) => PreviousPageStateHolder(0),
);

class PreviousPageStateHolder extends StateNotifier<int> {
  PreviousPageStateHolder(super.state);

  void updatePage(int page) {
    print(page);
    state = page;
  }
}
