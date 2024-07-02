import 'package:flutter_riverpod/flutter_riverpod.dart';

final chosenCoverStateHolderProvider =
    StateNotifierProvider<ChosenCoverStateHolder, String?>(
  (ref) => ChosenCoverStateHolder(null),
);

class ChosenCoverStateHolder extends StateNotifier<String?> {
  ChosenCoverStateHolder(super.state);

  void setImage(String? image) {
    state = image;
  }

  void clear() {
    state = null;
  }

  String? get currentState => state;
}
