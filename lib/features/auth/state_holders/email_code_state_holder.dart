import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailCodeStateHolderProvider =
    StateNotifierProvider<EmailCodeStateHolder, String>(
  (ref) => EmailCodeStateHolder(''),
);

class EmailCodeStateHolder extends StateNotifier<String> {
  EmailCodeStateHolder(String code) : super(code);

  void updateState(String code) {
    state = code;
  }

  void clearState() {
    state = '';
  }
}
