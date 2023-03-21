import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpUsernameErrorStateHolderProvider =
    StateNotifierProvider<SignUpUsernameErrorStateHolder, String?>(
  (ref) => SignUpUsernameErrorStateHolder(),
);

class SignUpUsernameErrorStateHolder extends StateNotifier<String?> {
  SignUpUsernameErrorStateHolder() : super(null);

  void updateState(String errName) {
    state = errName;
  }

  void clearState() {
    state = null;
  }
}
