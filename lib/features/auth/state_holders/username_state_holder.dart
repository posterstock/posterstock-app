import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernameStateHolderProvider =
    StateNotifierProvider<UsernameStateHolder, String>(
  (ref) => UsernameStateHolder(),
);

class UsernameStateHolder extends StateNotifier<String> {
  UsernameStateHolder() : super('');

  Future<void> updateState(String username) async{
    state = username;
    return;
  }

  void clearState() {
    state = '';
  }
}
