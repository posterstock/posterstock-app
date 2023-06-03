import 'package:flutter_riverpod/flutter_riverpod.dart';

final changeEmailCodeStateHolderProvider =
StateNotifierProvider<ChangeEmailCodeStateHolder, String>(
      (ref) => ChangeEmailCodeStateHolder(''),
);

class ChangeEmailCodeStateHolder extends StateNotifier<String> {
  ChangeEmailCodeStateHolder(super.state);

  Future<void> setCode(String code) async {
    state = code;
  }
}
