import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chosenCoverStateHolderProvider =
StateNotifierProvider<ChosenCoverStateHolder, Uint8List?>(
      (ref) => ChosenCoverStateHolder(null),
);

class ChosenCoverStateHolder extends StateNotifier<Uint8List?> {
  ChosenCoverStateHolder(super.state);

  void setImage(Uint8List? image) {
    state = image;
  }

}
