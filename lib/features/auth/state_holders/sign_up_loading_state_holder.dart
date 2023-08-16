import 'package:flutter_riverpod/flutter_riverpod.dart';

final signupLoadingStateHolderProvider =
StateNotifierProvider<SignUpLoadingStateHolder, bool>(
      (ref) => SignUpLoadingStateHolder(false),
);

class SignUpLoadingStateHolder extends StateNotifier<bool> {
  SignUpLoadingStateHolder(super.state);

  void setValue(bool value) {
    state = value;
  }
}