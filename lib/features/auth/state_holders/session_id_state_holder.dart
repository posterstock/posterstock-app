import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionIdStateHolderProvider =
StateNotifierProvider<SessionIdStateHolder, String>(
      (ref) => SessionIdStateHolder(''),
);

class SessionIdStateHolder extends StateNotifier<String> {
  SessionIdStateHolder(String code) : super(code);

  void updateState(String code) {
    state = code;
  }

  void clearState() {
    state = '';
  }
}