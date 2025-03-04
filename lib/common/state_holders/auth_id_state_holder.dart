import 'package:flutter_riverpod/flutter_riverpod.dart';

final authIdStateHolderProvider =
    StateNotifierProvider<AuthIdStateHolder, int?>(
  (ref) => AuthIdStateHolder(null),
);

class AuthIdStateHolder extends StateNotifier<int?> {
  AuthIdStateHolder(int? id) : super(id);

  Future<void> updateState(int id) async {
    //state = await SuperTokens.();
    state = id;
  }

  void clearState() {
    state = null;
  }
}
