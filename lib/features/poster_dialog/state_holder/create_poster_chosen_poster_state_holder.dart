import 'package:flutter_riverpod/flutter_riverpod.dart';

final createPosterChosenPosterStateHolderProvider =
StateNotifierProvider<CreatePosterChosenPosterStateHolder, (int, String)?>(
      (ref) => CreatePosterChosenPosterStateHolder(null),
);

class CreatePosterChosenPosterStateHolder
    extends StateNotifier<(int, String)?> {
  CreatePosterChosenPosterStateHolder(super.state);

  void updateValue((int, String)? value) {
    state = value;
  }
}
