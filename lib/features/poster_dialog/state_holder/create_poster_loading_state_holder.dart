import 'package:flutter_riverpod/flutter_riverpod.dart';

final createPosterLoadingStateHolderProvider =
    StateNotifierProvider<CreatePosterLoadingStateHolder, bool>(
  (ref) => CreatePosterLoadingStateHolder(false),
);

class CreatePosterLoadingStateHolder extends StateNotifier<bool> {
  CreatePosterLoadingStateHolder(super.state);

  void updateValue(bool value) {
    state = value;
  }
}
