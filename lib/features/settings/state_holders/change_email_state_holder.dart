import 'package:flutter_riverpod/flutter_riverpod.dart';

final changeEmailStateHolderProvider =
    StateNotifierProvider<ChangeEmailStateHolder, String>(
  (ref) => ChangeEmailStateHolder(''),
);

class ChangeEmailStateHolder extends StateNotifier<String> {
  ChangeEmailStateHolder(super.state);

  Future<void> setEmail(String email) async {
    state = email;
  }
}
