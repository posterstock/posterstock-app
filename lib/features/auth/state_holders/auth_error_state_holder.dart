import 'package:flutter_riverpod/flutter_riverpod.dart';

final authErrorStateHolderProvider = StateNotifierProvider(
  (ref) => AuthErrorStateHolder(null),
);

class AuthErrorStateHolder extends StateNotifier<String?> {
  AuthErrorStateHolder(String? errName) : super(errName);

  void updateState(String errName) {
    state = errName;
  }

  void clearState() {
    state = null;
  }
}
