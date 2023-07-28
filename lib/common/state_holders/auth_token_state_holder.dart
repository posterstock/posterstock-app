import 'package:flutter_riverpod/flutter_riverpod.dart';

final authTokenStateHolderProvider =
    StateNotifierProvider<AuthTokenStateHolder, String?>(
  (ref) => AuthTokenStateHolder(null),
);

class AuthTokenStateHolder extends StateNotifier<String?> {
  AuthTokenStateHolder(String? code) : super(code);

  void updateState(String? code) {
    state = code;
  }

  void clearState() {
    state = null;
  }
}
