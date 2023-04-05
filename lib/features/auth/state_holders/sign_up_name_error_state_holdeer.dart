import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpNameErrorStateHolderProvider =
    StateNotifierProvider<SignUpNameErrorStateHolder, String?>(
  (ref) => SignUpNameErrorStateHolder(),
);

class SignUpNameErrorStateHolder extends StateNotifier<String?> {
  SignUpNameErrorStateHolder() : super(null);

  void updateState(String errName) {
    state = errName;
  }

  void clearState() {
    state = null;
  }
}
