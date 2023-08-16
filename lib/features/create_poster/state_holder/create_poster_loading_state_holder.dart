import 'package:flutter_riverpod/flutter_riverpod.dart';

final createPosterLoadingStateHolderProvider =
StateNotifierProvider<CreatePosterLoaadingStateHolder, bool>(
      (ref) => CreatePosterLoaadingStateHolder(false),
);

class CreatePosterLoaadingStateHolder
    extends StateNotifier<bool> {
  CreatePosterLoaadingStateHolder(super.state);

  void updateValue(bool value) {
    state = value;
  }
}
