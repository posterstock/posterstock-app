import 'package:flutter_riverpod/flutter_riverpod.dart';

final createPosterSearchStateHolderNotifier =
    StateNotifierProvider<CreatePosterSearchStateHolder, String>(
  (ref) => CreatePosterSearchStateHolder(''),
);

class CreatePosterSearchStateHolder extends StateNotifier<String> {
  CreatePosterSearchStateHolder(super.state);

  void updateValue(String value) {
    state = value;
  }
}
