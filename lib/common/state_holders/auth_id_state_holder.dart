import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supertokens_flutter/supertokens.dart';

final authIdStateHolderProvider =
StateNotifierProvider<AuthIdStateHolder, int?>(
      (ref) => AuthIdStateHolder(null),
);

class AuthIdStateHolder extends StateNotifier<int?> {
  AuthIdStateHolder(int? id) : super(id);

  Future<void> updateState(int id) async{
    //state = await SuperTokens.();
    state = id;
    print(state);
  }

  void clearState() {
    state = null;
  }
}
