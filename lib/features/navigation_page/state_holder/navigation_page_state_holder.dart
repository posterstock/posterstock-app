import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationPageStateHolderProvider =
    StateNotifierProvider<NavigationPageStateHolder, int>(
  (ref) => NavigationPageStateHolder(0),
);

class NavigationPageStateHolder extends StateNotifier<int> {
  NavigationPageStateHolder(super.state);

  Future<void> updatePage(int page) async {
    state = page;
  }

  int get currentState => state;
}
