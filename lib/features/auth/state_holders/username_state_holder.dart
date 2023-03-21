import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernameStateHolderProvider = StateNotifierProvider<UsernameStateHolder, String>(
  (ref) => UsernameStateHolder(),
);

class UsernameStateHolder extends StateNotifier<String> {
  UsernameStateHolder() : super('');

  void updateState(String username) {
    state = username;
  }

  void clearState() {
    state = '';
  }
}
